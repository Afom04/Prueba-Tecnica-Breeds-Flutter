import 'package:flutter/material.dart';
import '../models/breed.dart';
import 'package:provider/provider.dart';
import '../providers/breeds_provider.dart';

/// Pantalla que muestra los detalles de una raza de gato específica.
class BreedDetailScreen extends StatelessWidget {
  const BreedDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Recupera el objeto Breed pasado como argumento al navegar a esta pantalla.
    final Breed breed = ModalRoute.of(context)!.settings.arguments as Breed;

    return Scaffold(
      appBar: AppBar(
        title: Text(breed.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de la imagen de la raza y botón de favoritos.
            Stack(
              children: [
                // Muestra la imagen de la raza o un placeholder si no hay imagen.
                breed.imageUrl != null
                    ? Image.network(
                        breed.imageUrl!,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 250,
                        color: Colors.grey[300],
                        child: const Center(
                          child:
                              Icon(Icons.image, size: 100, color: Colors.grey),
                        ),
                      ),
                // Botón flotante para añadir/quitar de favoritos.
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () {
                      // Alterna el estado de favorito de la raza y muestra un SnackBar.
                      Provider.of<BreedsProvider>(context, listen: false)
                          .toggleFavorite(breed);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            Provider.of<BreedsProvider>(context, listen: false)
                                    .isFavorite(breed.id)
                                ? '${breed.name} añadido a favoritos'
                                : '${breed.name} eliminado de favoritos',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    backgroundColor: Colors.white,
                    child: Consumer<BreedsProvider>(
                      builder: (context, breedsProvider, child) {
                        // Cambia el icono del corazón según si la raza es favorita.
                        return Icon(
                          breedsProvider.isFavorite(breed.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            // Sección de información detallada de la raza.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre de la raza.
                  Text(
                    breed.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Muestra el temperamento como una lista de Chips con salto de línea.
                  if (breed.temperament != null &&
                      breed.temperament!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Temperamento:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                              height:
                                  8.0), // Espacio entre el título y los chips
                          Wrap(
                            spacing: 8.0, // Espacio entre los chips
                            runSpacing: 4.0, // Espacio entre las filas de chips
                            children: breed.temperament!
                                .split(', ')
                                .map((t) => Chip(
                                      label: Text(t.trim()),
                                      backgroundColor: Colors.blueGrey[50],
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    )
                  else
                    _buildInfoRow('Temperamento',
                        null), // Fallback para cuando no hay temperamento.
                  // Información general de la raza (Grupo, Tiempo de vida, Origen).
                  _buildInfoRow('Grupo',
                      breed.group), // Se mantiene incluso si no hay datos.
                  _buildInfoRow('Tiempo de vida',
                      '${breed.lifeSpan ?? "No disponible"} años'),
                  _buildInfoRow('Origen', breed.origin),
                  const SizedBox(height: 20),
                  // Título de la sección de descripción.
                  const Text(
                    'Acerca de la raza',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Muestra la descripción de la raza o un mensaje si no está disponible.
                  Text(
                    (breed.description != null && breed.description!.isNotEmpty)
                        ? breed.description!
                        : 'No hay descripción disponible para esta raza.',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget auxiliar para construir filas de información (etiqueta: valor).
  /// [label] La etiqueta del campo de información (ej. "Origen").
  /// [value] El valor del campo de información (ej. "Egypt").
  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              value ?? 'No disponible',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
