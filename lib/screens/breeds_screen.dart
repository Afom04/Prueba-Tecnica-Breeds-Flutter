import 'package:dog_breeds_app/widgets/bread_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/breeds_provider.dart';

/// Pantalla principal que muestra una lista de razas de gatos con búsqueda y scroll infinito.
class BreedsScreen extends StatefulWidget {
  const BreedsScreen({super.key});

  @override
  State<BreedsScreen> createState() => _BreedsScreenState();
}

/// Estado asociado a la `BreedsScreen`, gestiona el controlador de texto, el controlador de scroll
/// y la interacción con el `BreedsProvider`.
class _BreedsScreenState extends State<BreedsScreen> {
  /// Controlador para el campo de texto de búsqueda.
  final TextEditingController _controller = TextEditingController();

  /// Controlador para el scroll de la lista, utilizado para detectar el final del scroll.
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Añade un listener al controlador de scroll para detectar el final de la lista.
    _scrollController.addListener(_scrollListener);
    // Carga las razas iniciales después de que el widget se haya construido completamente.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BreedsProvider>().fetchBreeds(context);
    });
  }

  @override
  void dispose() {
    // Libera los recursos del controlador de scroll cuando el widget se destruye.
    _scrollController.dispose();
    super.dispose();
  }

  /// Listener del scroll que detecta cuando el usuario llega al final de la lista
  /// y dispara la carga de más razas si están disponibles.
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<BreedsProvider>().loadMoreBreeds(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escucha los cambios en el BreedsProvider para reconstruir la UI.
    final breedsProvider = context.watch<BreedsProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB2FFFF),
        title: const Text("Razas de Gatos"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(
              60.0), // Define la altura preferida para el widget inferior del AppBar.
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Buscar raza...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Llama a fetchBreeds para realizar una búsqueda con el texto actual.
                    breedsProvider.fetchBreeds(context, _controller.text);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (value) {
                // También permite buscar al presionar Enter en el teclado.
                breedsProvider.fetchBreeds(context, value);
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: breedsProvider.breeds.isEmpty && breedsProvider.isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Muestra loader si no hay razas y está cargando.
                : breedsProvider.breeds.isEmpty &&
                        !breedsProvider.isLoading &&
                        !breedsProvider.hasMore
                    ? const Center(
                        child: Text(
                          "No se encontraron razas.", // Mensaje cuando no hay resultados.
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: breedsProvider.breeds.length +
                            (breedsProvider.hasMore
                                ? 1
                                : 0), // Añade 1 para el loader si hay más razas.
                        itemBuilder: (ctx, i) {
                          if (i == breedsProvider.breeds.length) {
                            return const Center(
                                child:
                                    CircularProgressIndicator()); // Loader al final de la lista.
                          }
                          final breed = breedsProvider.breeds[i];
                          return BreedItem(breed: breed);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
