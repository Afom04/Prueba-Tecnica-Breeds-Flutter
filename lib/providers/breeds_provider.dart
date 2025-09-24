import 'package:flutter/foundation.dart';
import '../models/breed.dart';
import '../core/api_service.dart';
import 'package:flutter/material.dart';

/// `BreedsProvider` gestiona el estado de las razas de gatos,
/// incluyendo la carga de datos, paginación, búsqueda y gestión de favoritos.
class BreedsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Breed> _breeds = [];
  List<Breed> _favorites = [];
  bool _isLoading = false;
  int _page = 0;
  final int _limit = 10; // Número de razas por página a cargar por defecto.
  bool _hasMore = true; // Indica si hay más razas disponibles para cargar.

  /// Retorna el estado actual de carga de datos.
  bool get isLoading => _isLoading;

  /// Retorna la lista de razas cargadas.
  List<Breed> get breeds => _breeds;

  /// Retorna la lista de razas favoritas.
  List<Breed> get favorites => _favorites;

  /// Retorna la página actual de resultados.
  int get page => _page;

  /// Retorna si hay más razas disponibles para cargar.
  bool get hasMore => _hasMore;

  /// Verifica si una raza específica está en la lista de favoritos.
  /// [breedId] El ID de la raza a verificar.
  /// Retorna `true` si la raza es favorita, `false` en caso contrario.
  bool isFavorite(String breedId) {
    return _favorites.any((breed) => breed.id == breedId);
  }

  /// Carga las razas de gatos desde la API con soporte de paginación y búsqueda.
  /// [context] El BuildContext necesario para mostrar SnackBar de errores.
  /// [query] Opcional. Término de búsqueda para filtrar las razas.
  /// [isLoadMore] Indica si la llamada es para cargar más elementos (scroll infinito).
  Future<void> fetchBreeds(BuildContext context,
      [String query = "", bool isLoadMore = false]) async {
    // Evita llamadas múltiples si ya se está cargando o no hay más datos.
    if (_isLoading && isLoadMore) return;
    if (!_hasMore && isLoadMore) return;

    _isLoading = true;
    // Limpia las razas y reinicia la página solo en la carga inicial o nueva búsqueda.
    if (!isLoadMore) {
      _breeds = [];
      _page = 0;
    }
    notifyListeners(); // Notifica a los listeners que el estado de carga ha cambiado.

    try {
      // Realiza la llamada a la API para obtener las nuevas razas.
      List<Breed> newBreeds = await _apiService.getBreeds(
          context: context, query: query, page: _page, limit: _limit);

      // Actualiza el estado de `_hasMore` si no se cargaron suficientes razas para una página completa.
      if (newBreeds.isEmpty || newBreeds.length < _limit) {
        _hasMore = false;
      } else {
        _hasMore = true;
      }
      _breeds.addAll(newBreeds); // Añade las nuevas razas a la lista existente.
      _page++; // Incrementa el número de página.
    } catch (e) {
      // En caso de error, marca que no hay más datos disponibles.
      _hasMore = false;
    } finally {
      _isLoading = false; // Finaliza el estado de carga.
      notifyListeners(); // Notifica a los listeners que el estado ha cambiado.
    }
  }

  /// Carga la siguiente página de razas si no se está cargando ya y hay más datos disponibles.
  /// [context] El BuildContext necesario para `fetchBreeds`.
  void loadMoreBreeds(BuildContext context) {
    if (!_isLoading && _hasMore) {
      fetchBreeds(context, "", true);
    }
  }

  /// Añade o elimina una raza de la lista de favoritos.
  /// [breed] La raza a añadir/eliminar de favoritos.
  void toggleFavorite(Breed breed) {
    if (_favorites.any((b) => b.id == breed.id)) {
      _favorites.removeWhere((b) => b.id == breed.id);
    } else {
      _favorites.add(breed);
    }
    notifyListeners(); // Notifica a los listeners que la lista de favoritos ha cambiado.
  }
}
