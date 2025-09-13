import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:share_plus/share_plus.dart';

import '../auth/auth_controller/auth_controller.dart';
import '../favourites/favourites_controller.dart';
import 'controllers/quotes_controller.dart';
import '../../../core/theme/theme_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  // Controllers
  final QuoteController controller = Get.put(QuoteController());
  final FavoritesController favController = Get.put(FavoritesController());
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.put(ThemeController());

  final AudioPlayer player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;

      return Scaffold(

        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [Colors.indigo.shade900, Colors.purple.shade700]
                  : [Colors.purple.shade200, Colors.blue.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "InspireMe ✨",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(isDark
                                ? Icons.dark_mode
                                : Icons.light_mode),
                            color: isDark ? Colors.white : Colors.black87,
                            onPressed: () => themeController.toggleTheme(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite),
                            color: isDark ? Colors.white : Colors.redAccent,
                            onPressed: () => Get.toNamed("/favorites"),
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout),
                            color: isDark ? Colors.white : Colors.black87,
                            onPressed: () async {
                              await authController.logout();
                              Get.offAllNamed("/login");
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                // Quote Section
                Expanded(
                  child: Center(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const CircularProgressIndicator();
                      } else if (controller.errorMessage.isNotEmpty) {
                        return Text(
                          controller.errorMessage.value,
                          style: const TextStyle(fontSize: 18),
                        );
                      } else if (controller.currentQuote.value != null) {
                        final quote = controller.currentQuote.value!;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 700),
                              transitionBuilder: (child, animation) =>
                                  ScaleTransition(
                                    scale: animation,
                                    child: FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                  ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Text(
                                  "\"${quote.text}\"",
                                  key: ValueKey(quote.text),
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontStyle: FontStyle.italic,
                                    color:
                                    isDark ? Colors.white : Colors.black87,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 4,
                                        color: Colors.black26,
                                        offset: const Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "- ${quote.author}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color:
                                isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Favorite & Share buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(() {
                                  final isFav = favController.favorites
                                      .contains(quote.text);
                                  return IconButton(
                                    icon: Icon(
                                      isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 32,
                                      color: isFav ? Colors.red : Colors.white,
                                    ),
                                    onPressed: () {
                                      if (isFav) {
                                        favController.removeFavorite(quote.text);
                                      } else {
                                        favController.addFavorite(quote.text);
                                        Get.snackbar(
                                            "Added", "Quote added to favorites ❤️");
                                      }
                                    },
                                  );
                                }),
                                const SizedBox(width: 20),
                                IconButton(
                                  icon: const Icon(Icons.share, size: 32),
                                  color: isDark ? Colors.white : Colors.black87,
                                  onPressed: () {
                                    Share.share(
                                        "\"${quote.text}\" - ${quote.author}");
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return const Text(
                          "Tap 'Inspire Me' to get a quote!",
                          style: TextStyle(fontSize: 18),
                        );
                      }
                    }),
                  ),
                ),

                // Inspire Me Button
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor:
                      isDark ? Colors.purpleAccent : Colors.deepPurple,
                    ),
                    onPressed: () async {
                      await player.stop();
                      await player.play(
                          AssetSource("audio/Chime-sound.mp3"));
                      await controller.getRandomQuote();
                    },
                    child: const Text(
                      "Inspire Me",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
