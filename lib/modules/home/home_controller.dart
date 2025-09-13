import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/app_constants.dart';

class HomeController extends GetxController {
  var quote = "".obs;
  var author = "".obs;
  var isLoading = false.obs;
  var errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final response = await http.get(Uri.parse(AppConstants.quotesApi));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        quote.value = data[0]["q"];
        author.value = data[0]["a"];
      } else {
        errorMessage.value = "Failed to load quote 😢";
      }
    } catch (e) {
      errorMessage.value = "Something went wrong!";
    } finally {
      isLoading.value = false;
    }
  }
}
