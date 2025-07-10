# Ejercitapp
Bitacora de ejercicio
# Para iniciar los test
### Para pruebas e2e
flutter test integration_test/app_test.dart
### Para el resto de test
flutter test
### Para coverage
flutter test --coverage 



# Antes de iniciar la app

### Cambiar nombre a .env.example 
cp .env.example .env
### Añade tu api key de openweather en .env para visualizar datos del clima (el valor ya esta definido en el example)
OPENWEATHER_API_KEY:
### Descarga las dependencias
flutter pub get
### Utiliza el emulador de tu eleccion
flutter emulators --launch "example: device"
### Inicia la aplicación
flutter run
