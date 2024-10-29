import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/habit_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HabitProvider(),
      child: MaterialApp(
        title: 'Gamified Habit Tracker',
        theme: ThemeData(
          primaryColor: Colors.teal,
          colorScheme:
              ColorScheme.light(primary: Colors.teal, secondary: Colors.amber),
          textTheme: TextTheme(
            // Use deprecated styles for broader compatibility
            titleLarge:
                TextStyle(color: Colors.black, fontSize: 20), // For headings
            bodyLarge:
                TextStyle(color: Colors.black, fontSize: 16), // General text
            bodyMedium:
                TextStyle(color: Colors.black, fontSize: 14), // Smaller text
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
