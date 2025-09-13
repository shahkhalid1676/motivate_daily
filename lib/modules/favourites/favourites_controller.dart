
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  var favorites = <String>[].obs;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await _firestore.collection("users").doc(uid).collection("favorites").get();
    favorites.value = snapshot.docs.map((doc) => doc["quote"] as String).toList();
  }

  Future<void> addFavorite(String quote) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    if (!favorites.contains(quote)) {
      favorites.add(quote);
      await _firestore.collection("users").doc(uid).collection("favorites").add({"quote": quote});
      Get.snackbar("Added ❤️", "Quote added to favorites!");
    }
  }

  Future<void> removeFavorite(String quote) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    favorites.remove(quote);
    final snapshot = await _firestore.collection("users").doc(uid).collection("favorites")
        .where("quote", isEqualTo: quote)
        .get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
    Get.snackbar("Removed ❌", "Quote removed from favorites.");
  }
}
