from django.urls import path
from . import views

urlpatterns = [
    path('', views.search_track, name='search_track'),
    path('login/', views.login, name='login'),
    path('callback/', views.callback, name='callback'),
    path('token/<str:sportify_id>/', views.get_token, name='get_token'),
    path('search-track/', views.search_track, name='search_track'),
]