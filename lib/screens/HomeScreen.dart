import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart'; // لوتي مكتبة للرسوم المتحركة
import 'package:pro9/screens/userScreen.dart';

import '../main.dart';
import 'Add_Task.dart';
import 'DoneTaskes.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState(); // إنشاء حالة للشاشة الرئيسية
}

class _HomescreenState extends State<Homescreen> {
  var taskBox = Hive.box("taskati");
  var DoneBox = Hive.box("DoneBox");
  String searchQuery = ""; // نص البحث

  @override
  Widget build(BuildContext context) {
    // 1. فتح صندوق المستخدم
    var userBox = Hive.box("userBox");

// 2. قراءة الاسم والصورة المحفوظين (مع وضع قيم افتراضية لو مش محفوظين)
    String userName = userBox.get('name') ?? "User";
    String? imagePath = userBox.get('image');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff9061BF),
        centerTitle: false,

        // عرض صورة البروفايل واسم المستخدم
        title: Row(
          children: [
            // 1. صورة البروفايل
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xffDEB9FF),
              backgroundImage: imagePath != null ? FileImage(File(imagePath)) as ImageProvider : null,
              child: imagePath == null ? const Icon(Icons.person, color: Colors.white, size: 18) : null,
            ),
            const SizedBox(width: 8),

            // 2. اسم المستخدم (أو كلمة Taskatii لو لسه مفيش اسم)
            Text(
              userName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        // الأزرار الحالية (Done Tasks, Profile Screen, Dark Mode)
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: ((context) => const Donetaskes())),
              ).then((value) {
                setState(() {});
              });
            },
            icon: const Icon(Icons.check_box),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: ((context) => const Userscreen())),
              ).then((value) {
                setState(() {});
              });
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              // التبديل بين الـ Dark والـ Light
              if (themeNotifier.value == ThemeMode.light) {
                themeNotifier.value = ThemeMode.dark;
              } else {
                themeNotifier.value = ThemeMode.light;
              }
            },
            icon: Icon(
              themeNotifier.value == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTask()),
          ).then((value) {
            ScaffoldMessenger.of(context).showSnackBar( // عرض رسالة عند العودة من شاشة إضافة المهمة
              const SnackBar(
                content: Text("Task Add Successfully", style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.green,
              ),
            );
            setState(() {}); // إعادة بناء الشاشة الرئيسية بعد إضافة المهمة
          });
        },
        backgroundColor: const Color(0xffDEB9FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // مربع البحث
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase(); // تحديث كلمة البحث عند الكتابة
                });
              },
              decoration: InputDecoration(
                hintText: "Search tasks...",
                prefixIcon: const Icon(Icons.search, color: Color(0xff9061BF)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          // عرض القائمة أو الأنيميشن داخل Expanded
          Expanded(
            child: (taskBox.isEmpty)
                ? Center(
              child: Lottie.asset(
                'assets/Empty.json',
                width: 350,
                height: 350,
                fit: BoxFit.fill,
              ), // عرض الرسوم المتحركة عند عدم وجود مهام
            )
                : ListView.builder( // عرض قائمة المهام عند وجود مهام
              itemCount: taskBox.length, // عدد المهام في الصندوق
              itemBuilder: (BuildContext context, int index) { // بناء كل عنصر في القائمة
                var currentTask = Map<String, dynamic>.from(taskBox.getAt(index));

                // تصفية العناصر حسب البحث
                if (searchQuery.isNotEmpty &&
                    !currentTask["task"].toString().toLowerCase().contains(searchQuery) &&
                    !currentTask["Description"].toString().toLowerCase().contains(searchQuery)) {
                  return const SizedBox.shrink();
                }

                return Card(
                  child: ListTile(
                    title: Text(currentTask["task"]),
                    subtitle: Text(currentTask["Description"]),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTask(
                                task: currentTask['task'],
                                Description: currentTask['Description'],
                                index: index,
                              ),
                            ),
                          ).then((value) {
                            setState(() {});
                          });
                        } else if (value == 'Delete') {
                          taskBox.deleteAt(index);
                          setState(() {});
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(value: 'Edit', child: Text('Edit')),
                        const PopupMenuItem<String>(value: 'Delete', child: Text('Delete')),
                      ],
                    ),
                    leading: Checkbox(
                      value: currentTask["isDone"] ?? false,
                      onChanged: (value) {
                        setState(() {
                          currentTask["isDone"] = value!;
                          DoneBox.add(currentTask); // إضافة المهمة إلى صندوق المهام المكتملة
                          taskBox.deleteAt(index); // حذف المهمة من صندوق المهام
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}