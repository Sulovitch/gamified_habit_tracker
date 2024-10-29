// lib/models/habit.dart

class Habit {
  final String name;
  final int goal; // Goal in minutes
  final String gifUrl;
  final String category; // New category property
  int progress; // Current progress toward the goal
  int points; // Points earned for this habit

  Habit({
    required this.name,
    required this.goal,
    required this.gifUrl,
    required this.category, // Update constructor to include category
    this.progress = 0,
    this.points = 0,
  });

  // Method to update progress and points
  void completeHabit(int minutes) {
    progress += minutes;
    if (progress >= goal) {
      points += 10; // Earn points for completing the habit
      progress = goal; // Reset progress after reaching the goal
    }
  }
}
