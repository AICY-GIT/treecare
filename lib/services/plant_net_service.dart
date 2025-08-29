import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tree_care/models/plant_net.dart';

class PlantNetService {
  final String project;

  PlantNetService({this.project = "all"});

  /// Identify plant and return simplified model
  Future<List<PlantIdentification>> identifyPlant(File imageFile) async {
    //paramater
    var nbResults=5;
    var type='kt';
    var apiKey='2b10kAT97dEoBqLgZsKogAOltO';

    final url = Uri.https("my-api.plantnet.org","/v2/identify/all",
      {
        "api-key": apiKey,
        "include-related-images":"true",
        "nb-results":nbResults.toString(),
        "lang": "en",
        "type":type,
      },
    );

    final request = http.MultipartRequest("POST", url)
      ..files.add(await http.MultipartFile.fromPath("images", imageFile.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final results = decoded["results"] as List? ?? [];
      return results.map((r) => PlantIdentification.fromJson(r)).toList();
    } else {
      throw Exception(
        "PlantNet API error: ${response.statusCode} ${response.reasonPhrase}\n${response.body}",
      );
    }
  }
}
