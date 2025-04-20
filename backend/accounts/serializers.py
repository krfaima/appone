from rest_framework import serializers
from .models import CustomUser
from .models import Carpark
from .models import Parking

class RegisterSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ['id', 'email', 'username', 'password']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = CustomUser.objects.create_user(**validated_data)
        return user

class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)




        # Add this to your existing serializers.py
class CarparkSerializer(serializers.ModelSerializer):
    class Meta:
        model = Carpark
        fields = '__all__'
        
        # serializers.py


class ParkingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Parking
        fields = '__all__'