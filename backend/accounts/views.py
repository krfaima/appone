from rest_framework.response import Response
from rest_framework import status, generics
from rest_framework.decorators import api_view
from rest_framework.views import APIView
from django.contrib.auth import get_user_model, authenticate
from django.utils import timezone
from rest_framework_simplejwt.tokens import RefreshToken
from django.conf import settings
from postmarker.core import PostmarkClient 
import random
import string
from datetime import timedelta

from .serializers import RegisterSerializer, LoginSerializer

from django.http import JsonResponse
# from .models import Parking
from django.views.decorators.csrf import csrf_exempt
import json
# from .models import Parking, Reservation

import math
import requests
from rest_framework import status

from .models import Carpark
from .serializers import CarparkSerializer
from .models import Parking
from .serializers import ParkingSerializer

User = get_user_model()

# ✅ Vue pour l'inscription
class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer

    def perform_create(self, serializer):
        user = serializer.save()
        user.verification_code = self.generate_verification_code()
        user.code_expires_at = timezone.now() + timedelta(minutes=10)
        user.verification_attempts = 0
        user.save()
        self.send_verification_email(user)

    def generate_verification_code(self):
        return ''.join(random.choices(string.digits, k=6))

    def send_verification_email(self, user):
        postmark = PostmarkClient(server_token=settings.POSTMARK_SERVER_TOKEN)
        postmark.emails.send(
            From="selma.abdeslem.0802@univ-sba.dz",
            To=user.email,
            Subject="Verify your email",
            HtmlBody=f"""
                <p>Your verification code is: <strong>{user.verification_code}</strong></p>
                <p>This code expires in 10 minutes. Enter it in the app to verify your email.</p>
            """,
        )

# ✅ Vue pour la vérification de l'email
class VerifyEmailView(APIView):
    def post(self, request):
        email = request.data.get("email")
        code = request.data.get("code")

        try:
            user = User.objects.get(email=email)

            if user.verification_attempts >= 5:
                return Response({"error": "Too many failed attempts. Please request a new code."}, status=status.HTTP_403_FORBIDDEN)
            
            if timezone.now() > user.code_expires_at:
                return Response({"error": "Verification code expired. Please request a new one."}, status=status.HTTP_400_BAD_REQUEST)
            
            if str(user.verification_code).strip() == str(code).strip():
                user.is_verified = True
                user.verification_code = None
                user.code_expires_at = None
                user.verification_attempts = 0
                user.save()
                return Response({"message": "Email verified successfully", "username": user.username}, status=status.HTTP_200_OK)
            else:
                user.verification_attempts += 1
                user.save()
                return Response({"error": "Invalid verification code"}, status=status.HTTP_400_BAD_REQUEST)

        except User.DoesNotExist:
            return Response({"error": "User not found"}, status=status.HTTP_404_NOT_FOUND)

# ✅ Vue pour le login
# ✅ Vue pour le login avec JWT
class LoginView(APIView):
    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        if serializer.is_valid():
            email = serializer.validated_data["email"]
            password = serializer.validated_data["password"]

            try:
                user = User.objects.get(email=email)
            except User.DoesNotExist:
                return Response({"error": "Invalid email or password"}, status=status.HTTP_400_BAD_REQUEST)

            if not user.check_password(password):
                return Response({"error": "Invalid email or password"}, status=status.HTTP_400_BAD_REQUEST)

            if not user.is_verified:
                return Response({"error": "Email not verified. Please check your inbox."}, status=status.HTTP_403_FORBIDDEN)

            # ✅ Générer un token JWT
            refresh = RefreshToken.for_user(user)
            access_token = str(refresh.access_token)

            # ✅ Retourne les infos de l'utilisateur + le token JWT
            return Response({
                "message": "Login successful",
                "user": {
                    "id": user.id,
                    "email": user.email,
                    "username": user.username
                },
                "token": access_token,  # 🔹 Ajout du token JWT
            }, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)



# filepath: c:\src\flutter_app\appone\backend\accounts\views.py
@api_view(['GET'])
def carparks(request):
    carparks = Carpark.objects.all()
    serializer = CarparkSerializer(carparks, many=True)
    return Response(serializer.data)

# Add these imports to your existing views.py
# Add these new view functions

