import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tree_care/models/repeat_model.dart';

class ScheduleService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  String? get _uid => _auth.currentUser?.uid;

  // save Watering Schedule
  Future<void> saveWateringSchedules(
      String plantId, List<Repeat> schedules) async {
    final data = schedules.map((e) => e.toJson()).toList();
    await _db.child("users/$_uid/plants/$plantId/wateringSchedule").set(data);
  }

// get data realtime Watering Schedule
  Future<List<Repeat>> getWateringSchedules(String plantId) async {
    final snapshot =
        await _db.child("users/$_uid/plants/$plantId/wateringSchedule").get();

    final val = snapshot.value;
    if (val == null) return [];
    if (val is List) {
      return val
          .where((e) => e != null)
          .map((e) => Repeat.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else if (val is Map) {
      return val.values
          .where((e) => e != null)
          .map((e) => Repeat.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }

  // save Fertilizing Schedule
  Future<void> saveFertilizingSchedules(
      String plantId, List<Repeat> schedules) async {
    final data = schedules.map((e) => e.toJson()).toList();
    await _db
        .child("users/$_uid/plants/$plantId/fertilizingSchedule")
        .set(data);
  }

  // get data realtime Fertilizing Schedule
  Future<List<Repeat>> getFertilizingSchedules(String plantId) async {
    final snapshot = await _db
        .child("users/$_uid/plants/$plantId/fertilizingSchedule")
        .get();

    final val = snapshot.value;
    if (val == null) return [];
    if (val is List) {
      return val
          .where((e) => e != null)
          .map((e) => Repeat.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else if (val is Map) {
      return val.values
          .where((e) => e != null)
          .map((e) => Repeat.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }
}
