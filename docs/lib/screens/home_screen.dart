import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_card.dart';
import '../widgets/user_progress.dart';
import '../widgets/animated_fab.dart';
import 'add_habit_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gamified Habit Tracker'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          return Column(
            children: [
              UserProgress(),
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
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75,
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
