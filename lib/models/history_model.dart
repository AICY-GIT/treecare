import 'package:tree_care/models/plant_net_model.dart';

class ScanHistory {
  final String base64Image;
  final List<PlantIdentification>results;
  final DateTime timestamp;

  ScanHistory({
    required this.base64Image,
    required this.results,
    required this.timestamp,
  });
  
  factory ScanHistory.fromJson(Map<String, dynamic> json) {
    List<PlantIdentification> parsedResults = [];
    //kiem tra co nul k
    if (json['results'] != null && json['results'] is List) {
      for (var item in json['results']) {
        parsedResults.add(PlantIdentification.fromJsonFirebase(Map<String, dynamic>.from(item)));
      }
    }
    return ScanHistory(
      base64Image: json['base64Image'],
      results: parsedResults,
      timestamp: DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['timestamp'].toString()) ?? 0,),
    );
  }
}