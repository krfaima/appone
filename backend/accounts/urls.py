from django.urls import path
from .views import RegisterView, VerifyEmailView, LoginView
# from .views import get_parkings, book_parking
# Add these new imports
from .views import nearby_carparks, get_route
from .views import carparks  # Import the view for carparks

urlpatterns = [
    path('register/', RegisterView.as_view(), name='register'),
    path('verify-email/', VerifyEmailView.as_view(), name='verify-email'),
    path('login/', LoginView.as_view(), name='login'),
    # path('parkings/', get_parkings, name='get_parkings'),
    # path('book/', book_parking, name='book_parking'),
    # Add these new endpoints
        path('carparks/', carparks, name='carparks'),
    path('nearby-carparks/', nearby_carparks, name='nearby-carparks'),
    path('route/', get_route, name='route'),
]