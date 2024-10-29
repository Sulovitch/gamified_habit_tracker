import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App logo or image
              Image.asset(
                'images/logo.png', // Add your logo image here
                height: 300, // Adjust height as necessary
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              // Welcome title
              Text(
                'Welcome to Habit Tracker!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              // Description
              Text(
                'Track your habits and achieve your goals.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              // Additional information
              Text(
                'Enjoy your journey of self-improvement!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // Navigate to Home Screen button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, '/home'); // Navigate to home screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).primaryColor, // Button color
                  foregroundColor: Colors.white, // Text color
                  padding: EdgeInsets.symmetric(
                      horizontal: 52, vertical: 26), // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                child: Text('Get Started'), // Button text
              ),
            ],
          ),
        ),
      ),
    );
  }
}
