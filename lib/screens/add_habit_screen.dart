import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import 'giphy_search_screen.dart';

class AddHabitScreen extends StatefulWidget {
  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _hoursController = TextEditingController();
  final _minutesController = TextEditingController();
  final _secondsController = TextEditingController();
  String _selectedGifUrl = '';

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Habit'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextField(_nameController, 'Habit Name'),
              SizedBox(height: 16),
              _buildTextField(_categoryController, 'Category'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimeTextField(_hoursController, 'Hours'),
                  SizedBox(width: 8),
                  _buildTimeTextField(_minutesController, 'Minutes'),
                  SizedBox(width: 8),
                  _buildTimeTextField(_secondsController, 'Seconds'),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final gifUrl = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GiphySearchScreen(habitName: _nameController.text),
                    ),
                  );

                  if (gifUrl != null) {
                    setState(() {
                      _selectedGifUrl = gifUrl;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Search GIF'),
              ),
              if (_selectedGifUrl.isNotEmpty) ...[
                SizedBox(height: 20),
                Image.network(
                  _selectedGifUrl,
                  height: 100,
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final habitProvider =
                      Provider.of<HabitProvider>(context, listen: false);
                  final name = _nameController.text;
                  final category = _categoryController.text;

                  // Parse the time from the input fields
                  int hours = int.tryParse(_hoursController.text) ?? 0;
                  int minutes = int.tryParse(_minutesController.text) ?? 0;
                  int seconds = int.tryParse(_secondsController.text) ?? 0;

                  // Total goal in seconds
                  final totalGoal = (hours * 3600) + (minutes * 60) + seconds;

                  // Validate that the habit name, category, and time are filled out
                  if (_validateFields(name, category, totalGoal)) {
                    habitProvider.addHabit(
                        name, totalGoal, _selectedGifUrl, category);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill out all fields')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Add Habit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Container(
      width: 300,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        ),
      ),
    );
  }

  Widget _buildTimeTextField(TextEditingController controller, String label) {
    return Container(
      width: 80,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        ),
      ),
    );
  }

  bool _validateFields(String name, String category, int totalGoal) {
    // Validate that habit name, category, and time (totalGoal) are filled out
    return name.isNotEmpty && category.isNotEmpty && totalGoal > 0;
  }
}
