import 'package:flutter/material.dart';
import '../models/workout_models.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final List<WorkoutDay> _workoutDays = [];

  void _addWorkoutDay() {
    final nameController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Workout Day'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Workout Day Name (optional)'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Date:'),
                      const SizedBox(width: 10),
                      Text(
                        '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final formattedDate = '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
                setState(() {
                  _workoutDays.add(WorkoutDay(
                    name: nameController.text.isEmpty ? null : nameController.text,
                    date: formattedDate,
                  ));
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addWorkoutEntry(int dayIndex) {
    final nameController = TextEditingController();
    final setsController = TextEditingController();
    final weightControllers = <TextEditingController>[];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Workout Entry'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Workout Name'),
                    ),
                    TextField(
                      controller: setsController,
                      decoration: const InputDecoration(labelText: 'Number of Sets'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final sets = int.tryParse(value) ?? 0;
                        setDialogState(() {
                          weightControllers
                            ..clear()
                            ..addAll(List.generate(sets, (_) => TextEditingController()));
                        });
                      },
                    ),
                    ...List.generate(weightControllers.length, (i) {
                      return TextField(
                        controller: weightControllers[i],
                        decoration: InputDecoration(labelText: 'Weight for Set ${i + 1} (kg)'),
                        keyboardType: TextInputType.number,
                      );
                    }),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final weights = weightControllers
                    .map((controller) => double.tryParse(controller.text) ?? 0)
                    .toList();

                final updatedWorkouts = List<WorkoutEntry>.from(_workoutDays[dayIndex].workouts)
                  ..add(WorkoutEntry(name: nameController.text, weights: weights));

                setState(() {
                  _workoutDays[dayIndex] = WorkoutDay(
                    name: _workoutDays[dayIndex].name,
                    date: _workoutDays[dayIndex].date,
                    workouts: updatedWorkouts,
                  );
                });

                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _addWorkoutDay,
          child: const Text('Add Day'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _workoutDays.length,
            itemBuilder: (context, index) {
              final day = _workoutDays[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          day.name ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        day.date,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: day.workouts.map((workout) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(workout.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                ...List.generate(workout.weights.length, (i) {
                                  return Text('Set ${i + 1}: ${workout.weights[i]} kg');
                                }),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _addWorkoutEntry(index),
                      child: const Text('Add Workout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
