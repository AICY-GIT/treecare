class WikiSummary {
  final String title;
  final String description;
  final String extract;
  final String imageUrl;
  final String pageUrl;

  WikiSummary({
    required this.title,
    required this.description,
    required this.extract,
    required this.imageUrl,
    required this.pageUrl,
  });

  factory WikiSummary.fromJson(Map<String, dynamic> json) {
    return WikiSummary(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      //mo ta chi tiet
      extract: json['extract'] ?? '',
      imageUrl: json['thumbnail']?['source'] ?? '',
      pageUrl: json['content_urls']?['desktop']?['page'] ?? '',
    );
  }
  //for testing
  @override
  String toString() {
    return '''
      WikiSummary(
      title: $title,
      description: $description,
      extract: $extract,
      imageUrl: $imageUrl,
      pageUrl: $pageUrl)''';
  } 
}
