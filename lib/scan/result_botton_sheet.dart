// lib/widgets/result_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:tree_care/models/plant_net_model.dart';
import 'package:tree_care/scan/wiki_result.dart';
import 'package:tree_care/services/wikipedia_service.dart';
import 'package:tree_care/utils/dialogs.dart';

class ResultBottomSheet extends StatelessWidget {
  final List<PlantIdentification> results;

  const ResultBottomSheet({super.key, required this.results});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 6,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const Text(
            "Identification Results",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final plant = results[index];
                return GestureDetector(
                  onTap: () async{
                    Popup.showLoading(context);
                    try{
                       final summary = await fetchWikiSummary(plant.scientificName);
                       //neu ng dung quit early
                       if (!context.mounted) return;
                      Popup.hideLoading(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WikiResult(wikiSummaryResult: summary),
                        ),
                      );
                    }catch(e){
                      Popup.hideLoading(context);
                      Popup.showErrorPopup(context, e.toString());
                    }
                  },
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: const Color.fromARGB(255, 195, 229, 244),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          plant.imageUrl.isNotEmpty? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    plant.imageUrl,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.image_not_supported, size: 50),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plant.scientificName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  plant.commonName,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Confidence: ${(plant.score * 100).toStringAsFixed(1)}%",
                                  style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                                ),
                              ],
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
        ],
      ),
    );
  }
}