@api_view(['GET'])
def nearby_carparks(request):
    try:
        # Use the underlying Django HttpRequest object if needed
        django_request = request._request

        lat = float(request.query_params.get('lat'))
        lng = float(request.query_params.get('lng'))
    except (TypeError, ValueError):
        return Response({'error': 'Invalid or missing latitude/longitude'}, status=400)

    # Fetch parking data from OpenStreetMap
    parking_locations = fetch_parking_from_osm(lat, lng, radius=5000)

    # Sort parking locations by distance from the user
    for parking in parking_locations:
        parking['distance_from_user'] = calculate_distance(
            lat, lng, parking['latitude'], parking['longitude']
        )
    parking_locations.sort(key=lambda x: x['distance_from_user'])

    return Response(parking_locations)

@api_view(['GET'])
def get_route(request):
    start_lat = request.query_params.get('start_lat')
    start_lng = request.query_params.get('start_lng')
    end_lat = request.query_params.get('end_lat')
    end_lng = request.query_params.get('end_lng')
    
    # Use OpenRouteService for routing
    headers = {
        'Authorization': 'YOUR_OPENROUTE_API_KEY', # Replace with your API key
        'Content-Type': 'application/json; charset=utf-8'
    }
    
    body = {
        "coordinates": [
            [float(start_lng), float(start_lat)],
            [float(end_lng), float(end_lat)]
        ],
        "format": "geojson"
    }
    
    try:
        response = requests.post(
            'https://api.openrouteservice.org/v2/directions/driving-car/geojson',
            json=body,
            headers=headers
        )
        
        if response.status_code == 200:
            data = response.json()
            # Extract coordinates from GeoJSON
            coordinates = data['features'][0]['geometry']['coordinates']
            # Swap lng/lat to lat/lng for Flutter
            route_points = [[point[1], point[0]] for point in coordinates]
            return Response(route_points)
        else:
            # Fallback to straight line if API fails
            return Response([
                [float(start_lat), float(start_lng)],
                [float(end_lat), float(end_lng)]
            ])
    except Exception as e:
        # Fallback to straight line if API fails
        return Response([
            [float(start_lat), float(start_lng)],
            [float(end_lat), float(end_lng)]
        ])

def calculate_distance(lat1, lon1, lat2, lon2):
    # Earth's radius in km
    R = 6371.0
    
    # Convert to radians
    lat1_rad = math.radians(lat1)
    lon1_rad = math.radians(lon1)
    lat2_rad = math.radians(lat2)
    lon2_rad = math.radians(lon2)
    
    # Differences
    dlon = lon2_rad - lon1_rad
    dlat = lat2_rad - lat1_rad
    
    # Haversine formula
    a = math.sin(dlat / 2)**2 + math.cos(lat1_rad) * math.cos(lat2_rad) * math.sin(dlon / 2)**2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    distance = R * c
    
    return distance



    

def fetch_parking_from_osm(lat, lng, radius=5000):
    """
    Fetch parking locations from OpenStreetMap using the Overpass API.
    :param lat: Latitude of the user's location
    :param lng: Longitude of the user's location
    :param radius: Search radius in meters (default: 5000 meters)
    :return: List of parking locations
    """
    url = "https://overpass-api.de/api/interpreter"
    query = f"""
    [out:json];
    node["amenity"="parking"](around:{radius},{lat},{lng});
    out;
    """
    try:
        response = requests.get(url, params={'data': query})
        response.raise_for_status()  # Raise an error for bad HTTP responses
        data = response.json()
        parking_locations = []

        # Extract parking data from the Overpass API response
        for element in data.get('elements', []):
            parking_locations.append({
                'id': element.get('id'),
                'latitude': element.get('lat'),
                'longitude': element.get('lon'),
                'name': element.get('tags', {}).get('name', 'Unnamed Parking'),
                'type': element.get('tags', {}).get('parking', 'unknown'),
            })

        return parking_locations
    except requests.exceptions.RequestException as e:
        print(f"Error fetching parking data from OpenStreetMap: {e}")
        return []
    
    # views.py


class ParkingListAPIView(generics.ListAPIView):
    queryset = Parking.objects.all()
    serializer_class = ParkingSerializer
    def get_serializer_context(self):
        return {'request': self.request}