import 'package:flutter/foundation.dart';
import '../models/habit.dart';
import 'dart:typed_data'; // Import for Uint8List
import 'dart:async'; // Import for Timer

class HabitProvider with ChangeNotifier {
  final List<Habit> _habits = []; // List of all habits
  String _userAvatarPath = ''; // Store the user avatar's local file path
  Uint8List? _userAvatarBytes; // Store user avatar bytes for web
  String _userName = 'Guest'; // Default user name
  List<Habit> _filteredHabits = []; // List for filtered habits
  Timer? _timer; // Timer for tracking habit progress
  int _currentHabitIndex = -1; // Index of the currently active habit
  int _timeSpent = 0; // Time spent on the current habit in seconds

  // Getter for all habits, filtered or not
  List<Habit> get habits => _filteredHabits.isEmpty ? _habits : _filteredHabits;

  // Getter for user avatar path
  String get userAvatarPath => _userAvatarPath;

  // Getter for user avatar bytes
  Uint8List? get userAvatarBytes => _userAvatarBytes;

  // Getter for user's name
  String get userName => _userName;

  // Set user avatar from file path
  void setUserAvatar(String path) {
    _userAvatarPath = path; // Update the avatar file path
    _userAvatarBytes = null; // Clear bytes when setting from path
    notifyListeners(); // Notify listeners to update UI with new avatar
  }

  // Set user avatar from bytes (for web)
  void setUserAvatarBytes(Uint8List bytes) {
    _userAvatarBytes = bytes; // Update avatar bytes for web
    notifyListeners(); // Notify listeners to update UI with new avatar
  }

  // Set user's name
  void setUserName(String name) {
    _userName =
        name.isEmpty ? 'Guest' : name; // Update or reset the user's name
    notifyListeners(); // Notify listeners to update UI with new name
  }

  // Add a new habit with category to the list
  void addHabit(String name, int goal, String gifUrl, String category) {
    if (name.isEmpty) {
      throw ArgumentError(
          'Habit name cannot be empty'); // Ensure the habit name is valid
    }

    // Create and add the habit
    _habits
        .add(Habit(name: name, goal: goal, gifUrl: gifUrl, category: category));
    notifyListeners(); // Notify listeners about the addition
    _logEvent('add_habit', {
      'name': name,
      'goal': goal,
      'gifUrl': gifUrl,
      'category': category,
    });

    // Update analytics
    updateAnalytics();
  }

  // Start tracking a habit
  void startHabit(int index) {
    if (_currentHabitIndex != -1) {
      print('A habit is already in progress.'); // Optionally inform the user
      return; // Exit if another habit is already being tracked
    }

    _currentHabitIndex = index; // Store the index of the habit being tracked
    _timeSpent = 0; // Reset time spent
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _timeSpent++; // Increment the time spent every second
    });
    _logEvent('start_habit', {
      'habitName': _habits[index].name,
    });
  }

  // Finish tracking a habit and mark it as completed
  void finishHabit() {
    if (_currentHabitIndex == -1) {
      print('No habit is currently being tracked.'); // Inform the user
      return; // Exit if no habit is being tracked
    }

    Habit habit = _habits[_currentHabitIndex];
    completeHabit(habit, _timeSpent); // Complete the habit with the time spent
    _timer?.cancel(); // Stop the timer
    _currentHabitIndex = -1; // Reset the current habit index
  }

  // Complete a habit and add points based on the time spent
  void completeHabit(Habit habit, int completedTime) {
    if (habit.isCompleted) {
      print(
          '${habit.name} is already completed.'); // Optionally inform the user
      return; // Exit if the habit is already completed
    }

    // Update the habit's progress and points based on completed time
    habit.completeHabit(completedTime);

    // Notify listeners about the completion
    notifyListeners();
    _logEvent('complete_habit', {
      'name': habit.name,
      'minutes': completedTime,
    });

    // Update analytics
    updateAnalytics();
  }

  // Uncomplete a habit
  void uncompleteHabit(Habit habit) {
    if (!habit.isCompleted) {
      print(
          '${habit.name} is not completed.'); // Inform if the habit is not completed
      return; // Exit if the habit is not completed
    }

    // Update the habit's completion status
    habit.uncompleteHabit(); // This method should reset the completion status

    // Notify listeners about the uncompletion
    notifyListeners();
    _logEvent('uncomplete_habit', {
      'name': habit.name,
    });

    // Update analytics
    updateAnalytics();
  }

  // Remove a habit from the list
  void removeHabit(Habit habit) {
    _habits.remove(habit); // Remove the habit from the list
    notifyListeners(); // Notify listeners about the removal
    _logEvent('remove_habit', {
      'name': habit.name,
    });

    // Update analytics
    updateAnalytics();
  }

// Function to update analytics based on current habits
  void updateAnalytics() {
    int totalHabits = _habits.length;
    int totalPoints = totalRewards;
    int inProgressCount =
        _currentHabitIndex != -1 ? 1 : 0; // Count in-progress habits

    // Log current analytics state
    _logEvent('update_analytics', {
      'totalHabits': totalHabits,
      'totalPoints': totalPoints,
      'userLevel': userLevel,
      'inProgressCount': inProgressCount, // Add in-progress count to analytics
    });
  }

  // Function to log events to the console
  void _logEvent(String eventName, Map<String, dynamic> parameters) {
    if (kDebugMode) {
      // Print logs only in debug mode
      print('Event: $eventName, Parameters: $parameters');
    }
  }

  // Calculate user level based on total points
  int get userLevel {
    int totalPoints = _habits.fold(
        0, (sum, habit) => sum + habit.points); // Sum points of all habits
    return (totalPoints ~/ 100); // 100 points per level
  }

  // Calculate total rewards (sum of points for all habits)
  int get totalRewards {
    return _habits.fold(
        0, (sum, habit) => sum + habit.points); // Sum points for all habits
  }

  // Filter habits based on the query
  void filterHabits(String query) {
    if (query.isEmpty) {
      _filteredHabits.clear(); // Clear the filter if the query is empty
    } else {
      _filteredHabits = _habits.where((habit) {
        // Filter by name or category
        return habit.name.toLowerCase().contains(query.toLowerCase()) ||
            habit.category.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners(); // Notify listeners to update the UI
  }
}
