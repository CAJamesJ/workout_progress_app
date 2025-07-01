import 'package:flutter/material.dart';

void main() {
  runApp(const FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    WorkoutPage(),
    FoodTrackingPage(),
    FriendsPage(),
    SettingsPage(),
  ];

  final List<String> _titles = [
    'Workout Tracker',
    'Food Tracking',
    'Friends',
    'Settings',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.lightGreenAccent,
        title: Text(_titles[_selectedIndex]),
      ),
      body: _pages[_selectedIndex],
      backgroundColor: const Color.fromARGB(179, 221, 151, 151),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.lightGreenAccent,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Food',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class WorkoutDay {
  final String? name;
  final String date;
  final List<WorkoutEntry> workouts;

  WorkoutDay({this.name, required this.date, this.workouts = const []});
}

class WorkoutEntry {
  final String name;
  final List<double> weights;

  WorkoutEntry({required this.name, required this.weights});
}

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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: day.workouts.map((workout) {
                          return Container(
                            margin: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
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

class FoodTrackingPage extends StatelessWidget {
  const FoodTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Log your food here.'),
        ],
      ),
    );
  }
}

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Find and connect with friends.'),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Update your settings here.'),
        ],
      ),
    );
  }
}
