import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/breed.dart';
import '../providers/breeds_provider.dart';

/// Un widget que muestra un elemento individual de la raza en una lista.
/// Contiene la imagen, nombre, grupo, tiempo de vida y un botón de favoritos.
class BreedItem extends StatelessWidget {
  /// La raza a mostrar en este elemento de la lista.
  final Breed breed;

  /// Constructor para `BreedItem`.
  const BreedItem({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    // Obtiene el `BreedsProvider` para acceder a la lógica de favoritos.
    final provider = context.read<BreedsProvider>();
    // Determina si la raza actual es una de las favoritas.
    final isFavorite = provider.favorites.any((b) => b.id == breed.id);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        // Muestra la imagen de la raza o un icono de placeholder.
        leading: breed.imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(breed.imageUrl!,
                    width: 50, height: 50, fit: BoxFit.cover),
              )
            : const Icon(Icons.pets, size: 40),
        // Muestra el nombre de la raza.
        title: Text(breed.name),
        // Muestra el grupo y el tiempo de vida de la raza.
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(breed.group ?? "Grupo desconocido"),
            if (breed.lifeSpan != null) Text("Edad: ${breed.lifeSpan} años"),
          ],
        ),
        // Botón de favoritos que permite añadir/quitar la raza de favoritos.
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: () => provider.toggleFavorite(breed),
        ),
        // Al tocar el elemento, navega a la pantalla de detalle de la raza.
        onTap: () {
          Navigator.pushNamed(context, "/breed-detail", arguments: breed);
        },
      ),
    );
  }
}
