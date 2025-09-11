import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_care/models/plant_net_model.dart';
import 'package:tree_care/provider/history_provider.dart';
import 'package:tree_care/scan/result_botton_sheet.dart';
import 'package:tree_care/utils/dialogs.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<HistoryProvider>().loadHistory();
      }); 
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<HistoryProvider>();
      if (historyProvider.errorMessage != null) {
      Popup.showErrorPopup(context, historyProvider.errorMessage!);
    }
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: historyProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : historyProvider.historyList.isEmpty
                  ? const Center(
                      child: Text(
                        "No history found",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => historyProvider.loadHistory(),
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                        itemCount: historyProvider.historyList.length,
                        itemBuilder: (context, index) {
                          final item = historyProvider.historyList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                _showResultsBottomSheet(item.results);
                              },
                              child: Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 195, 229, 244),
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
                                            Text(
                                              "Identified at: \n${item.timestamp.toLocal().toString().split(' ')[0]}",
                                              style: const TextStyle(
                                                fontSize: 25,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
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
