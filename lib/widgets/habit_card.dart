import 'dart:async';
import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import 'package:provider/provider.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;

  HabitCard({required this.habit});

  @override
  _HabitCardState createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  Timer? _timer; // Timer for countdown
  int _remainingTime = 0; // Remaining time in seconds
  int _completedTime = 0; // Completed time in seconds
  bool _isTimerRunning = false; // Timer state
  bool _isPaused = false; // Pause state

  // Size constants
  static const double cardHeight = 100; // Card height
  static const double gifHeight = 100; // GIF height
  static const double habitNameFontSize = 30; // Habit name font size
  static const double goalProgressFontSize = 16; // Goal and progress font size
  static const double completedTimeFontSize = 16; // Completed time font size
  static const EdgeInsets buttonPadding =
      EdgeInsets.symmetric(vertical: 10); // Button padding

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer if the widget is disposed
    super.dispose();
  }

  // Start or resume the timer
  void _startTimer() {
    if (!_isTimerRunning) {
      setState(() {
        _remainingTime = widget.habit.goal; // Set goal time in seconds
        _completedTime = 0; // Reset completed time
      });
    }

    setState(() {
      _isTimerRunning = true;
      _isPaused = false; // Timer is no longer paused
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0 && !_isPaused) {
        setState(() {
          _remainingTime--; // Decrease remaining time
          _completedTime++; // Increase completed time
        });
      } else if (_remainingTime == 0) {
        _timer?.cancel(); // Stop timer when it reaches zero
        _completeHabit();
      }
    });
  }

  void _pauseTimer() {
    setState(() {
      _isPaused = true; // Pause the timer
    });
    _timer?.cancel(); // Cancel the periodic timer while paused
  }

  void _completeHabit() {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    habitProvider.completeHabit(widget.habit, widget.habit.goal);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Great job! You earned 10 points!'),
        duration: Duration(seconds: 2),
      ),
    );
    setState(() {
      _isTimerRunning = false; // Reset timer state
      _remainingTime = 0; // Reset remaining time
      _completedTime = 0; // Reset completed time
    });
  }

  // Helper method to format time conditionally
  String _formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    List<String> timeParts = [];

    if (hours > 0) {
      timeParts.add('$hours hours');
    }
    if (minutes > 0 || hours > 0) {
      timeParts.add('$minutes minutes');
    }
    if (seconds > 0 || (hours == 0 && minutes == 0)) {
      timeParts.add('$seconds seconds');
    }

    return timeParts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    double progress = _completedTime / widget.habit.goal; // Calculate progress

    return Card(
      elevation: 5,
      child: SizedBox(
        height: cardHeight, // Use the cardHeight variable
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Conditionally display habit GIF if URL is provided
            if (widget.habit.gifUrl.isNotEmpty) ...[
              Image.network(
                widget.habit.gifUrl,
                height: gifHeight, // Set a fixed height for the GIF
                fit: BoxFit.cover,
              ),
              SizedBox(height: 8),
            ],
            // Display habit name
            Text(
              widget.habit.name,
              style: TextStyle(
                  fontSize: habitNameFontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            // Display habit goal in formatted time
            Text(
              'Goal: ${_formatTime(widget.habit.goal)}',
              style: TextStyle(fontSize: goalProgressFontSize),
            ),
            SizedBox(height: 8),
            // Display habit progress in formatted time
            Text(
              'Progress: ${_formatTime(_completedTime)}',
              style: TextStyle(fontSize: goalProgressFontSize),
            ),
            SizedBox(height: 8),
            // Completed time label
            if (_isTimerRunning) ...[
              Text(
                'Completed: ${_formatTime(_completedTime)}',
                style: TextStyle(
                    fontSize: completedTimeFontSize,
                    fontWeight: FontWeight.bold),
              ),
            ],
            SizedBox(height: 8),
            // Linear Progress Indicator
            LinearProgressIndicator(
              value: progress, // Set the progress
              minHeight: 8, // Height of the progress bar
              backgroundColor: Colors.grey[300], // Background color
              color: const Color.fromARGB(72, 9, 255, 0), // Progress color
            ),
            SizedBox(height: 8),
            // Start, Pause, or Resume button
            ElevatedButton(
              onPressed: _isTimerRunning && !_isPaused
                  ? _pauseTimer // Show pause if the timer is running
                  : _startTimer, // Start or resume the timer
              child: Padding(
                padding: buttonPadding,
                child: Text(_isPaused
                    ? 'Resume' // Show 'Resume' when paused
                    : (_isTimerRunning
                        ? 'Pause'
                        : 'Start Habit')), // Show 'Start Habit' or 'Pause'
              ),
            ),
          ],
        ),
      ),
    );
  }
}
