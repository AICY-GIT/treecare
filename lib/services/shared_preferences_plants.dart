import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_care/services/firebase/plant_services.dart';

class PlantSharedPref {
  static const _plantsKey = 'plants';

  /// Fetch từ Firebase 1 lần và lưu vào SharedPreferences
  static Future<void> fetchAndSavePlantsToSharedPreferences(
      PlantService plantService) async {
    final snapshot = await plantService.getPlantsForSharedPreference();
    if (snapshot.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_plantsKey, jsonEncode(snapshot));
    }
  }

  /// Load toàn bộ cây từ SharedPreferences
  static Future<Map<String, dynamic>> loadPlantsFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_plantsKey);

    if (jsonString == null) return {};

    final plants = Map<String, dynamic>.from(jsonDecode(jsonString));

    if (plants.isEmpty) return {};

    // Sort plants by isFavorite
    final keys = plants.keys.toList();
    keys.sort((a, b) {
      final favA = plants[a]['isFavorite'] ?? false;
      final favB = plants[b]['isFavorite'] ?? false;
      if (favA == favB) return 0;
      return favB ? 1 : -1;
    });

    // Tạo map mới đã sort
    final sortedPlants = {
      for (var k in keys) k: plants[k],
    };

    return sortedPlants;
  }

  /// Get a plant by its ID from SharedPreferences
  static Future<Map<String, dynamic>?> loadPlantById(String plantId) async {
    final allPlants = await loadPlantsFromSharedPreferences();
    if (allPlants.containsKey(plantId)) {
      return Map<String, dynamic>.from(allPlants[plantId]);
    }
    return null;
  }
}
