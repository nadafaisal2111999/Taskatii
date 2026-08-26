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
  // 1. فتح صندوق بيانات المستخدم
  var userBox = Hive.box("userBox");

  // تعريف المتغيرات اللي كان الخطأ بسببها
  late TextEditingController nameController;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    // جلب البيانات القديمة عند فتح الشاشة
    nameController = TextEditingController(text: userBox.get('name') ?? '');
    imagePath = userBox.get('image');
  }

  // 2. دالة فتح استوديو الموبايل واختيار الصورة
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Screen"),
        centerTitle: true,
        backgroundColor: const Color(0xff9061BF),
      ),
      body: Padding(
    padding: const EdgeInsets.all(20.0),
    child: SingleChildScrollView(
    child: Column(
    children: [
    const SizedBox(height: 20),

    // 1. صورة البروفايل المعروضة جوه دايرة مع آيكونة الكاميرا
    Stack(
    alignment: Alignment.bottomRight, // تحديد مكان زرار الكاميرا في أسفل يمين الصورة
    children: [
    CircleAvatar(
    radius: 65,
    backgroundColor: const Color(0xffDEB9FF),
    // لو في صورة اختارها بنعرضها، لو مفيش بنعرض آيكونة الشخص
    backgroundImage: imagePath != null
    ? FileImage(File(imagePath!)) as ImageProvider // لو في صورة اختارها بنعرضها
        : null, // لو مفيش بنعرض آيكونة الشخص
    child: imagePath == null
    ? const Icon(Icons.person, size: 70, color: Colors.white)
        : null,
    ),
    // زرار الكاميرا الصغير اللي لما بنضغط عليه ينادي دالة pickImage
    InkWell(
    onTap: pickImage,
    child: const CircleAvatar(
    radius: 18,
    backgroundColor: Color(0xff9061BF),
    child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
    ),
    ),
    ],
    ),

    const SizedBox(height: 30),

    // 2. خانة كتابة اسم المستخدم
    TextField(
    controller: nameController,
    decoration: InputDecoration(
    labelText: "User Name",
    hintText: "Enter your name",
    prefixIcon: const Icon(Icons.person, color: Color(0xff9061BF)),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    ),
    ),

    const SizedBox(height: 30),

    // 3. زرار حفظ البيانات في Hive
    ElevatedButton(
    onPressed: () {
    // حفظ البيانات
    userBox.put('name', nameController.text);
    userBox.put('image', imagePath);

    // إظهار رسالة نفيح بنجاح الحفظ
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
    content: Text("Profile Saved Successfully!"),
    backgroundColor: Colors.green,
    ),
    );

    Navigator.pop(context); // الرجوع للشاشة الرئيسية
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xff9061BF),
    foregroundColor: Colors.white,
    fixedSize: Size(MediaQuery.of(context).size.width, 45),
    ),
    child: const Text("Save Profile", style: TextStyle(fontSize: 16)),
    ),
    ],
    ),
    ),
    ),
    );
  }
}