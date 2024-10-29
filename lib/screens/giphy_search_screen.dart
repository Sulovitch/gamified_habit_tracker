// lib/screens/giphy_search_screen.dart

import 'package:flutter/material.dart';
import 'giphy_service.dart'; // Ensure this is the correct import for GiphyService

class GiphySearchScreen extends StatefulWidget {
  final String habitName; // This should be defined to accept the habit name

  GiphySearchScreen(
      {required this.habitName}); // Constructor with required parameter

  @override
  _GiphySearchScreenState createState() => _GiphySearchScreenState();
}

class _GiphySearchScreenState extends State<GiphySearchScreen> {
  late Future<List<String>> _gifs; // Variable to hold the GIFs

  @override
  void initState() {
    super.initState();
    _gifs = GiphyService()
        .fetchGifs(widget.habitName); // Use the habit name to fetch GIFs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a GIF for ${widget.habitName}'),
      ),
      body: FutureBuilder<List<String>>(
        future: _gifs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final gifs = snapshot.data ?? [];
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: gifs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(
                        context, gifs[index]); // Return the selected GIF
                  },
                  child: Image.network(
                    gifs[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
