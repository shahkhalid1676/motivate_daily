import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});
}

class QuoteController extends GetxController {
  var currentQuote = Rxn<Quote>();
  var isLoading = false.obs;
  var errorMessage = "".obs;

  final quotesApi = "https://zenquotes.io/api/random"; // example API

  Future<void> getRandomQuote() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final response = await http.get(Uri.parse(quotesApi));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)[0];
        currentQuote.value = Quote(
          text: data["q"] ?? "No quote",
          author: data["a"] ?? "Unknown",
        );
      } else {
        errorMessage.value = "Failed to load quote";
      }
    } catch (e) {
      errorMessage.value = "Something went wrong!";
    } finally {
      isLoading.value = false;
    }
  }
}
