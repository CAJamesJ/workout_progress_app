class WorkoutDay {
  final String? name;
  final String date;
  final List<WorkoutEntry> workouts;
  bool isExpanded;

  WorkoutDay({
    this.name,
    required this.date,
    this.workouts = const [],
    this.isExpanded = false,
  });
}

class WorkoutEntry {
  final String name;
  final List<double> weights;

  WorkoutEntry({
    required this.name,
    required this.weights,
  });
}
