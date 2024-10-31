import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/habit_provider.dart';
import 'screens/home_screen.dart';
import 'screens/Welcome_Screen.dart';

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
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => WelcomeScreen(),
          '/home': (context) =>
              HomeScreen(), // Replace with your Home Screen widget
        },
      ),
    );
  }
}
