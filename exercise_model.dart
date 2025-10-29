class Exercise {
  final String id;
  final String name;
  final String type;
  final String muscleGroup;
  final String difficulty;
  final String instructions;
  final String imageUrl;
  final int duration; // in seconds

  Exercise({
    required this.id,
    required this.name,
    required this.type,
    required this.muscleGroup,
    required this.difficulty,
    required this.instructions,
    required this.imageUrl,
    required this.duration,
  });
}

class Workout {
  final String id;
  final String name;
  final List<Exercise> exercises;
  final int totalDuration;
  final DateTime created;
  int caloriesBurned;

  Workout({
    required this.id,
    required this.name,
    required this.exercises,
    required this.totalDuration,
    required this.created,
    this.caloriesBurned = 0,
  });
}

class FoodEntry {
  final String id;
  final String name;
  final int calories;
  final DateTime timestamp;

  FoodEntry({
    required this.id,
    required this.name,
    required this.calories,
    required this.timestamp,
  });
}