
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('accounts/', include('accounts.urls')),
# 🔹 Vérifie que ton app est bien incluse ici
]



urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

