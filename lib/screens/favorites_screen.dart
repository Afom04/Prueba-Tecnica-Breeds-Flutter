import 'package:dog_breeds_app/widgets/bread_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/breeds_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final breedsProvider = context.watch<BreedsProvider>();

    return breedsProvider.favorites.isEmpty
        ? const Center(
            child: Text("No tienes razas favoritas aún 🐱"),
          )
        : ListView.builder(
            itemCount: breedsProvider.favorites.length,
            itemBuilder: (ctx, i) {
              final breed = breedsProvider.favorites[i];
              return BreedItem(breed: breed);
            },
          );
  }
}
