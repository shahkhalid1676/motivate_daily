import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../favourites/favourites_controller.dart';

class FavoritesView extends StatelessWidget {
  FavoritesView({super.key});

  final FavoritesController favController = Get.find<FavoritesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites ❤️"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (favController.favorites.isEmpty) {
          return const Center(
            child: Text(
              "No favorites yet!",
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favController.favorites.length,
          itemBuilder: (context, index) {
            final quote = favController.favorites[index];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Hero(
                tag: quote,
                child: Material(
                  color: Colors.transparent,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              quote,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await favController.removeFavorite(quote);
                              Get.snackbar(
                                  "Removed", "Quote removed from favorites ❌");
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
