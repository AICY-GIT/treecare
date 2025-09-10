import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tree_care/models/history_model.dart';
import 'package:tree_care/models/plant_net_model.dart';
import 'package:tree_care/scan/result_botton_sheet.dart';
import 'package:tree_care/services/firebase_db_service.dart';
import 'package:tree_care/utils/dialogs.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<ScanHistory> historyList = [];
  bool isLoading = true;
  final FirebaseDbService _dbService = FirebaseDbService();

  Future<void> getInfo() async {
    try {
      final result = await _dbService.readScanHistory();
      if (!mounted) return;
      setState(() {
        historyList = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      Popup.showErrorPopup(context, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: isLoading
              //dieu kien true
              ? const Center(child: CircularProgressIndicator())
              //dieu kien false
              : historyList.isEmpty
                  ? const Center(
                      child: Text(
                        "No history found",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : RefreshIndicator(
                    onRefresh: getInfo,
                    child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                        itemCount: historyList.length,
                        itemBuilder: (context, index) {
                          final item = historyList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                List<PlantIdentification> results=item.results;
                                _showResultsBottomSheet(results);
                              },
                              child: Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 195, 229, 244),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0, 5),
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                    )
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.memory(
                                          const Base64Decoder()
                                              .convert(item.base64Image),
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 6),
                                            Text(
                                              "Identified at: \n${item.timestamp.toLocal().toString().split(' ')[0]}",
                                              style: const TextStyle(
                                                fontSize: 25,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ),
        ),
      ),
    );
  }
   void _showResultsBottomSheet(List<PlantIdentification> results) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ResultBottomSheet(results: results),
    );
  }
}


