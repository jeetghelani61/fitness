import 'package:flutter/material.dart';
import '../models/exercise_model.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  @override
  _ExerciseLibraryScreenState createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  List<Exercise> exercises = [
    Exercise(
      id: '1',
      name: 'Push-ups',
      type: 'Strength',
      muscleGroup: 'Chest',
      difficulty: 'Beginner',
      instructions: '1. Place your hands shoulder-width apart\n2. Keep your body in a straight line\n3. Lower your body until your chest nearly touches the floor\n4. Push back up to the starting position',
      imageUrl: 'assets/pushups.jpg',
      duration: 180,
    ),
    Exercise(
      id: '2',
      name: 'Squats',
      type: 'Strength',
      muscleGroup: 'Legs',
      difficulty: 'Beginner',
      instructions: '1. Stand with feet shoulder-width apart\n2. Lower your hips back and down\n3. Keep your chest up and back straight\n4. Go as low as you can comfortably\n5. Push through your heels to return to start',
      imageUrl: 'assets/squats.jpg',
      duration: 120,
    ),
    Exercise(
      id: '3',
      name: 'Plank',
      type: 'Core',
      muscleGroup: 'Abs',
      difficulty: 'Beginner',
      instructions: '1. Place forearms on the ground\n2. Keep your body in a straight line\n3. Engage your core muscles\n4. Hold for the desired time',
      imageUrl: 'assets/plank.jpg',
      duration: 60,
    ),
  ];

  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Library'),
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                'All',
                'Chest',
                'Legs',
                'Abs',
                'Arms',
                'Back',
              ].map((filter) {
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: selectedFilter == filter,
                    onSelected: (selected) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Exercises List
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                if (selectedFilter != 'All' && exercise.muscleGroup != selectedFilter) {
                  return SizedBox.shrink();
                }
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getMuscleGroupColor(exercise.muscleGroup),
                      child: Text(
                        exercise.muscleGroup[0],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(exercise.name),
                    subtitle: Text('${exercise.type} • ${exercise.difficulty}'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showExerciseDetails(exercise);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showExerciseDetails(Exercise exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getMuscleGroupColor(exercise.muscleGroup),
                  child: Text(
                    exercise.muscleGroup[0],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text('${exercise.type} • ${exercise.difficulty}'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Instructions:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(exercise.instructions),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.timer, size: 16),
                SizedBox(width: 4),
                Text('Duration: ${exercise.duration} seconds'),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Start exercise timer
                },
                child: Text('Start Exercise'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMuscleGroupColor(String muscleGroup) {
    switch (muscleGroup.toLowerCase()) {
      case 'chest':
        return Colors.red;
      case 'legs':
        return Colors.green;
      case 'abs':
        return Colors.blue;
      case 'arms':
        return Colors.orange;
      case 'back':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}