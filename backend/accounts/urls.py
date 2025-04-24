from django.urls import path
from .views import RegisterView, VerifyEmailView, LoginView
from .views import ParkingListAPIView



urlpatterns = [
    path('register/', RegisterView.as_view(), name='register'),
    path('verify-email/', VerifyEmailView.as_view(), name='verify-email'),
    path('login/', LoginView.as_view(), name='login'),
    path('parkings/', ParkingListAPIView.as_view(), name='parking-list'),

]
