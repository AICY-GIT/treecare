import 'package:tree_care/models/repeat_model.dart';

class Plant {
  final String base64Image;
  final String plantName;
  final String plantSpecies;
  final String plantNote;
  final List<Repeat> wateringSchedule;
  final List<Repeat> fertilizingSchedule;
  final bool isFavorite;

  Plant({
    required this.base64Image,
    required this.plantName,
    required this.plantSpecies,
    required this.plantNote,
    required this.wateringSchedule,
    required this.fertilizingSchedule,
    this.isFavorite = false,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    List<Repeat> parsedWateringSchedule = [];
    if (json['wateringSchedule'] != null && json['wateringSchedule'] is List) {
      for (var item in json['wateringSchedule']) {
        parsedWateringSchedule
            .add(Repeat.fromJson(Map<String, dynamic>.from(item)));
      }
    }

    List<Repeat> parsedFertilizingSchedule = [];
    if (json['fertilizingSchedule'] != null &&
        json['fertilizingSchedule'] is List) {
      for (var item in json['fertilizingSchedule']) {
        parsedFertilizingSchedule
            .add(Repeat.fromJson(Map<String, dynamic>.from(item)));
      }
    }

    return Plant(
      base64Image: json['base64Image'] ?? "",
      plantName: json['plantName'] ?? "",
      plantSpecies: json['plantSpecies'] ?? "",
      plantNote: json['plantNote'] ?? "",
      wateringSchedule: parsedWateringSchedule,
      fertilizingSchedule: parsedFertilizingSchedule,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  /// Convert Plant object → Map to store in Realtime Database
  Map<String, dynamic> toJson() {
    return {
      "base64Image": base64Image,
      "plantName": plantName,
      "plantSpecies": plantSpecies,
      "plantNote": plantNote,
      "isFavorite": isFavorite,
      "wateringSchedule": wateringSchedule.map((r) => r.toJson()).toList(),
      "fertilizingSchedule":
          fertilizingSchedule.map((r) => r.toJson()).toList(),
    };
  }

  // /// Tạo bản copy mới với giá trị thay đổi
  // Plant copyWith({
  //   String? base64Image,
  //   String? plantName,
  //   String? plantSpecies,
  //   String? plantNote,
  //   List<Repeat>? wateringSchedule,
  //   List<Repeat>? fertilizingSchedule,
  //   bool? isFavorite,
  // }) {
  //   return Plant(
  //     base64Image: base64Image ?? this.base64Image,
  //     plantName: plantName ?? this.plantName,
  //     plantSpecies: plantSpecies ?? this.plantSpecies,
  //     plantNote: plantNote ?? this.plantNote,
  //     wateringSchedule: wateringSchedule ?? this.wateringSchedule,
  //     fertilizingSchedule: fertilizingSchedule ?? this.fertilizingSchedule,
  //     isFavorite: isFavorite ?? this.isFavorite,
  //   );
  // }
}
