import 'dart:async';
import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import 'package:provider/provider.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;

  const HabitCard({Key? key, required this.habit}) : super(key: key);

  @override
  _HabitCardState createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  Timer? _timer;
  int _remainingTime = 0;
  int _completedTime = 0;
  bool _isTimerRunning = false;
  bool _isPaused = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (!_isTimerRunning) {
      setState(() {
        _remainingTime = widget.habit.goal; // Set remaining time to goal time
        _completedTime = 0; // Reset completed time
      });
    }

    setState(() {
      _isTimerRunning = true;
      _isPaused = false;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0 && !_isPaused) {
        setState(() {
          _remainingTime--;
          _completedTime++;
        });
      } else if (_remainingTime == 0) {
        _timer?.cancel();
        _completeHabit(); // Automatically complete the habit when time is up
      }
    });
  }

  void _pauseTimer() {
    setState(() {
      _isPaused = true;
    });
    _timer?.cancel();
  }

  void _completeHabit() {
    if (widget.habit.isCompleted) return; // Prevent completing again

    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    habitProvider.completeHabit(widget.habit, _completedTime);

    if (widget.habit.points > 0) {
      // Rewarding points
      habitProvider.updateAnalytics();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Great job! You earned ${widget.habit.points} points!'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    // Update local state to reflect completion
    setState(() {
      _isTimerRunning = false;
      _remainingTime = 0;
      _completedTime = 0;
    });
  }

  void _uncompleteHabit() {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    habitProvider
        .uncompleteHabit(widget.habit); // Define this method in HabitProvider

    setState(() {
      _completedTime = 0; // Reset progress
      _remainingTime = widget.habit.goal; // Reset timer
      _isTimerRunning = false; // Stop the timer
    });
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content:
              Text('Are you sure you want to delete "${widget.habit.name}"?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteHabit();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteHabit() {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    habitProvider.removeHabit(widget.habit);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.habit.name} deleted.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    List<String> timeParts = [];

    if (hours > 0) {
      timeParts.add('$hours h');
    }
    if (minutes > 0 || hours > 0) {
      timeParts.add('$minutes m');
    }
    if (seconds > 0 || (hours == 0 && minutes == 0)) {
      timeParts.add('$seconds s');
    }

    return timeParts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (widget.habit.gifUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.habit.gifUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.habit.name,
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Goal: ${_formatTime(widget.habit.goal)}',
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Progress: ${_formatTime(_completedTime)}',
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(height: 4),
                    if (widget.habit.isCompleted) ...[
                      Text(
                        'Status: Completed',
                        style: TextStyle(fontSize: 20, color: Colors.green),
                      ),
                    ] else if (_isTimerRunning) ...[
                      Text(
                        'Status: In Progress',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ] else ...[
                      Text(
                        'Status: Not Started',
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    ],
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: widget.habit.isCompleted
                          ? 1.0
                          : _completedTime / widget.habit.goal,
                      minHeight: 4,
                      backgroundColor: Colors.grey[300],
                      color: const Color.fromARGB(72, 9, 255, 0),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _isTimerRunning && !_isPaused
                              ? _pauseTimer
                              : _startTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            _isPaused
                                ? 'Resume'
                                : (_isTimerRunning ? 'Pause' : 'Start'),
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _showDeleteConfirmation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 82, 82, 82),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            'Delete',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
