import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tree_care/models/wiki_summary_model.dart';

Future<WikiSummary> fetchWikiSummary(String title) async {
  var name = cleanScientificName(title);
  final url = Uri.parse(
    'https://en.wikipedia.org/api/rest_v1/page/summary/${Uri.encodeComponent(name)}',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print("Wikipedia response for $name: $data");
    return WikiSummary.fromJson(data);
  } else {
    throw Exception('Failed to load summary');
  }
}
String cleanScientificName(String name) {
  final parts = name.split(' ');

  if (parts.length >= 2) {
    final genus = parts[0];
    final species = parts[1];
    return '${genus}_$species';
  }
  return name.replaceAll(RegExp(r'[^a-zA-Z]'), '');
}

