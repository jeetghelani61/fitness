import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<WorkoutData> weeklyData = [
    WorkoutData('Mon', 3, 450),
    WorkoutData('Tue', 2, 300),
    WorkoutData('Wed', 4, 600),
    WorkoutData('Thu', 1, 150),
    WorkoutData('Fri', 3, 450),
    WorkoutData('Sat', 2, 300),
    WorkoutData('Sun', 0, 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress Tracking'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weekly Summary Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This Week',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard('Workouts', '12'),
                        _buildStatCard('Total Time', '8h 30m'),
                        _buildStatCard('Calories', '3,450'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Workouts Chart
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Workouts',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 200,
                      child: CustomBarChart(weeklyData: weeklyData),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Calories Chart
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calories Burned',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 200,
                      child: CustomLineChart(weeklyData: weeklyData),
                    ),
                  ],
                ),
              ),
            ),

            // Progress Indicators
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Progress',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    _buildProgressIndicator('Workout Consistency', 0.75, Colors.blue),
                    SizedBox(height: 12),
                    _buildProgressIndicator('Calorie Goal', 0.60, Colors.green),
                    SizedBox(height: 12),
                    _buildProgressIndicator('Weight Loss', 0.45, Colors.orange),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(String label, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[200],
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Bar Chart Widget
class CustomBarChart extends StatelessWidget {
  final List<WorkoutData> weeklyData;

  const CustomBarChart({Key? key, required this.weeklyData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxWorkouts = weeklyData.map((e) => e.workouts).reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        // Bars with values
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weeklyData.asMap().entries.map((entry) {
              final data = entry.value;
              final heightFactor = maxWorkouts > 0 ? data.workouts / maxWorkouts : 0;

              return Column(
                children: [
                  // Value above bar
                  Text(
                    data.workouts.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 4),
                  // Bar
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 25,
                        height: heightFactor * 120, // Adjust height as needed
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.blue, Colors.lightBlueAccent],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),

        // Day labels
        Container(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weeklyData.map((data) {
              return Text(
                data.day,
                style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// Custom Line Chart Widget
class CustomLineChart extends StatelessWidget {
  final List<WorkoutData> weeklyData;

  const CustomLineChart({Key? key, required this.weeklyData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxCalories = weeklyData.map((e) => e.calories).reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        // Chart Area with values
        Expanded(
          child: Stack(
            children: [
              // Grid lines
              Container(
                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(
                  painter: GridPainter(),
                ),
              ),
              // Line chart
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: CustomPaint(
                  size: Size.infinite,
                  painter: LineChartPainter(
                    weeklyData: weeklyData,
                    maxValue: maxCalories.toDouble(),
                  ),
                ),
              ),
              // Values on points
              ...weeklyData.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                final xPosition = (index / (weeklyData.length - 1)) * (MediaQuery.of(context).size.width - 40);
                final yPosition = 10 + (1 - (data.calories / maxCalories)) * 120;

                return Positioned(
                  left: xPosition - 15,
                  top: yPosition - 20,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      data.calories.toString(),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),

        // Day labels
        Container(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weeklyData.map((data) {
              return Text(
                data.day,
                style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// Grid Painter for background
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5;

    // Draw horizontal grid lines
    for (double i = 0; i <= size.height; i += size.height / 4) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Line Chart Painter
class LineChartPainter extends CustomPainter {
  final List<WorkoutData> weeklyData;
  final double maxValue;

  LineChartPainter({required this.weeklyData, required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (weeklyData.isEmpty || maxValue == 0) return;

    final linePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final fillPaint = Paint()
      ..color = Colors.green.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final points = <Offset>[];
    final spacing = size.width / (weeklyData.length - 1);

    for (int i = 0; i < weeklyData.length; i++) {
      final x = i * spacing;
      final y = size.height - (weeklyData[i].calories / maxValue) * size.height;
      points.add(Offset(x, y));
    }

    // Draw filled area
    final path = Path();
    path.moveTo(0, size.height);
    for (final point in points) {
      path.lineTo(point.dx, point.dy);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, fillPaint);

    // Draw line
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], linePaint);
    }

    // Draw dots
    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
      canvas.drawCircle(point, 2, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class WorkoutData {
  final String day;
  final int workouts;
  final int calories;

  WorkoutData(this.day, this.workouts, this.calories);
}