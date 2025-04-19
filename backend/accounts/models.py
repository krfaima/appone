from django.contrib.auth.models import AbstractUser
from django.db import models
from datetime import datetime, timedelta



class CustomUser(AbstractUser):
    email = models.EmailField(unique=True)
    is_verified = models.BooleanField(default=False)
    verification_code = models.CharField(max_length=6, null=True, blank=True)
    code_expires_at = models.DateTimeField(null=True, blank=True)
    verification_attempts = models.IntegerField(default=0)  # Limite d'essais

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']

    def generate_verification_code(self):
        """Génère un code de vérification à 6 chiffres"""
        import random
        self.verification_code = f"{random.randint(100000, 999999)}"
        self.code_expires_at = datetime.now() + timedelta(minutes=10)  # Expiration dans 10 min
        self.verification_attempts = 0  # Réinitialisation des tentatives
        self.save()


        # Add this to your existing models.py
class Carpark(models.Model):
    name = models.CharField(max_length=255)
    latitude = models.FloatField()
    longitude = models.FloatField()
    address = models.CharField(max_length=255, null=True, blank=True)
    price = models.FloatField(null=True, blank=True)
    total_spots = models.IntegerField(null=True, blank=True)
    available_spots = models.IntegerField(null=True, blank=True)
    
    def __str__(self):
        return self.name