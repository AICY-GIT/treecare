import 'package:flutter/material.dart';
import 'package:tree_care/models/wiki_summary_model.dart';
import 'package:url_launcher/url_launcher.dart';

class WikiResult extends StatefulWidget {
  final WikiSummary wikiSummaryResult;
  const WikiResult({super.key, required this.wikiSummaryResult});

  @override
  State<WikiResult> createState() => _WikiResultState();
}

class _WikiResultState extends State<WikiResult> {
  @override
  void initState() {
    super.initState();
    debugPrint("WikiSummary received: ${widget.wikiSummaryResult}");
  }

 @override
  Widget build(BuildContext context) {
    final wiki = widget.wikiSummaryResult;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 229, 244),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight, // fill screen if short
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Image
                      wiki.imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                wiki.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.image_not_supported,
                              size: 80, color: Colors.grey),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Title
                            Text(
                              wiki.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Description
                            if (wiki.description.isNotEmpty) ...[
                              const Text(
                                "Description",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                wiki.description,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                            // Extract / Details
                            if (wiki.extract.isNotEmpty) ...[
                              const Text(
                                "Details",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                wiki.extract,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                            // Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[600],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 20,
                                ),
                              ),
                              onPressed: () => _openWikipedia(wiki.pageUrl),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Read on Wikipedia  ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Image.asset(
                                    'assets/icons/online-wiki.png',
                                    width: 28,
                                    height: 28,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openWikipedia(String url) async {
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        throw Exception("Launch failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open Wikipedia page")),
      );
    }
   
  }
}
