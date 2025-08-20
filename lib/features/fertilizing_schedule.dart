import 'package:flutter/material.dart';
import 'package:tree_care/features/repeat.dart';

class FertilizingSchedulePage extends StatefulWidget {
  const FertilizingSchedulePage({super.key});

  @override
  State<FertilizingSchedulePage> createState() =>
      _FertilizingSchedulePageState();
}

class _FertilizingSchedulePageState extends State<FertilizingSchedulePage> {
  final List<DateTime> schedules = [];
  List<bool> isRepeat = [];
  List<String> repeatType = [];

  @override
  Widget build(BuildContext context) {
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
                  Image.asset(
                    'assets/icons/logo.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),
                  ...schedules.asMap().entries.map((entry) {
                    final index = entry.key;
                    final dt = entry.value;
                    return _fertilizingScheduleCard(index, dt);
                  }).toList(),
                  const SizedBox(height: 64),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _addButton(context),
    );
  }

  Container _fertilizingScheduleCard(int index, DateTime dt) {
    Future<void> _editSchedule() async {
      final newDateTime = await _pickDateTime(schedules[index]);
      if (newDateTime != null) {
        setState(() {
          schedules[index] = newDateTime;
        });
      }
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _editSchedule,
                child: Text(
                  "Fertilizing Logs ${index + 1}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              _removeButton(index),
            ],
          ),
          const SizedBox(height: 8),
          _dayTimeView(dt),
          const SizedBox(height: 8),
          _repeatSwitch(index),
          _editRepeatSchedule(index),
        ],
      ),
    );
  }

  ListTile _editRepeatSchedule(int index) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(repeatType[index]),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RepeatPage(initType: repeatType[index]),
          ),
        );
        if (result != null && result is String) {
          setState(() {
            repeatType[index] = result;
          });
        }
      },
    );
  }

  SwitchListTile _repeatSwitch(int index) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text("Repeat"),
      value: isRepeat[index],
      onChanged: (val) {
        setState(() {
          isRepeat[index] = val;
        });
      },
    );
  }

  IconButton _removeButton(int index) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        setState(() {
          schedules.removeAt(index);
          isRepeat.removeAt(index);
          repeatType.removeAt(index);
        });
      },
    );
  }

  FloatingActionButton _addButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final newDateTime = await _pickDateTime(DateTime.now());
        if (newDateTime != null) {
          setState(() {
            schedules.add(newDateTime);
            isRepeat.add(true);
            repeatType.add("Once");
          });
        }
      },
      child: const Icon(Icons.add),
    );
  }

  Row _dayTimeView(DateTime dt) {
    return Row(
      children: [
        const Icon(Icons.access_time, size: 18),
        const SizedBox(width: 8),
        Text(
            "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}"),
        const SizedBox(width: 16),
        Text(
            "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}"),
      ],
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Fertilizing Schedule'),
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      actions: [
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text("Success"),
                content: const Text("Schedules saved!"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          },
          child: const Text(
            "Save",
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Future<DateTime?> _pickDateTime(DateTime initialDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return null;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );
    if (pickedTime == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }
}
