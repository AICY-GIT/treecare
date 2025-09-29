import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tree_care/models/plant_model.dart';
import 'package:tree_care/widgets/custom_input_box.dart';

class PlantForm extends StatefulWidget {
  final Plant? initialPlant;
  final Future<void> Function(Plant plant) onSave;
  final bool isSaving;

  const PlantForm({
    super.key,
    this.initialPlant,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  State<PlantForm> createState() => _PlantFormState();
}

class _PlantFormState extends State<PlantForm> {
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _noteController = TextEditingController();

  File? _selectedImage;
  String? _base64Image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialPlant != null) {
      _nameController.text = widget.initialPlant!.plantName;
      _speciesController.text = widget.initialPlant!.plantSpecies;
      _noteController.text = widget.initialPlant!.plantNote;
      _base64Image = widget.initialPlant!.base64Image;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        _base64Image = base64Encode(_selectedImage!.readAsBytesSync());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => _pickImage(ImageSource.camera),
            child: _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _selectedImage!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                : (_base64Image != null && _base64Image!.isNotEmpty)
                    ? Image.memory(
                        base64Decode(_base64Image!),
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/icons/logo.png',
                        width: 150,
                        height: 150,
                      ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _pickImage(ImageSource.gallery),
            icon: const Icon(Icons.image),
            label: const Text("Select Image"),
          ),
          const SizedBox(height: 16),
          _textField("Plant Name", _nameController),
          const SizedBox(height: 12),
          _textField("Species", _speciesController),
          const SizedBox(height: 12),
          _textField("Notes", _noteController, maxLines: 5),
          const SizedBox(height: 20),
          _saveButton(),
        ],
      ),
    );
  }

  Widget _textField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        CustomInputBox(
          controller: controller,
          hint: 'Enter $label',
        ),
      ],
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: widget.isSaving
            ? null
            : () {
                if (_nameController.text.isEmpty ||
                    _speciesController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please enter plant name & species")),
                  );
                  return;
                }

                final plant = Plant(
                  base64Image: _base64Image ?? "",
                  plantName: _nameController.text,
                  plantSpecies: _speciesController.text,
                  plantNote: _noteController.text,
                  wateringSchedule: widget.initialPlant?.wateringSchedule ?? [],
                  fertilizingSchedule:
                      widget.initialPlant?.fertilizingSchedule ?? [],
                );

                widget.onSave(plant);
              },
        child: widget.isSaving
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Save', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
