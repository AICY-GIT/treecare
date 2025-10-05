class Repeat {
  final DateTime timestamp;
  final String repeatType;
  final List<String> daysOfWeek;

  Repeat({
    required this.timestamp,
    required this.repeatType,
    required this.daysOfWeek,
  });

  factory Repeat.fromJson(Map<String, dynamic> json) {
    List<String> parsedDaysOfWeek = [];
    if (json['daysOfWeek'] != null && json['daysOfWeek'] is List) {
      for (var item in json['daysOfWeek']) {
        parsedDaysOfWeek.add(item as String);
      }
    }
    return Repeat(
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(json['timestamp'].toString()) ?? 0,
      ),
      repeatType: json['repeatType'],
      daysOfWeek: parsedDaysOfWeek,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "timestamp": timestamp.millisecondsSinceEpoch,
      "repeatType": repeatType,
      "daysOfWeek": daysOfWeek,
    };
  }
}
