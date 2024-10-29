import 'dart:io';
import 'dart:typed_data'; // Import for Uint8List
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart'; // Import Permission class
import '../providers/habit_provider.dart';

class AvatarPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final ImagePicker _picker = ImagePicker();

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            // Skip permission request on web
            if (kIsWeb) {
              try {
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  // Read bytes for web
                  final Uint8List bytes = await image.readAsBytes();
                  // Set the image bytes in the provider
                  habitProvider.setUserAvatarBytes(bytes);
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error picking image: $e')),
                );
              }
            } else {
              // Request permission on mobile
              var status = await Permission.photos.request();
              if (status.isGranted) {
                try {
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    // Set the local file path in the provider
                    habitProvider.setUserAvatar(image.path);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error picking image: $e')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Photo access permission denied')),
                );
              }
            }
          },
          child: CircleAvatar(
            radius: 50,
            backgroundImage: kIsWeb && habitProvider.userAvatarBytes != null
                ? MemoryImage(habitProvider.userAvatarBytes!)
                : (habitProvider.userAvatarPath.isNotEmpty
                    ? FileImage(File(habitProvider.userAvatarPath))
                    : null),
            child: habitProvider.userAvatarPath.isEmpty &&
                    habitProvider.userAvatarBytes == null
                ? const Icon(Icons.person,
                    size: 50, color: Color.fromARGB(255, 255, 255, 255))
                : null,
          ),
        ),
        const SizedBox(height: 8),
        const SizedBox(height: 16),
      ],
    );
  }
}
