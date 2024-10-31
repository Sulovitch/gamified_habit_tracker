import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import '../providers/habit_provider.dart'; // Adjust the import based on your structure

class AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Analytics',
          style: TextStyle(fontSize: 24), // Increased title size
        ),
        centerTitle: true,
        backgroundColor: Colors.teal, // Set a professional color
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0), // Increased padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              'Your Habits Overview',
              style: Theme.of(context).textTheme.headline4?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                    fontSize: 28, // Increased header size
                  ),
            ),
            SizedBox(height: 24), // Increased space
            // Display total habits
            Text(
              'Total Habits: ${habitProvider.habits.length}',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontSize: 20, // Increased text size
                  ),
            ),
            SizedBox(height: 24), // Increased space
            // Display the chart
            Expanded(
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildHabitsProgressChart(habitProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitsProgressChart(HabitProvider habitProvider) {
    // Assuming habits have a 'completedDate' property indicating when they were completed
    final completedData = habitProvider.habits
        .where((habit) => habit.isCompleted && habit.completedDate != null)
        .fold<Map<DateTime, int>>({}, (map, habit) {
      final date = habit.completedDate!; // Use completedDate
      map[date] = (map[date] ?? 0) + 1; // Increment habit count for that date
      return map;
    });

    final List<BarChartGroupData> barGroups =
        completedData.entries.map((entry) {
      final date = entry.key;
      final count = entry.value;
      return BarChartGroupData(
        x: date.day, // Use day of the month for x-axis
        barRods: [
          BarChartRodData(
            toY: count.toDouble(),
            color: Colors.green,
            width: 30,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      );
    }).toList();

    // Calculate time spent and not completed habits
    int totalSecondsSpent = habitProvider.habits
        .where((habit) => habit.isCompleted)
        .fold(
            0,
            (total, habit) =>
                total + habit.progress); // Assume progress is in seconds

    // Calculate hours, minutes, and seconds
    String formattedTimeSpent = formatDuration(totalSecondsSpent);
    int notCompletedCount =
        habitProvider.habits.where((habit) => !habit.isCompleted).length;

    return Row(
      children: [
        // Left Side: Time Spent
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Time Spent:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              formattedTimeSpent,
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
            SizedBox(height: 16),
            Text(
              'Not Completed Habits:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '$notCompletedCount',
              style: TextStyle(fontSize: 24, color: Colors.red),
            ),
          ],
        ),
        SizedBox(width: 16), // Space between left column and chart
        // Right Side: Chart
        Expanded(
          child: BarChart(
            BarChartData(
              barGroups: barGroups,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(), // Display the y-value
                        style: TextStyle(fontSize: 16),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(), // Use day as the label
                        style: TextStyle(fontSize: 16),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: true),
              barTouchData: BarTouchData(enabled: false),
            ),
          ),
        ),
      ],
    );
  }

  String formatDuration(int totalSeconds) {
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;

    return '$hours h $minutes min $seconds s';
  }
}

extension on TextTheme {
  get headline4 => null;

  get headline6 => null;
}
