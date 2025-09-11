import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tree_care/models/history_model.dart';
import 'package:tree_care/models/plant_net_model.dart';

class FirebaseDbService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("users");

   Future<void> createScanHistory({required List<PlantIdentification> scanResults, required XFile scanImage }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw Exception("No user logged in");
      }

      final String userId=user.uid;
      final String timeStamp=DateTime.now().millisecondsSinceEpoch.toString();
      
      final bytes = await scanImage.readAsBytes();
      final String base64Image = base64Encode(bytes);


      final List<Map<String, dynamic>> resultsJson =scanResults.map((r) => r.toJson()).toList();

      final DatabaseReference historyRef=_dbRef.child(userId).child("history").push();
      await historyRef.set({"timestamp": timeStamp,"results": resultsJson,"base64Image": base64Image,});

    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Save history failed");
    }catch(e){
      throw Exception("Unexpected error: $e");
    }
  }

  Future<List<ScanHistory>> readScanHistory() async {
    try {
      User? user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw Exception("No user logged in");
      }

      final String userId=user.uid;
      final DatabaseReference historyRef =_dbRef.child(userId).child("history");
      final Query query = historyRef.limitToLast(20);

      final DataSnapshot snapshot = await query.get();
      List<ScanHistory> historyList = [];
      
      //check map de ko bi loi (la map vi co nhieu history)
      if(snapshot.exists && snapshot.value is Map){
        
        final data=snapshot.value as Map<dynamic,dynamic>;

         for (var entry in data.entries) {
          var value = entry.value;
          //check map lan nua cho tung history
          if (value is Map) {
            final history = ScanHistory.fromJson(Map<String, dynamic>.from(value),);
            historyList.add(history);
          }
        }
      }
      //sort time
      historyList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return historyList;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Fetch history failed");
    }catch(e){
      throw Exception("Unexpected error: $e");
    }
  }
}