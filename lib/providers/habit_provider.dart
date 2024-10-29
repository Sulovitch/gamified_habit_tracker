import 'package:flutter/foundation.dart';
import '../models/habit.dart';
import 'dart:typed_data'; // Import for Uint8List

class HabitProvider with ChangeNotifier {
  final List<Habit> _habits = []; // List of all habits
  String _userAvatarPath = ''; // Store the user avatar's local file path
  Uint8List? _userAvatarBytes; // Store user avatar bytes for web
  String _userName = 'Guest'; // Default user name
  List<Habit> _filteredHabits = []; // List for filtered habits

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
  }

  // Update an existing habit
  void updateHabit(Habit oldHabit, Habit updatedHabit) {
    final index = _habits.indexOf(oldHabit); // Find the index of the old habit
    if (index != -1) {
      _habits[index] = updatedHabit; // Update the habit at the found index
      notifyListeners(); // Notify listeners about the update
    } else {
      throw Exception(
          'Habit not found'); // Handle the case where the habit is not found
    }
  }

  // Complete a habit and add points based on the time spent
  void completeHabit(Habit habit, int minutes) {
    habit.completeHabit(
        minutes); // Update the habit's points based on minutes completed
    notifyListeners(); // Notify listeners about the completion
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

  // Remove a habit from the list
  void removeHabit(Habit habit) {
    _habits.remove(habit); // Remove the habit from the list
    notifyListeners(); // Notify listeners about the removal
  }
}
