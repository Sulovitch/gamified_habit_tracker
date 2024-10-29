import 'package:flutter/foundation.dart';
import '../models/habit.dart';
import 'dart:typed_data'; // Import for Uint8List

class HabitProvider with ChangeNotifier {
  final List<Habit> _habits = [];
  String _userAvatarPath = ''; // Store the user avatar's local file path
  Uint8List? _userAvatarBytes; // Store user avatar bytes for web
  String _userName = 'Guest'; // Set default user name to "Guest"

  List<Habit> get habits => _habits;

  String get userAvatarPath => _userAvatarPath; // Getter for avatar file path
  Uint8List? get userAvatarBytes => _userAvatarBytes; // Getter for avatar bytes
  String get userName => _userName; // Getter for user's name

  void setUserAvatar(String path) {
    _userAvatarPath = path; // Update the avatar file path
    _userAvatarBytes = null; // Clear bytes when setting from path
    notifyListeners(); // Notify listeners to update UI with new avatar
  }

  void setUserAvatarBytes(Uint8List bytes) {
    _userAvatarBytes = bytes; // Update avatar bytes for web
    notifyListeners(); // Notify listeners to update UI with new avatar
  }

  void setUserName(String name) {
    _userName = name.isEmpty
        ? 'Guest'
        : name; // Update the user's name or set to "Guest" if empty
    notifyListeners(); // Notify listeners to update UI with new name
  }

  // Add habit with category to the list
  void addHabit(String name, int goal, String gifUrl, String category) {
    _habits
        .add(Habit(name: name, goal: goal, gifUrl: gifUrl, category: category));
    notifyListeners();
  }

  // Complete a habit and add points based on the time spent
  void completeHabit(Habit habit, int minutes) {
    habit.completeHabit(minutes);
    notifyListeners();
  }

  // Calculate user level based on total points
  int get userLevel {
    int totalPoints = _habits.fold(0, (sum, habit) => sum + habit.points);
    return (totalPoints ~/ 100); // 100 points per level
  }

  // Calculate total rewards (sum of points for all habits)
  int get totalRewards {
    return _habits.fold(0, (sum, habit) => sum + habit.points);
  }
}
