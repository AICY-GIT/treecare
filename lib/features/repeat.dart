import 'package:flutter/material.dart';

class RepeatPage extends StatefulWidget {
  const RepeatPage({super.key, required String initType});

  @override
  State<RepeatPage> createState() => _RepeatPageState();
}

class _RepeatPageState extends State<RepeatPage> {
  String repeatType = "Once";
  final List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  final Set<String> selectedDays = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            _selectRepeat(),
            const SizedBox(height: 16),
            if (repeatType == "Customize") _customizeSelect(),
            _saveButton(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text("Repeat"),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Expanded _customizeSelect() {
    return Expanded(
      child: ListView(
        children: days.map((d) {
          return CheckboxListTile(
            title: Text(d),
            value: selectedDays.contains(d),
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  selectedDays.add(d);
                } else {
                  selectedDays.remove(d);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  ElevatedButton _saveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context, repeatType);
      },
      child: const Text("Save"),
    );
  }

  DropdownButton<String> _selectRepeat() {
    return DropdownButton<String>(
      value: repeatType,
      items: const [
        DropdownMenuItem(value: "Once", child: Text("Once")),
        DropdownMenuItem(value: "Daily", child: Text("Daily")),
        DropdownMenuItem(value: "Customize", child: Text("Customize")),
      ],
      onChanged: (val) {
        setState(() {
          repeatType = val!;
        });
      },
    );
  }
}
