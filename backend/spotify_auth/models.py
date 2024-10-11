from django.db import models
from django.utils import timezone

class SpotifyUser(models.Model):
    spotify_id = models.CharField(max_length=255, unique=True)
    access_token = models.TextField()
    refresh_token = models.TextField()
    token_expiry = models.DateTimeField()
    created_at = models.DateTimeField(auto_now_add=True)

    def is_token_expired(self):
        return self.token_expiry <= timezone.now()

    def __str__(self):
        return self.spotify_id
