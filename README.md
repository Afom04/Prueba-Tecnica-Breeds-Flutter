# 🐱 Cat Breeds App

Aplicación móvil desarrollada en **Flutter** como prueba técnica.  
El objetivo es consultar razas de gatos utilizando [TheCatAPI](https://thecatapi.com/), permitiendo ver sus características y guardarlas en una lista de favoritos.  

---

## 🚀 Funcionalidades

- Pantalla **Splash** con logo, nombre y versión del aplicativo, y color de fondo personalizado.
- Pantalla **Home** con barra de navegación inferior:
  - **Razas**: Lista de razas con campo de búsqueda, scroll infinito con paginación, loader y manejo de errores. El header de búsqueda tiene un color de fondo personalizado.
  - **Favoritos**: Lista de razas guardadas como favoritas.
- Pantalla **Detalle** de una raza con:
  - Imagen
  - Nombre
  - Grupo (si disponible, de lo contrario "No disponible")
  - Tiempo de vida
  - Temperamento (mostrado como una lista de chips flexible)
  - Origen
  - Descripción (si disponible)
- Gestión de estado con **Provider**.
- Uso de **Google Fonts** para un diseño más moderno.
- **Manejo de errores** centralizado para llamadas a la API.
- **Icono de aplicación** personalizado (pata de gato) y nombre de aplicación "Cat Breeds".

---

## 🛠️ Tecnologías usadas

- [Flutter](https://flutter.dev/) (última versión estable)
- [Provider](https://pub.dev/packages/provider) – gestión de estado
- [HTTP](https://pub.dev/packages/http) – consumo de API
- [Google Fonts](https://pub.dev/packages/google_fonts) – tipografías
- [Package Info Plus](https://pub.dev/packages/package_info_plus) – versión del app
- [Flutter Launcher Icons](https://pub.dev/packages/flutter_launcher_icons) – generación de iconos de app
- [Cupertino Icons](https://pub.dev/packages/cupertino_icons) – iconos de app

---

## 📂 Estructura del proyecto
lib/
├─ main.dart
├─ core/
│ ├─ api_service.dart
│ ├─ error_service.dart
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
assets/
├─ icon/ 
│ └─ paw_icon.png

## ⚙️ Instalación y ejecución

1. Clonar el repositorio:
   ```bash
   git clone "https://github.com/Afom04/Prueba-Tecnica-Breeds-Flutter.git"
   cd dog_breeds_app
   ```

2. Instalar dependencias:
   ```bash
   flutter pub get
   ```

3. **Colocar el icono de la aplicación:**
   - Asegúrate de tener una imagen cuadrada de alta resolución (PNG o JPEG, min. 512x512px) de tu pata de mascota.  
   - Guarda esta imagen como `paw_icon.png` dentro de la carpeta `assets/icon/` del proyecto.  

4. **Generar los iconos de la aplicación:**
   ```bash
   flutter pub run flutter_launcher_icons:main
   ```

5. Ejecutar en un emulador o dispositivo físico:
   ```bash
   flutter clean
   flutter run
   ```
