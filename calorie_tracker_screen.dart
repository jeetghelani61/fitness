import 'package:flutter/material.dart';
import '../models/exercise_model.dart';

class CalorieTrackerScreen extends StatefulWidget {
  @override
  _CalorieTrackerScreenState createState() => _CalorieTrackerScreenState();
}

class _CalorieTrackerScreenState extends State<CalorieTrackerScreen> {
  int dailyCalorieLimit = 2000;
  List<FoodEntry> foodEntries = [];
  TextEditingController foodNameController = TextEditingController();
  TextEditingController calorieController = TextEditingController();

  int get totalCaloriesConsumed {
    return foodEntries.fold(0, (total, entry) => total + entry.calories);
  }

  int get remainingCalories {
    return dailyCalorieLimit - totalCaloriesConsumed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calorie Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _showCalorieSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          // Calorie Summary Card
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Daily Calorie Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCalorieInfo('Limit', dailyCalorieLimit.toString()),
                      _buildCalorieInfo('Consumed', totalCaloriesConsumed.toString()),
                      _buildCalorieInfo('Remaining', remainingCalories.toString(),
                          color: remainingCalories >= 0 ? Colors.green : Colors.red),
                    ],
                  ),
                  SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: totalCaloriesConsumed / dailyCalorieLimit,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      totalCaloriesConsumed <= dailyCalorieLimit
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Add Food Entry
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: foodNameController,
                    decoration: InputDecoration(
                      labelText: 'Food Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: calorieController,
                    decoration: InputDecoration(
                      labelText: 'Calories',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.green),
                  onPressed: _addFoodEntry,
                ),
              ],
            ),
          ),

          // Food Entries List
          Expanded(
            child: foodEntries.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No food entries yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: foodEntries.length,
              itemBuilder: (context, index) {
                final entry = foodEntries[index];
                return Dismissible(
                  key: Key(entry.id),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    setState(() {
                      foodEntries.removeAt(index);
                    });
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.shade100,
                        child: Icon(Icons.restaurant, color: Colors.green),
                      ),
                      title: Text(entry.name),
                      subtitle: Text('Added: ${_formatTime(entry.timestamp)}'),
                      trailing: Text(
                        '${entry.calories} cal',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieInfo(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.blue,
          ),
        ),
      ],
    );
  }

  void _addFoodEntry() {
    if (foodNameController.text.isNotEmpty && calorieController.text.isNotEmpty) {
      final newEntry = FoodEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: foodNameController.text,
        calories: int.parse(calorieController.text),
        timestamp: DateTime.now(),
      );

      setState(() {
        foodEntries.add(newEntry);
      });

      foodNameController.clear();
      calorieController.clear();
    }
  }

  void _showCalorieSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Daily Calorie Limit'),
        content: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Calories',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              setState(() {
                dailyCalorieLimit = int.parse(value);
              });
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}