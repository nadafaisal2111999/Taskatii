import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

import 'Add_Task.dart';
import 'DoneTaskes.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  var taskBox = Hive.box("taskati");
  var DoneBox = Hive.box("DoneBox");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Taskatii"),
        centerTitle: true,
        backgroundColor: Color(0xff9061BF),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: ((context) => Donetaskes())),
              ).then((value) {
                setState(() {});
              });
            },
            icon: Icon(Icons.check_box),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTask()),
          ).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Task Add Successfully")),
            );
            setState(() {});
          });
        },
        backgroundColor: Color(0xffDEB9FF),
        child: Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      body: (taskBox.isEmpty)
          ? Center(
        child: Lottie.asset(
          'assets/Empty.json',
          width: 350,
          height: 350,
          fit: BoxFit.fill,
        ),
      )
          : ListView.builder(
        itemCount: taskBox.length,
        itemBuilder: (BuildContext context, int index) {
          var currentTask = Map<String, dynamic>.from(taskBox.getAt(index));
          return Card(
            child: ListTile(
              title: Text(currentTask["task"]),
              subtitle: Text(currentTask["Description"]),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  taskBox.deleteAt(index);
                  setState(() {});
                },
              ),
              leading: Checkbox(
                value: currentTask["isDone"] ?? false,
                onChanged: (value) {
                  setState(() {
                    currentTask["isDone"] = value!;
                    DoneBox.add(currentTask);
                    taskBox.deleteAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}