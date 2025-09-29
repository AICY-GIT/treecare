import 'package:flutter/material.dart';
import 'package:tree_care/features/edit_plant.dart';
import 'package:tree_care/features/fertilizing_schedule.dart';
import 'package:tree_care/features/watering_schedule.dart';
import 'package:tree_care/models/plant_model.dart';
import 'package:tree_care/utils/image_convert.dart';

class PlantDetailPage extends StatefulWidget {
  final String plantId;
  final Map<String, dynamic> plantData;

  const PlantDetailPage({
    super.key,
    required this.plantId,
    required this.plantData,
  });

  @override
  State<PlantDetailPage> createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  @override
  Widget build(BuildContext context) {
    final data = widget.plantData;

    return Scaffold(
      appBar: appBar(context),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/temp_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  ImageUtils.plantImage(data['base64Image'], size: 100),
                  _plantName(data['plantName'] ?? 'No name'),
                  const SizedBox(height: 8),
                  _plantSpecies(data['plantSpecies'] ?? 'Unknown'),
                  const SizedBox(height: 8),
                  _plantNote(data['plantNote'] ?? ''),
                  const SizedBox(height: 20),
                  _setWateringButton(context),
                  _setFertilizingButton(context),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _plantNote(String notes) {
    return Column(
      children: [
        const Text(
          "Note",
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: TextEditingController(text: notes),
            maxLines: 5,
            readOnly: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(8.0),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
        ),
      ],
    );
  }

  Text _plantSpecies(String species) {
    return Text(
      species,
      style: const TextStyle(fontSize: 16),
    );
  }

  Text _plantName(String name) {
    return Text(
      name,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  Padding _setWateringButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    WateringSchedulePage(plantId: widget.plantId),
              ),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Set watering schedule",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Icon(Icons.arrow_forward_ios, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Padding _setFertilizingButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FertilizingSchedulePage(plantId: widget.plantId),
              ),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Set fertilizing schedule",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Icon(Icons.arrow_forward_ios, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text('Plant Detail'),
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async {
            final updatedPlant = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditPlantPage(
                  plantId: widget.plantId,
                  plant: Plant.fromJson(widget.plantData), // ✅ truyền model
                ),
              ),
            );

            if (updatedPlant != null) {
              setState(() {
                widget.plantData.addAll(updatedPlant); // refresh lại giao diện
              });
            }
          },
        ),
      ],
    );
  }
}
