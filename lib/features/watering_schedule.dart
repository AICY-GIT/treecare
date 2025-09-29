import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tree_care/features/repeat.dart';
import 'package:tree_care/models/repeat_model.dart';
import 'package:tree_care/services/schedule_service.dart';

class WateringSchedulePage extends StatefulWidget {
  final String plantId;
  const WateringSchedulePage({super.key, required this.plantId});

  @override
  State<WateringSchedulePage> createState() => _WateringSchedulePageState();
}

class _WateringSchedulePageState extends State<WateringSchedulePage> {
  final _service = ScheduleService();
  List<Repeat> wateringSchedules = [];
  StreamSubscription<List<Repeat>>? _scheduleSub;

  @override
  void initState() {
    super.initState();
    _scheduleSub = _service.getWateringSchedules(widget.plantId).listen((data) {
      if (mounted) {
        setState(() {
          wateringSchedules = data;
        });
      }
    });
  }

  @override
  void dispose() {
    _scheduleSub?.cancel();
    super.dispose();
  }

  Future<void> _saveSchedules() async {
    try {
      await _service.saveWateringSchedules(widget.plantId, wateringSchedules);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("Save failed: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save schedules")),
        );
      }
    }
  }

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
                children: [
                  const SizedBox(height: 32),
                  // Image.asset(
                  //   'assets/icons/logo.png',
                  //   width: 150,
                  //   height: 150,
                  // ),
                  const SizedBox(height: 24),
                  ...wateringSchedules.asMap().entries.map((entry) {
                    final index = entry.key;
                    final repeat = entry.value;
                    return _wateringScheduleCard(index, repeat);
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

  Container _wateringScheduleCard(int index, Repeat repeat) {
    Future<void> _editSchedule() async {
      final newDateTime = await _pickDateTime(repeat.timestamp);
      if (newDateTime != null) {
        setState(() {
          wateringSchedules[index] = Repeat(
            timestamp: newDateTime,
            repeatType: repeat.repeatType,
            daysOfWeek: repeat.daysOfWeek,
          );
        });
      }
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _editSchedule,
                child: Text(
                  "Watering Logs ${index + 1}",
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
          GestureDetector(
              onTap: _editSchedule, child: _dayTimeView(repeat.timestamp)),
          const SizedBox(height: 8),
          _editRepeatSchedule(index, repeat),
        ],
      ),
    );
  }

  ListTile _editRepeatSchedule(int index, Repeat repeat) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(repeat.repeatType),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RepeatPage(
              initRepeat: repeat,
              initType: '',
            ),
          ),
        );
        if (result != null && result is Repeat) {
          setState(() {
            wateringSchedules[index] = result;
          });
        }
      },
    );
  }

  IconButton _removeButton(int index) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        setState(() {
          wateringSchedules.removeAt(index);
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
            wateringSchedules.add(
              Repeat(
                timestamp: newDateTime,
                repeatType: 'Once',
                daysOfWeek: [],
              ),
            );
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
      title: const Text('Watering Schedule'),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: _saveSchedules,
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
