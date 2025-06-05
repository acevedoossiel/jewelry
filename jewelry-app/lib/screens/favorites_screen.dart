import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jewelry_app/models/jewelry_model.dart';
import 'package:jewelry_app/providers/jewelry_providers.dart';
import 'package:jewelry_app/screens/jewelry_details.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<JewelryProviders>(
        builder: (context, jewelryProviders, child) {
          final favoriteItems = jewelryProviders.favoriteJewelry;

          if (jewelryProviders.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return favoriteItems.isEmpty
              ? const Center(child: Text("Sin joyas favoritas"))
              : ListView.builder(
                itemCount: favoriteItems.length,
                itemBuilder: (context, index) {
                  final item = favoriteItems[index];
                  return FavoriteJewelryCard(jewelry: item);
                },
              );
        },
      ),
    );
  }
}

class FavoriteJewelryCard extends StatelessWidget {
  final JewelryModel jewelry;
  const FavoriteJewelryCard({super.key, required this.jewelry});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JewelryDetails(jewelryData: jewelry),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
          child: Row(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.pinkAccent.shade100,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    jewelry.imageLink,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jewelry.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'QuikSand',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      color: colors.primary,
                      height: 2,
                      width: size.width * 0.4,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Material: ${jewelry.material}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
