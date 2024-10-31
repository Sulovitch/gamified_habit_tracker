import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_card.dart';
import '../widgets/user_progress.dart';
import '../widgets/animated_fab.dart';
import 'add_habit_screen.dart';
import 'analytics_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gamified Habit Tracker'),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0), // Add padding
            child: IconButton(
              icon: Icon(
                Icons.analytics,
                size: 30, // Increase icon size
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AnalyticsScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          return Column(
            children: [
              UserProgress(),
              SizedBox(height: 16), // Space between UserProgress and buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AnalyticsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'View Analytics',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16), // Space between buttons
              Expanded(
                child: habitProvider.habits.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "No habits added yet!",
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => AddHabitScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Add Habit',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of cards per row
                          crossAxisSpacing:
                              10, // Horizontal space between cards
                          mainAxisSpacing: 10, // Vertical space between cards
                          childAspectRatio:
                              1.5, // Aspect ratio for fixed-size cards
                        ),
                        padding: const EdgeInsets.all(10),
                        itemCount: habitProvider.habits.length,
                        itemBuilder: (context, index) {
                          return HabitCard(habit: habitProvider.habits[index]);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: AnimatedFAB(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddHabitScreen()),
          );
        },
      ),
    );
  }
}
