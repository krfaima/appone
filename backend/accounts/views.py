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








class ParkingListAPIView(generics.ListAPIView):
    queryset = Parking.objects.all()
    serializer_class = ParkingSerializer
    def get_serializer_context(self):
        return {'request': self.request}
    
