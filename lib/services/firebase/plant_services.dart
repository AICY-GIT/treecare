import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tree_care/models/plant_model.dart';

class PlantService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  String? get _uid => _auth.currentUser?.uid;

  /// add new plant
  Future<void> addPlant(Plant plant) async {
    if (_uid == null) throw Exception("User not logged in");

    final newRef = _db.child("users/$_uid/plants").push();
    await newRef.set(plant.toJson());
  }

  /// get plants
  // Stream<Map<String, dynamic>> getPlants() {
  //   if (_uid == null) return const Stream.empty();

  //   return _db.child("users/$_uid/plants").onValue.map((event) {
  //     final data = event.snapshot.value as Map<dynamic, dynamic>?;

  //     if (data == null) return {};

  //     return Map<String, dynamic>.from(data);
  //   });
  // }

  /// delete plant
  Future<void> deletePlant(String plantId) async {
    if (_uid == null) throw Exception("User not logged in");

    await _db.child("users/$_uid/plants/$plantId").remove();
  }

  /// update plant
  Future<void> updatePlant(String plantId, Map<String, dynamic> updates) async {
    if (_uid == null) throw Exception("User not logged in");

    await _db.child("users/$_uid/plants/$plantId").update(updates);
  }

  /// Get plants for SharedPreferences
  Future<Map<String, Plant>> getPlantsForSharedPreference() async {
    if (_uid == null) return {};

    final snapshot = await _db.child("users/$_uid/plants").get();
    final data = snapshot.value as Map<dynamic, dynamic>?;

    if (data == null) return {};

    final Map<String, Plant> plantsMap = {};
    data.forEach((key, value) {
      plantsMap[key] = Plant.fromJson(Map<String, dynamic>.from(value));
    });

    return plantsMap;
  }
}
