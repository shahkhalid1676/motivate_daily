import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/quote_model.dart';


class QuoteService {
  final String _baseUrl = "https://type.fit/api/quotes";
  // ✅ Free API (20k+ motivational quotes)

  Future<List<Quote>> getQuotes() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        return data.map((q) => Quote.fromJson(q)).toList();
      } else {
        throw Exception("Failed to fetch quotes: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching quotes: $e");
    }
  }
}
