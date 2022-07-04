class HabitDateConstructor {
  HabitDateConstructor({
    required this.dateTime,
    required this.id,
    required this.success,
  });

  final String dateTime;
  final int id;
  final int success;

  Map<String, dynamic> toMap() {
    return {'DateTime': dateTime, 'id': id, 'Success': success};
  }
}
