# Ejercitapp
Bitacora de ejercicio

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
