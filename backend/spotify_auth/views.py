import requests
from django.shortcuts import redirect
from django.conf import settings
from django.utils import timezone
from django.http import JsonResponse
import base64

from .models import SpotifyUser

def login(request):
    scope = 'user-read-private user-read-email user-modify-playback-state'
    auth_url = (
        f"https://accounts.spotify.com/authorize?response_type=code"
        f"&client_id={settings.SPOTIFY_CLIENT_ID}&scope={scope}"
        f"&redirect_uri={settings.SPOTIFY_REDIRECT_URI}"
    )

    return redirect(auth_url)

def callback(request):
    code = request.GET.get('code')
    print(f"Received code: {code}")
    print(f"Full request path: {request.get_full_path()}")  # 추가 로그
    

    # 1. Check if the code is present
    if not code:
        return JsonResponse({'error': 'No code provided'}, status=400)

    # 2. Prepare data and headers for token request
    token_url = 'https://accounts.spotify.com/api/token'
    token_data = {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': settings.SPOTIFY_REDIRECT_URI,
    }
    client_creds = f"{settings.SPOTIFY_CLIENT_ID}:{settings.SPOTIFY_CLIENT_SECRET}"
    client_creds_b64 = base64.b64encode(client_creds.encode())

    token_headers = {
        'Authorization': f'Basic {client_creds_b64.decode()}',
        'Content-Type': 'application/x-www-form-urlencoded'
    }

    # 3. Attempt to request token
    try:
        response = requests.post(token_url, data=token_data, headers=token_headers)
    except requests.exceptions.RequestException as e:
        return JsonResponse({'error': f'Request failed: {str(e)}'}, status=500)

    # 4. Check response status code
    if response.status_code != 200:
        return JsonResponse({'error': 'Failed to retrieve token', 'details': response.json()}, status=response.status_code)

    # 5. Handle token data
    token_data = response.json()
    if 'access_token' not in token_data:
        return JsonResponse({'error': 'No access token in response', 'details': token_data}, status=400)

    # 6. Process the successful token retrieval
    access_token = token_data['access_token']
    refresh_token = token_data.get('refresh_token')
    expires_in = token_data['expires_in']
    token_expiry = timezone.now() + timezone.timedelta(seconds=expires_in)

    # 7. Request user profile
    profile_url = 'https://api.spotify.com/v1/me'
    profile_headers = {'Authorization': f'Bearer {access_token}'}
    profile_response = requests.get(profile_url, headers=profile_headers)

    if profile_response.status_code != 200:
        return JsonResponse({'error': 'Failed to retrieve profile', 'details': profile_response.json()}, status=profile_response.status_code)

    profile_data = profile_response.json()
    spotify_id = profile_data.get('id')

    # 8. Save or update user information
    SpotifyUser.objects.update_or_create(
        spotify_id=spotify_id,
        defaults={
            'access_token': access_token,
            'refresh_token': refresh_token,
            'token_expiry': token_expiry,
        }
    )

    # 9. Return success message
    return JsonResponse({'message': 'Login successful', 'spotify_id': spotify_id})


def get_token(request, spotify_id):
    try:
        spotify_user = SpotifyUser.objects.get(spotify_id=spotify_id)

        # Check if the token is expired and refresh if needed
        if spotify_user.is_token_expired():
            token_url = 'https://accounts.spotify.com/api/token'
            token_data = {
                'grant_type': 'refresh_token',
                'refresh_token': spotify_user.refresh_token,
                'client_id': settings.SPOTIFY_CLIENT_ID,
                'client_secret': settings.SPOTIFY_CLIENT_SECRET,
            }

            response = requests.post(token_url, data=token_data)
            token_data = response.json()

            # Update access token and expiry time
            spotify_user.access_token = token_data['access_token']
            expires_in = token_data['expires_in']
            spotify_user.token_expiry = timezone.now() + timezone.timedelta(seconds=expires_in)
            spotify_user.save()

        return JsonResponse({'access_token': spotify_user.access_token})
    except SpotifyUser.DoesNotExist:
        return JsonResponse({'error': 'User not found'}, status=404)


def search_track(request):
    query = request.GET.get('query', '')

    if not query:
        return JsonResponse({'error': 'No query provided'}, status=400)
    
    spotify_user = SpotifyUser.objects.first()
    access_token = spotify_user.access_token

    search_url = 'https://api.spotify.com/v1/search'
    headers = {
        'Authorization': f'Bearer {access_token}'
    }
    params = {
        'q': query,
        'type': 'track',
        'limit': 10
    }

    response = requests.get(search_url, headers=headers, params=params)

    if response.status_code != 200:
        return JsonResponse({'error': 'Spotify API request failed'}, status=response.status_code)
        
    search_results = response.json()

    if 'tracks' in search_results and search_results['tracks']['items']:
        return JsonResponse({'tracks': search_results['tracks']['items']})
    else:
        return JsonResponse({'error': 'No tracks found'}, status=404)
