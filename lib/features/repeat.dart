import 'package:flutter/material.dart';
import 'package:tree_care/models/repeat_model.dart';

class RepeatPage extends StatefulWidget {
  final Repeat initRepeat;
  const RepeatPage(
      {super.key, required this.initRepeat, required String initType});

  @override
  State<RepeatPage> createState() => _RepeatPageState();
}

class _RepeatPageState extends State<RepeatPage> {
  late String repeatType;

  static const List<String> weekDays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  late Set<String> selectedDays;

  @override
  void initState() {
    super.initState();
    repeatType = widget.initRepeat.repeatType;
    selectedDays = widget.initRepeat.daysOfWeek.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _selectRepeatCard(),
            const SizedBox(height: 16),
            if (repeatType == "Customize") _customizeSelect(),
            const Spacer(),
            _saveButton(context),
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

  /// Card chứa dropdown chọn loại repeat
  Widget _selectRepeatCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButton<String>(
                value: repeatType,
                isExpanded: true,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: "Once", child: Text("Once")),
                  DropdownMenuItem(value: "Daily", child: Text("Daily")),
                  DropdownMenuItem(
                      value: "Customize", child: Text("Customize")),
                ],
                onChanged: (val) {
                  setState(() {
                    repeatType = val!;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Checkbox select customize
  Widget _customizeSelect() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: weekDays.map((day) {
          return CheckboxListTile(
            title: Text(day),
            value: selectedDays.contains(day),
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  selectedDays.add(day);
                } else {
                  selectedDays.remove(day);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _saveButton(BuildContext context) {
    return SizedBox(
      child: ElevatedButton.icon(
        label: const Text("Save"),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          if (repeatType == "Customize" && selectedDays.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Please select at least one day."),
                  duration: Duration(seconds: 2)),
            );
            return;
          }

          final sortedSelectedDays =
              weekDays.where((day) => selectedDays.contains(day)).toList();

          Navigator.pop(
            context,
            Repeat(
              timestamp: widget.initRepeat.timestamp,
              repeatType: repeatType,
              daysOfWeek: sortedSelectedDays,
            ),
          );
        },
      ),
    );
  }
}
