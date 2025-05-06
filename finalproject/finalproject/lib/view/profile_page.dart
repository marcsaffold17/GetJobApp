import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = 'Loading...';
  String _email = 'Loading...';
  String _bio = '';
  File? _image;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _bioController = TextEditingController();

  List<String> _workExperience = [];
  List<String> _education = [];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('Login-Info')
              .doc(user.email)
              .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _username = data['username'] ?? 'No username';
          _email = data['email'] ?? user.email!;
          _bio = data['bio'] ?? '';
          _bioController.text = _bio;

          final we = data['workExperience'];
          _workExperience = we is List ? List<String>.from(we) : [];

          final ed = data['education'];
          _education = ed is List ? List<String>.from(ed) : [];
        });
      }
    }

    final prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profileImage');
    if (imagePath != null && File(imagePath).existsSync()) {
      _image = File(imagePath);
    }
  }

  Future<void> _saveBio() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final bioText = _bioController.text;
      setState(() {
        _bio = bioText;
      });
      await FirebaseFirestore.instance
          .collection('Login-Info')
          .doc(user.email)
          .update({'bio': bioText});
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _image = File(pickedFile.path);
      });
      await prefs.setString('profileImage', pickedFile.path);
    }
  }

  void _addWorkExperience() {
    String newWorkExperience = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Work Experience'),
          content: TextField(
            onChanged: (value) {
              newWorkExperience = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter your work experience',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newWorkExperience.isNotEmpty) {
                  setState(() {
                    _workExperience.add(newWorkExperience);
                  });
                  _saveWorkExperience();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addEducation() {
    String newEducation = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Education'),
          content: TextField(
            onChanged: (value) {
              newEducation = value;
            },
            decoration: const InputDecoration(hintText: 'Enter your education'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newEducation.isNotEmpty) {
                  setState(() {
                    _education.add(newEducation);
                  });
                  _saveEducation();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveWorkExperience() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Login-Info')
          .doc(user.email)
          .update({'workExperience': _workExperience});
    }
  }

  Future<void> _saveEducation() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Login-Info')
          .doc(user.email)
          .update({'education': _education});
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkBlue = const Color(0xFF002B4B);
    final darkBackground = const Color.fromARGB(
      255,
      80,
      80,
      80,
    ); // Dark mode color
    final lightBackground = Colors.white; // Light mode background color
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    // Determine if dark mode is enabled
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "My Workout Profile",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        backgroundColor: darkBlue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              context.watch<ThemeNotifier>().isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () => context.read<ThemeNotifier>().toggleTheme(),
          ),
        ],
      ),
      body: Container(
        color:
            isDarkMode
                ? darkBackground
                : lightBackground, // Apply conditional background color
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        _image != null
                            ? FileImage(_image!)
                            : const AssetImage('assets/images/AshtonHall.webp')
                                as ImageProvider,
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 18,
                        child: Icon(
                          Icons.edit,
                          size: 18,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _username,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _email,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor?.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'About Me',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _bioController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                  filled: true,
                  hintText: 'Write something about yourself...'.toLowerCase(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
                onChanged: (value) => _saveBio(),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Work Experience',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _workExperience.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _workExperience[index],
                      style: TextStyle(color: textColor),
                    ),
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBlue,
                  foregroundColor: Colors.white,
                ),
                onPressed: _addWorkExperience,
                child: const Text('Add Work Experience'),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Education',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _education.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _education[index],
                      style: TextStyle(color: textColor),
                    ),
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBlue,
                  foregroundColor: Colors.white,
                ),
                onPressed: _addEducation,
                child: const Text('Add Education'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
