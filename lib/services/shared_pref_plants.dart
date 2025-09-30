import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_care/services/plant_services.dart';

class PlantSharedPref {
  static const _plantsKey = 'plants';

  /// Fetch từ Firebase 1 lần và lưu vào SharedPreferences
  static Future<void> fetchAndSavePlantsToSharedPreferences(
      PlantService plantService) async {
    final snapshot = await plantService.getPlantsOnce();
    if (snapshot != null && snapshot.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_plantsKey, jsonEncode(snapshot));
    }
  }

  /// Load toàn bộ cây từ SharedPreferences
  static Future<Map<String, dynamic>> loadPlantsFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_plantsKey);
    if (jsonString != null) {
      return Map<String, dynamic>.from(jsonDecode(jsonString));
    }
    return {};
  }

  /// Lấy dữ liệu 1 cây theo plantId
  static Future<Map<String, dynamic>?> loadPlantById(String plantId) async {
    final allPlants = await loadPlantsFromSharedPreferences();
    if (allPlants.containsKey(plantId)) {
      return Map<String, dynamic>.from(allPlants[plantId]);
    }
    return null;
  }
}
