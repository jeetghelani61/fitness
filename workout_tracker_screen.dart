import 'package:flutter/material.dart';
import '../models/exercise_model.dart';

class WorkoutTrackerScreen extends StatefulWidget {
  @override
  _WorkoutTrackerScreenState createState() => _WorkoutTrackerScreenState();
}

class _WorkoutTrackerScreenState extends State<WorkoutTrackerScreen> {
  List<Workout> workouts = [];
  List<Exercise> availableExercises = [
    Exercise(
      id: '1',
      name: 'Push-ups',
      type: 'Strength',
      muscleGroup: 'Chest',
      difficulty: 'Beginner',
      instructions: 'Place hands shoulder-width apart and lower your body until chest nearly touches floor.',
      imageUrl: 'assets/pushups.jpg',
      duration: 180,
    ),
    Exercise(
      id: '2',
      name: 'Squats',
      type: 'Strength',
      muscleGroup: 'Legs',
      difficulty: 'Beginner',
      instructions: 'Stand with feet shoulder-width apart, lower hips back and down.',
      imageUrl: 'assets/squats.jpg',
      duration: 120,
    ),
    Exercise(
      id: '3',
      name: 'Plank',
      type: 'Core',
      muscleGroup: 'Abs',
      difficulty: 'Beginner',
      instructions: 'Hold your body in a straight line supported on forearms and toes.',
      imageUrl: 'assets/plank.jpg',
      duration: 60,
    ),
  ];

  TextEditingController workoutNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showCreateWorkoutDialog,
          ),
        ],
      ),
      body: workouts.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No workouts yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap + to create your first workout',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Icon(Icons.fitness_center, color: Colors.blue),
              ),
              title: Text(workout.name),
              subtitle: Text(
                  '${workout.exercises.length} exercises • ${workout.totalDuration ~/ 60} min'),
              trailing: Text('${workout.caloriesBurned} cal'),
              onTap: () {
                _showWorkoutDetails(workout);
              },
            ),
          );
        },
      ),
    );
  }

  void _showCreateWorkoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create New Workout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: workoutNameController,
              decoration: InputDecoration(
                labelText: 'Workout Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text('Select Exercises:'),
            Expanded(
              child: Container(
                height: 200,
                child: ListView.builder(
                  itemCount: availableExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = availableExercises[index];
                    return CheckboxListTile(
                      title: Text(exercise.name),
                      subtitle: Text('${exercise.duration}s • ${exercise.muscleGroup}'),
                      value: false,
                      onChanged: (value) {
                        // Handle exercise selection
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _createWorkout();
              Navigator.pop(context);
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  void _createWorkout() {
    if (workoutNameController.text.isNotEmpty) {
      final newWorkout = Workout(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: workoutNameController.text,
        exercises: availableExercises.sublist(0, 3), // Sample exercises
        totalDuration: availableExercises.sublist(0, 3).fold(
            0, (total, exercise) => total + exercise.duration),
        created: DateTime.now(),
        caloriesBurned: 150,
      );

      setState(() {
        workouts.add(newWorkout);
      });
      workoutNameController.clear();
    }
  }

  void _showWorkoutDetails(Workout workout) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              workout.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Exercises:'),
            ...workout.exercises.map((exercise) => ListTile(
              leading: Icon(Icons.play_arrow),
              title: Text(exercise.name),
              subtitle: Text('${exercise.duration}s'),
            )),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Duration: ${workout.totalDuration ~/ 60} min'),
                Text('Calories: ${workout.caloriesBurned} cal'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}