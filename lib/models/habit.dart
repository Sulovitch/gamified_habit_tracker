class Habit {
  final String name;
  final int goal; // Goal in minutes
  final String gifUrl;
  final String category; // New category property
  int progress; // Current progress toward the goal
  int points; // Points earned for this habit
  bool isCompleted;
  DateTime? completedDate; // New property to track the completion date

  Habit({
    required this.name,
    required this.goal,
    required this.gifUrl,
    required this.category, // Update constructor to include category
    this.isCompleted = false,
    this.progress = 0,
    this.points = 0,
    this.completedDate, // Initialize completedDate
  });

  // Method to update progress and points when a habit is completed
  void completeHabit(int minutes) {
    progress += minutes; // Update the progress with the completed minutes

    if (progress >= goal) {
      points += 10; // Earn points for completing the habit
      progress = goal; // Cap progress at the goal
      isCompleted = true; // Mark the habit as completed
      completedDate = DateTime.now(); // Set the completed date to now
    }
  }

  // Method to update progress
  void updateProgress(int newProgress) {
    if (newProgress >= 0 && newProgress <= goal) {
      progress = newProgress; // Update progress
    }
  }

  // Method to reset the habit
  void resetHabit() {
    isCompleted = false; // Mark as not completed
    progress = 0; // Reset progress
    completedDate = null; // Reset completed date
  }

  // Method to uncomplete the habit
  void uncompleteHabit() {
    isCompleted = false; // Reset the completion status
    completedDate = null; // Reset completed date
    // Reset points or any other logic if needed
  }
}
