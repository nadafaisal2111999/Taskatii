import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';

class Donetaskes extends StatefulWidget {
  const Donetaskes({super.key});

  @override
  State<Donetaskes> createState() => _DonetaskesState();
}

class _DonetaskesState extends State<Donetaskes> {
  var DoneBox = Hive.box("DoneBox");
  var taskBox = Hive.box("taskati");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Done Tasks"),
        centerTitle: true,
        actions: [
          ValueListenableBuilder(
            valueListenable: DoneBox.listenable(),
            builder: (context, Box box, _) {
              if (box.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_sweep),
                tooltip: "Clear All",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Clear All Tasks"),
                      content: const Text("Are you sure you want to delete all completed tasks?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            DoneBox.clear();
                            Navigator.pop(context);
                          },
                          child: const Text("Delete", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: DoneBox.listenable(),
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
            padding: const EdgeInsets.all(16),
            itemCount: box.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              var currentTask = Map<String, dynamic>.from(box.getAt(index));

              return Card(
                elevation: 1.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading: Checkbox(
                    value: currentTask["isDone"] ?? true,
                    activeColor: const Color(0xff6C5CE7),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    onChanged: (value) {
                      setState(() {
                        currentTask["isDone"] = false;
                        taskBox.add(currentTask);
                        DoneBox.deleteAt(index);
                      });
                    },
                  ),
                  title: Text(
                    currentTask["task"] ?? "",
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    currentTask["Description"] ?? "",
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () {
                      DoneBox.deleteAt(index);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}