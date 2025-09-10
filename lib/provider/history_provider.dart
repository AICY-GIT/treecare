import 'package:flutter/foundation.dart';
import 'package:tree_care/models/history_model.dart';
import 'package:tree_care/services/firebase_db_service.dart';

class HistoryProvider extends ChangeNotifier {
  final FirebaseDbService _dbService = FirebaseDbService();

  List<ScanHistory> _historyList = [];
  bool _isLoading = false;

  //puplic chi dc get thoi ko set
  List<ScanHistory> get historyList => _historyList;
  bool get isLoading => _isLoading;

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      _historyList = await _dbService.readScanHistory();
    } catch (e) {
      // you could store error message in a String variable if you want
      _historyList = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
