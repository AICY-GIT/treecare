import 'package:flutter/material.dart';
import 'package:tree_care/models/plant_model.dart';
import 'package:tree_care/services/firebase/plant_services.dart';
import 'package:tree_care/services/shared_preferences_plants.dart';
import 'package:tree_care/widgets/plant_form.dart';

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({super.key});

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  bool _isSaving = false;

  Future<void> _handleSave(Plant newPlant) async {
    setState(() => _isSaving = true);

    try {
      await PlantService().addPlant(newPlant);

      await PlantSharedPref.fetchAndSavePlantsToSharedPreferences(
          PlantService());

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Plant added successfully")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/temp_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: PlantForm(
            onSave: _handleSave,
            isSaving: _isSaving,
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text("Add Plant"),
      centerTitle: true,
    );
  }
}
