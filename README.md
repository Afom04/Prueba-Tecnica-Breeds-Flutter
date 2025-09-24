# 🐶 Dog Breeds App

Aplicación móvil desarrollada en **Flutter** como prueba técnica.  
El objetivo es consultar razas de perros utilizando [TheDogAPI](https://thedogapi.com/), permitiendo ver sus características y guardarlas en una lista de favoritos.  

---

## 🚀 Funcionalidades

- Pantalla **Splash** con logo, nombre y versión del aplicativo.
- Pantalla **Home** con barra de navegación inferior:
  - **Razas**: Lista de razas con campo de búsqueda.
  - **Favoritos**: Lista de razas guardadas como favoritas.
- Pantalla **Detalle** de una raza con:
  - Imagen
  - Nombre
  - Grupo
  - Tiempo de vida
  - Temperamento
  - Origen
- Gestión de estado con **Provider**.
- Uso de **Google Fonts** para un diseño más moderno.

---

## 🛠️ Tecnologías usadas

- [Flutter](https://flutter.dev/) (última versión estable)
- [Provider](https://pub.dev/packages/provider) – gestión de estado
- [HTTP](https://pub.dev/packages/http) – consumo de API
- [Google Fonts](https://pub.dev/packages/google_fonts) – tipografías
- [Package Info Plus](https://pub.dev/packages/package_info_plus) – versión del app

---

## 📂 Estructura del proyecto
lib/
├─ main.dart
├─ core/
│ └─ api_service.dart
├─ models/
│ └─ breed.dart
├─ providers/
│ └─ breeds_provider.dart
├─ screens/
│ ├─ splash_screen.dart
│ ├─ home_screen.dart
│ ├─ breeds_screen.dart
│ ├─ favorites_screen.dart
│ └─ breed_detail_screen.dart
├─ widgets/
│ └─ breed_item.dart

## ⚙️ Instalación y ejecución

1. Clonar el repositorio:
   git clone 
   cd dog_breeds_app

2. Instalar dependencias
    flutter pub get

3. Ejecutar en un emulador o dispositivo físico:
    flutter run
