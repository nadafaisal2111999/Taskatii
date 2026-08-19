import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var Task = Hive.box("taskati");
  var TaskControler = TextEditingController();
  var DescriptionControler = TextEditingController();
  var FormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
        centerTitle: true,
        backgroundColor: Color(0xff9061BF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: FormKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please Enter Task Title";
                  }
                  return null;
                },
                controller: TaskControler,
                decoration: InputDecoration(
                  hintText: "Enter Task Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please Enter Task Description";
                  }
                  return null;
                },
                controller: DescriptionControler,
                decoration: InputDecoration(
                  hintText: "Enter Task Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (FormKey.currentState!.validate()) {
                    var data = {
                      "task": TaskControler.text,
                      "Description": DescriptionControler.text,
                      "isDone": false,
                    };
                    Task.add(data);
                    Navigator.pop(context);
                  }
                },
                child: Text("Add Task"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff9061BF),
                  foregroundColor: Colors.white,
                  fixedSize: Size(MediaQuery.of(context).size.width, 30),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}