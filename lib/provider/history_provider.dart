import 'package:flutter/foundation.dart';
import 'package:tree_care/models/history_model.dart';
import 'package:tree_care/services/firebase_db_service.dart';

class HistoryProvider extends ChangeNotifier {
  final FirebaseDbService _dbService = FirebaseDbService();

  List<ScanHistory> _historyList = [];
  bool _isLoading = false;
  String? _errorMessage;

  //puplic chi dc get thoi ko set
  List<ScanHistory> get historyList => _historyList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _historyList = await _dbService.readScanHistory();
    } catch (e) {
      _errorMessage = e.toString();
      _historyList = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
