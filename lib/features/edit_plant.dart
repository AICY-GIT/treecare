import 'package:flutter/material.dart';
import 'package:tree_care/models/plant_model.dart';
import 'package:tree_care/services/firebase/plant_services.dart';
import 'package:tree_care/services/shared_preferences_plants.dart';
import 'package:tree_care/widgets/plant_form.dart';

class EditPlantPage extends StatefulWidget {
  final String plantId;
  final Plant plant;

  const EditPlantPage({
    super.key,
    required this.plantId,
    required this.plant,
  });

  @override
  State<EditPlantPage> createState() => _EditPlantPageState();
}

class _EditPlantPageState extends State<EditPlantPage> {
  bool _isSaving = false;

  Future<void> _handleSave(Plant updatedPlant) async {
    setState(() => _isSaving = true);

    try {
      await PlantService().updatePlant(widget.plantId, updatedPlant.toJson());

      await PlantSharedPref.fetchAndSavePlantsToSharedPreferences(
          PlantService());

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Plant updated successfully")),
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
            initialPlant: widget.plant,
            onSave: _handleSave,
            isSaving: _isSaving,
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text("Edit Plant"),
      centerTitle: true,
    );
  }
}
