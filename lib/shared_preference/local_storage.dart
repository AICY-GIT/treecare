import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_care/models/plant_model.dart';

class LocalStorage {
  static const _plantsKey = "plants";

  /// Lưu danh sách cây vào SharedPreferences
  static Future<void> savePlants(Map<String, Plant> plantsMap) async {
    final prefs = await SharedPreferences.getInstance();

    // Chuyển Map<String, Plant> → Map<String, dynamic>
    final Map<String, dynamic> jsonMap = {};
    plantsMap.forEach((id, plant) {
      final plantJson = plant.toJson();
      plantJson['id'] = id; // gắn plantId
      jsonMap[id] = plantJson;
    });

    final jsonString = jsonEncode(jsonMap);
    await prefs.setString(_plantsKey, jsonString);
  }

  /// Lấy danh sách cây từ SharedPreferences
  static Future<Map<String, Plant>> getPlants() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_plantsKey);
    if (jsonString == null) return {};

    final Map<String, dynamic> decoded = jsonDecode(jsonString);
    final Map<String, Plant> plantsMap = {};
    decoded.forEach((key, value) {
      final plantData = Map<String, dynamic>.from(value);
      plantsMap[key] = Plant.fromJson(plantData);
    });

    return plantsMap;
  }

  /// Lấy một cây theo plantId
  static Future<Plant?> getPlantById(String id) async {
    final plants = await getPlants();
    return plants[id];
  }

  /// Xóa cache (nếu cần)
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_plantsKey);
  }
}
