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
  final String date;
  final List<WorkoutEntry> workouts;

  WorkoutDay({required this.date, this.workouts = const []});
}

class WorkoutEntry {
  final String name;
  final int sets;
  final double weight;

  WorkoutEntry({required this.name, required this.sets, required this.weight});
}

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final List<WorkoutDay> _workoutDays = [];

  void _addWorkoutDay() {
    final now = DateTime.now();
    final formattedDate = '${now.year}-${now.month}-${now.day}';

    setState(() {
      _workoutDays.add(WorkoutDay(date: formattedDate));
    });
  }

  void _addWorkoutEntry(int dayIndex) {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        final setsController = TextEditingController();
        final weightController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Workout Entry'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Workout Name'),
              ),
              TextField(
                controller: setsController,
                decoration: const InputDecoration(labelText: 'Sets'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedWorkouts = List<WorkoutEntry>.from(_workoutDays[dayIndex].workouts)
                  ..add(
                    WorkoutEntry(
                      name: nameController.text,
                      sets: int.tryParse(setsController.text) ?? 0,
                      weight: double.tryParse(weightController.text) ?? 0,
                    ),
                  );

                setState(() {
                  _workoutDays[dayIndex] = WorkoutDay(
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
                  title: Text(day.date),
                  children: [
                    ...day.workouts.map((workout) => ListTile(
                          title: Text(workout.name),
                          subtitle: Text('${workout.sets} sets • ${workout.weight} kg'),
                        )),
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