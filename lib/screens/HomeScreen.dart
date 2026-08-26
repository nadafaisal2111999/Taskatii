import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';

import '../main.dart';
import 'Add_Task.dart';
import 'DoneTaskes.dart';
import 'userScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var taskBox = Hive.box("taskati");
  var doneBox = Hive.box("DoneBox");

  String searchQuery = "";
  String selectedPriorityFilter = "All";

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    var userBox = Hive.box("userBox");
    String userName = userBox.get('name') ?? "User";
    String? imagePath = userBox.get('image');

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white24,
              backgroundImage: imagePath != null ? FileImage(File(imagePath)) : null,
              child: imagePath == null
                  ? const Icon(Icons.person, color: Colors.white, size: 20)
                  : null,
            ),
            const SizedBox(width: 10),
            Text(
              "Hello, $userName 👋",
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: "Done Tasks",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Donetaskes()),
              ).then((_) => setState(() {}));
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: "Profile",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Userscreen()),
              ).then((_) => setState(() {}));
            },
          ),
          IconButton(
            icon: Icon(
              themeNotifier.value == ThemeMode.light
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
            ),
            onPressed: () {
              themeNotifier.value = themeNotifier.value == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTask()),
          ).then((_) => setState(() {}));
        },
        backgroundColor: const Color(0xff6C5CE7),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Task", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 12),

            // 1. Progress Indicator Card
            ValueListenableBuilder(
              valueListenable: taskBox.listenable(),
              builder: (context, Box tBox, _) {
                return ValueListenableBuilder(
                  valueListenable: doneBox.listenable(),
                  builder: (context, Box dBox, _) {
                    int total = tBox.length + dBox.length;
                    double progress = total == 0 ? 0.0 : dBox.length / total;

                    return Card(
                      color: const Color(0xff6C5CE7),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Daily Completion Progress",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.white30,
                              color: Colors.greenAccent,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${(progress * 100).toInt()}% Completed (${dBox.length}/$total Tasks)",
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 12),

            // 2. Search Field
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search tasks...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),

            const SizedBox(height: 10),

            // 3. Priority Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'High', 'Medium', 'Low'].map((priority) {
                  bool isSelected = selectedPriorityFilter == priority;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(priority),
                      selected: isSelected,
                      selectedColor: const Color(0xff6C5CE7),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          selectedPriorityFilter = priority;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // 4. Tasks List with Swipe to Complete / Delete
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: taskBox.listenable(),
                builder: (context, Box box, _) {
                  if (box.isEmpty) {
                    return Center(
                      child: Lottie.asset(
                        'assets/Empty.json',
                        width: 250,
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: box.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      var currentTask = Map<String, dynamic>.from(box.getAt(index));

                      bool matchesSearch = searchQuery.isEmpty ||
                          currentTask["task"].toString().toLowerCase().contains(searchQuery) ||
                          currentTask["Description"].toString().toLowerCase().contains(searchQuery);

                      bool matchesPriority = selectedPriorityFilter == "All" ||
                          currentTask["priority"] == selectedPriorityFilter;

                      if (!matchesSearch || !matchesPriority) {
                        return const SizedBox.shrink();
                      }

                      String priority = currentTask["priority"] ?? "Medium";
                      Color priorityColor = _getPriorityColor(priority);

                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.green,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          child: const Icon(Icons.check, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            currentTask["isDone"] = true;
                            doneBox.add(currentTask);
                            taskBox.deleteAt(index);
                          } else {
                            taskBox.deleteAt(index);
                          }
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(color: priorityColor, width: 6),
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: Checkbox(
                                value: currentTask["isDone"] ?? false,
                                activeColor: const Color(0xff6C5CE7),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                onChanged: (value) {
                                  setState(() {
                                    currentTask["isDone"] = true;
                                    doneBox.add(currentTask);
                                    taskBox.deleteAt(index);
                                  });
                                },
                              ),
                              title: Text(
                                currentTask["task"] ?? "",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(currentTask["Description"] ?? ""),
                                  const SizedBox(height: 6),
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      if (currentTask["date"] != null) ...[
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text(
                                              currentTask["date"],
                                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ],
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: priorityColor.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          priority,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: priorityColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
                                    ).then((_) => setState(() {}));
                                  } else if (value == 'Delete') {
                                    taskBox.deleteAt(index);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(value: 'Edit', child: Text('Edit')),
                                  const PopupMenuItem(value: 'Delete', child: Text('Delete')),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}