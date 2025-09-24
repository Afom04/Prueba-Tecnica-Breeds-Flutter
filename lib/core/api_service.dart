import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/breed.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'error_service.dart';

/// Servicio para interactuar con la API de TheCatAPI.
/// Gestiona las solicitudes HTTP y el parseo inicial de los datos de razas.
class ApiService {
  /// URL base de la API de TheCatAPI.
  static const String baseUrl = "https://api.thecatapi.com/v1";

  /// Clave de API para autenticación en TheCatAPI.
  static const String apiKey =
      'live_T360G12hGTOxTj6pcZdl3JCS4qhKVZl8WKxm1Fdl1fTDCxWbnGX1jeEsuZZLdGHv';

  /// Obtiene una lista paginada de razas de gatos, con opción de búsqueda.
  /// Las imágenes de las razas se obtienen en paralelo después de la carga inicial.
  Future<List<Breed>> getBreeds(
      {required BuildContext context,
      String query = "",
      int page = 0,
      int limit = 10}) async {
    String apiUrl;
    // Construye la URL de la API con los parámetros de paginación y búsqueda.
    if (query.isEmpty) {
      apiUrl = "$baseUrl/breeds?limit=$limit&page=$page";
    } else {
      apiUrl = "$baseUrl/breeds/search?q=$query&limit=$limit&page=$page";
    }

    try {
      // Realiza la solicitud HTTP para obtener la lista de razas.
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"x-api-key": apiKey},
      );

      if (response.statusCode == 200) {
        // Decodifica la respuesta JSON y la convierte en una lista de objetos Breed.
        List data = json.decode(response.body);
        List<Breed> breeds = data.map((e) => Breed.fromJson(e)).toList();

        // Prepara tareas para obtener las URLs de las imágenes de cada raza en paralelo.
        List<Future<void>> imageFetchTasks = [];
        for (int i = 0; i < breeds.length; i++) {
          if (breeds[i].referenceImageId != null) {
            imageFetchTasks.add(() async {
              // Obtiene la URL de la imagen y actualiza el objeto Breed correspondiente.
              String? imageUrl =
                  await _fetchImageUrl(context, breeds[i].referenceImageId!);
              if (imageUrl != null) {
                breeds[i] = breeds[i].copyWith(imageUrl: imageUrl);
              }
            }());
          }
        }
        // Espera a que todas las tareas de obtención de imágenes se completen.
        await Future.wait(imageFetchTasks);
        return breeds;
      } else {
        // Manejo de errores para respuestas HTTP no exitosas.
        ErrorService.showErrorSnackBar(context,
            "Error ${response.statusCode}: ${response.reasonPhrase ?? 'Error desconocido'}");
        return [];
      }
    } on SocketException {
      // Manejo de errores de conexión a internet.
      ErrorService.showErrorSnackBar(context, "No hay conexión a internet.");
      return [];
    } catch (e) {
      // Manejo de otros errores inesperados durante la solicitud.
      ErrorService.showErrorSnackBar(
          context, "Ocurrió un error inesperado: $e");
      return [];
    }
  }

  /// Obtiene la URL de una imagen de raza dado su `referenceImageId`.
  Future<String?> _fetchImageUrl(
      BuildContext context, String referenceImageId) async {
    try {
      // Realiza la solicitud HTTP para obtener la imagen.
      final response = await http.get(
        Uri.parse("$baseUrl/images/$referenceImageId"),
        headers: {"x-api-key": apiKey},
      );

      if (response.statusCode == 200) {
        // Decodifica la respuesta JSON y retorna la URL de la imagen.
        final data = json.decode(response.body);
        return data["url"];
      } else {
        // Manejo de errores para respuestas HTTP no exitosas.
        ErrorService.showErrorSnackBar(context,
            "Error ${response.statusCode}: No se pudo cargar la imagen para $referenceImageId");
        return null;
      }
    } on SocketException {
      // Manejo de errores de conexión a internet.
      ErrorService.showErrorSnackBar(
          context, "No hay conexión a internet para cargar la imagen.");
      return null;
    } catch (e) {
      // Manejo de otros errores inesperados durante la solicitud.
      ErrorService.showErrorSnackBar(
          context, "Ocurrió un error inesperado al cargar la imagen: $e");
      return null;
    }
  }
}
