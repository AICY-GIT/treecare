// lib/models/plant_identification.dart
class PlantIdentification {
  final String scientificName;
  final String commonName;
  final String imageUrl;
  final double score;

  PlantIdentification({
    required this.scientificName,
    required this.commonName,
    required this.imageUrl,
    required this.score,
  });

  factory PlantIdentification.fromJson(Map<String, dynamic> json) {
    // tim value dua theo key va bo vao bien, mac dinh la {}
    final species = json["species"] ?? {};
    final commonNames = List<String>.from(species["commonNames"] ?? []);
    final images = json["images"] as List? ?? [];

    String imageUrl = "";
    if (images.isNotEmpty) {
      final urlObj = images.first["url"];
      if (urlObj is Map) {
        imageUrl = urlObj["o"] ?? urlObj["m"] ?? urlObj["s"] ?? "";
      }
    }

    return PlantIdentification(
      scientificName: species["scientificName"] ?? "",
      commonName: commonNames.isNotEmpty ? commonNames.first : "",
      imageUrl: imageUrl,
      score: (json["score"] ?? 0).toDouble(),
    );
  }
  factory PlantIdentification.fromJsonFirebase(Map<String, dynamic> json) {
      return PlantIdentification(
        scientificName: json["scientificName"] ?? "",
        commonName: json["commonName"] ?? "",
        imageUrl: json["imageUrl"] ?? "",
        score: (json["score"] ?? 0).toDouble(),
      );
  }
  Map<String, dynamic> toJson() {
    return {
      "scientificName": scientificName,
      "commonName": commonName,
      "imageUrl": imageUrl,
      "score": score,
    };
  }
}
