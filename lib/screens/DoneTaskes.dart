import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
        title: Text("Done Taskes"),
        centerTitle: true,
        backgroundColor: Color(0xff9061BF),
      ),
      body: (DoneBox.isEmpty)
          ? Center(
        child: Lottie.asset(
          'assets/Empty.json',
          width: 350,
          height: 350,
          fit: BoxFit.fill,
        ),
      )
          : ListView.builder(
        itemCount: DoneBox.length,
        itemBuilder: (BuildContext context, int index) {
          var currentTask = Map<String, dynamic>.from(DoneBox.getAt(index));
          return Card(
            child: ListTile(
              title: Text(currentTask["task"]),
              subtitle: Text(currentTask["Description"]),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  DoneBox.deleteAt(index);
                  setState(() {});
                },
              ),
              leading: Checkbox(
                value: currentTask["isDone"] ?? false,
                onChanged: (value) {
                  setState(() {
                    currentTask["isDone"] = value!;
                    taskBox.add(currentTask);
                    DoneBox.deleteAt(index);
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