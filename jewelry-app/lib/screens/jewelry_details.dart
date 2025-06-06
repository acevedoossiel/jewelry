import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jewelry_app/models/jewelry_model.dart';
import 'package:jewelry_app/providers/jewelry_providers.dart';
import 'package:jewelry_app/providers/cart_provider.dart';
import 'package:jewelry_app/screens/cart_screen.dart';
import 'package:video_player/video_player.dart';

class JewelryDetails extends StatefulWidget {
  final JewelryModel jewelryData;

  const JewelryDetails({super.key, required this.jewelryData});

  @override
  State<JewelryDetails> createState() => _JewelryDetailsState();
}

class _JewelryDetailsState extends State<JewelryDetails> {
  Map<int, VideoPlayerController> _videoControllers = {};
  bool isFavorite = false;
  double _currentVolume = 1.0;

  @override
  void dispose() {
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<JewelryProviders>(context, listen: false);
    isFavorite = provider.favoriteJewelry.contains(widget.jewelryData);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: Text(
          widget.jewelryData.name,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Provider.of<JewelryProviders>(
                context,
                listen: false,
              ).toggleFavoriteStatus(widget.jewelryData);

              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder:
                  (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
                key: ValueKey<bool>(isFavorite),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Carrusel con altura específica
            SizedBox(
              height: size.height * 0.3,
              width: double.infinity,
              child: PageView.builder(
                itemCount: widget.jewelryData.mediaLinks.length,
                itemBuilder: (context, index) {
                  final link = widget.jewelryData.mediaLinks[index];

                  if (link.endsWith('.mp4') || link.contains('video')) {
                    // Si no existe un controlador, lo creamos con manejo de error y timeout
                    if (!_videoControllers.containsKey(index)) {
                      final controller = VideoPlayerController.networkUrl(
                        Uri.parse(link),
                      );
                      _videoControllers[index] = controller;

                      controller
                          .initialize()
                          .timeout(
                            const Duration(seconds: 5),
                            onTimeout: () {
                              debugPrint(
                                '⏱️ Tiempo de espera superado al cargar video $link',
                              );
                              controller.dispose();
                              _videoControllers.remove(index);
                              setState(() {});
                            },
                          )
                          .then((_) {
                            setState(() {});
                          })
                          .catchError((error) {
                            debugPrint(
                              '❌ Error al inicializar el video $link: $error',
                            );
                            controller.dispose();
                            _videoControllers.remove(index);
                            setState(() {});
                          });
                    }

                    final controller = _videoControllers[index];

                    // Si el controlador aún no está disponible o fue eliminado
                    if (controller == null || !controller.value.isInitialized) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return GestureDetector(
                      onTap: () {
                        if (controller.value.isPlaying) {
                          controller.pause();
                        } else {
                          controller.play();
                        }
                        setState(() {});
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: VideoPlayer(controller),
                          ),
                          if (!controller.value.isPlaying)
                            const Icon(
                              Icons.play_circle_fill,
                              size: 64,
                              color: Colors.white,
                            ),

                          // ✅ Botones de volumen
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Column(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.volume_up,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _currentVolume += 0.1;
                                      if (_currentVolume > 1.0)
                                        _currentVolume = 1.0;
                                      controller.setVolume(_currentVolume);
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.volume_down,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _currentVolume -= 0.1;
                                      if (_currentVolume < 0.0)
                                        _currentVolume = 0.0;
                                      controller.setVolume(_currentVolume);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Si es imagen
                  return Image.network(
                    link,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => const Icon(
                          Icons.image_not_supported,
                          size: 100,
                          color: Colors.grey,
                        ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
            Text(
              widget.jewelryData.name,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 22,
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text("Material: ${widget.jewelryData.material}"),
            const SizedBox(height: 5),
            Text(
              "Precio: \$${widget.jewelryData.price.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: size.width * 0.5,
              height: 3,
              color: colors.primary,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Características:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 6),
            ...widget.jewelryData.details.map((detail) => Text("• $detail")),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Provider.of<CartProvider>(
                  context,
                  listen: false,
                ).addToCart(widget.jewelryData);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Producto añadido al carrito")),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text("Agregar al carrito"),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
