import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import 'avatar_picker.dart'; // Import AvatarPicker

class UserProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    // Calculate the progress toward the next level
    int totalPoints = habitProvider.totalRewards;
    int userLevel = habitProvider.userLevel;
    double progress = totalPoints % 100 / 100;

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5,
              spreadRadius: 2),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar and name display
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AvatarPicker(), // Include the AvatarPicker here
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  String? newName = await _showNameInputDialog(
                      context, habitProvider.userName);
                  if (newName != null && newName.isNotEmpty) {
                    habitProvider.setUserName(
                        newName); // Update the provider with the new name
                  }
                },
                child: Text(
                  habitProvider.userName.isEmpty
                      ? 'Guest'
                      : habitProvider.userName,
                  style: const TextStyle(
                      fontSize: 20, // Font size for the name
                      fontWeight: FontWeight.bold,
                      color: Colors.black), // Black color for the name
                ),
              ),
              const SizedBox(height: 8), // Space between name and icon
              IconButton(
                icon: Icon(Icons.edit,
                    color: Colors.black), // Set icon color to black
                onPressed: () async {
                  String? newName = await _showNameInputDialog(
                      context, habitProvider.userName);
                  if (newName != null && newName.isNotEmpty) {
                    habitProvider.setUserName(
                        newName); // Update the provider with the new name
                  }
                },
              ),
            ],
          ),
          const SizedBox(
              width: 16), // Space between avatar and progress details
          Expanded(
            // Use Expanded to take up remaining space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Level: $userLevel',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Total Points: $totalPoints',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  color: const Color.fromARGB(72, 9, 255, 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _showNameInputDialog(
      BuildContext context, String currentName) async {
    final TextEditingController controller =
        TextEditingController(text: currentName);
    String? newName;

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter your name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                newName =
                    controller.text; // Get the new name from the text field
                Navigator.of(context).pop(newName);
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without changing the name
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
