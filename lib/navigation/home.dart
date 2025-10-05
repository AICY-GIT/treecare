import 'package:flutter/material.dart';
import 'package:tree_care/features/add_plant.dart';
import 'package:tree_care/features/plant_detail.dart';
import 'package:tree_care/services/firebase/plant_services.dart';
import 'package:tree_care/services/shared_preferences_plants.dart';
import 'package:tree_care/utils/image_convert.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  final PlantService _plantService = PlantService();

  @override
  void initState() {
    super.initState();
    _refreshPlants();
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
          child: FutureBuilder<Map<String, dynamic>>(
            future: PlantSharedPref.loadPlantsFromSharedPreferences(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const Center(child: CircularProgressIndicator());
              final plants = snapshot.data!;
              if (plants.isEmpty)
                return const Center(child: Text("No plants found."));
              final plantKeys = plants.keys.toList();

              return ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                itemCount: plants.length,
                itemBuilder: (context, index) {
                  final key = plantKeys[index];
                  final plant = Map<String, dynamic>.from(plants[key]);

                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PlantDetailPage(plantId: key, plantData: plant),
                          ),
                        );
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
                            ImageUtils.plantImage(plant['base64Image'],
                                size: 100, isCircle: true),
                            const SizedBox(width: 20),
                            Expanded(
                              child: SafeArea(
                                child: Text(
                                  plant['plantName'] ?? 'Plant Name ?',
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _deletePlant(context, key),
                                SizedBox(height: 8),
                                _favoriteButton(
                                    key, plant['isFavorite'] ?? false),
                              ],
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: _addButton(context),
    );
  }

  IconButton _deletePlant(BuildContext context, String key) {
    return IconButton(
      iconSize: 28,
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.delete, color: Colors.black54),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Delete Plant"),
              content: const Text("Do you want to delete this plant?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    _plantService.deletePlant(key);
                    _refreshPlants();
                    Navigator.pop(context);
                  },
                  child: const Text("Delete"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  FloatingActionButton _addButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddPlantPage(),
          ),
        );
        await _refreshPlants();
      },
      child: const Icon(Icons.add),
    );
  }

  IconButton _favoriteButton(String plantId, bool isFav) {
    return IconButton(
      iconSize: 28,
      padding: EdgeInsets.zero,
      icon: Icon(
        isFav ? Icons.favorite : Icons.favorite_border,
        color: isFav ? Colors.red : null,
      ),
      onPressed: () async {
        await _plantService.updatePlant(plantId, {'isFavorite': !isFav});
        await _refreshPlants();
      },
    );
  }

  Text _plantName(String name) {
    return Text(
      name,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Future<void> _refreshPlants() async {
    // Fetch dữ liệu mới từ Firebase và lưu SharedPreferences
    await PlantSharedPref.fetchAndSavePlantsToSharedPreferences(_plantService);
    // Refresh UI bằng setState
    setState(() {});
  }
}
