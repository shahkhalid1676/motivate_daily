class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    // API mein kabhi 'author' null hota hai
    return Quote(
      text: (json['text'] ?? "").toString().trim(),
      author: (json['author'] ?? "Unknown").toString().trim(),
    );
  }
}
