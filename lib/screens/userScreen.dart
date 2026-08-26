import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class Userscreen extends StatefulWidget {
  const Userscreen({super.key});

  @override
  State<Userscreen> createState() => _UserscreenState();
}

class _UserscreenState extends State<Userscreen> {
  var userBox = Hive.box("userBox");
  var taskBox = Hive.box("taskati");
  var doneBox = Hive.box("DoneBox");

  late TextEditingController nameController;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: userBox.get('name') ?? '');
    imagePath = userBox.get('image');
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int pendingCount = taskBox.length;
    int completedCount = doneBox.length;
    int totalCount = pendingCount + completedCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile & Analytics"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: const Color(0xff6C5CE7).withOpacity(0.15),
                  backgroundImage: imagePath != null ? FileImage(File(imagePath!)) : null,
                  child: imagePath == null
                      ? const Icon(Icons.person, size: 65, color: Color(0xff6C5CE7))
                      : null,
                ),
                InkWell(
                  onTap: pickImage,
                  child: const CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xff6C5CE7),
                    child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // User Analytics Dashboard
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _buildStatCard("Total Tasks", "$totalCount", const Color(0xff6C5CE7))),
                const SizedBox(width: 8),
                Expanded(child: _buildStatCard("Completed", "$completedCount", Colors.green)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatCard("Pending", "$pendingCount", Colors.orange)),
              ],
            ),

            const SizedBox(height: 30),

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "User Name",
                prefixIcon: const Icon(Icons.person, color: Color(0xff6C5CE7)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  userBox.put('name', nameController.text);
                  userBox.put('image', imagePath);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Profile Saved Successfully!"),
                      backgroundColor: Colors.green,
                    ),
                  );

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6C5CE7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Save Profile", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}