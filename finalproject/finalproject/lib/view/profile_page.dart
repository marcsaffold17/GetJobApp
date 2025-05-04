import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  const ProfilePage({super.key, required this.username});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

  // Load profile data (bio, image, work experience, education)
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bio = prefs.getString('bio') ?? '';
      String? imagePath = prefs.getString('profileImage');
      if (imagePath != null && File(imagePath).existsSync()) {
        _image = File(imagePath);
      }
      _bioController.text = _bio;
      _workExperience = prefs.getStringList('workExperience') ?? [];
      _education = prefs.getStringList('education') ?? [];
    });
  }

  // Save bio and other data to SharedPreferences
  Future<void> _saveBio() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bio = _bioController.text;
    });
    await prefs.setString('bio', _bio);
  }

  // Pick image from gallery
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

  // Show dialog to add work experience
  void _addWorkExperience() async {
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
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Show dialog to add education
  void _addEducation() async {
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
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Save work experience list to SharedPreferences
  Future<void> _saveWorkExperience() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('workExperience', _workExperience);
  }

  // Save education list to SharedPreferences
  Future<void> _saveEducation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('education', _education);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 238, 227),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Workout Profile",
          style: TextStyle(color: Color.fromARGB(255, 244, 238, 227)),
        ),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 244, 238, 227)),
        backgroundColor: Color.fromARGB(255, 20, 50, 31),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
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
              widget.username,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'About Me',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _bioController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 229, 221, 212),
                filled: true,
                hintText: 'Write something about yourself...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 20, 50, 31),
                    width: 2,
                  ),
                ),
              ),
              maxLines: 3,
              onChanged: (value) => _saveBio(),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Work Experience',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _workExperience.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(_workExperience[index]));
              },
            ),
            ElevatedButton(
              onPressed: _addWorkExperience,
              child: const Text('Add Work Experience'),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Education',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _education.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(_education[index]));
              },
            ),
            ElevatedButton(
              onPressed: _addEducation,
              child: const Text('Add Education'),
            ),
          ],
        ),
      ),
    );
  }
}
