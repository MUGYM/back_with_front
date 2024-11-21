from django.urls import path
from . import views

urlpatterns = [
    path('login/', views.login, name='login'),
    path('callback/', views.callback, name='callback'),
    path('get_token/<str:spotify_id>/', views.get_token, name='get_token'),
    path('search_track/', views.search_track, name='search_track'),
    path('get_audio_url/', views.get_audio_url, name='get_audio_url'),
    path('display_and_save_top_tracks/', views.display_and_save_top_tracks, name='display_and_save_top_tracks'),
    path('get_first_track/', views.get_first_track, name='get_first_track'),
    path('get_multiple_tracks/', views.get_multiple_tracks, name='get_multiple_tracks'),
]
