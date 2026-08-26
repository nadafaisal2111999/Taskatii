import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key, this.task, this.Description, this.index});

  final String? task;
  final String? Description;
  final int? index;

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var Task = Hive.box("taskati");
  late TextEditingController TaskControler;
  late TextEditingController DescriptionControler;
  late TextEditingController DateControler;

  String selectedPriority = "Medium";
  var FormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    TaskControler = TextEditingController(text: widget.task ?? "");
    DescriptionControler = TextEditingController(text: widget.Description ?? "");
    DateControler = TextEditingController(
      text: DateFormat('dd MMM, yyyy').format(DateTime.now()),
    );

    if (widget.index != null) {
      var currentTask = Task.getAt(widget.index!);
      selectedPriority = currentTask['priority'] ?? "Medium";
    }
  }

  @override
  void dispose() {
    TaskControler.dispose();
    DescriptionControler.dispose();
    DateControler.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        DateControler.text = DateFormat('dd MMM, yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.index != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Task" : "Add Task"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: FormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: TaskControler,
                validator: (value) => value!.isEmpty ? "Please enter task title" : null,
                decoration: InputDecoration(
                  labelText: "Task Title",
                  prefixIcon: const Icon(Icons.title, color: Color(0xff6C5CE7)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: DescriptionControler,
                maxLines: 3,
                validator: (value) => value!.isEmpty ? "Please enter task description" : null,
                decoration: InputDecoration(
                  labelText: "Description",
                  prefixIcon: const Icon(Icons.description, color: Color(0xff6C5CE7)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: DateControler,
                readOnly: true,
                onTap: _selectDate,
                decoration: InputDecoration(
                  labelText: "Task Date",
                  prefixIcon: const Icon(Icons.calendar_today, color: Color(0xff6C5CE7)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: selectedPriority,
                decoration: InputDecoration(
                  labelText: "Task Priority",
                  prefixIcon: const Icon(Icons.flag, color: Color(0xff6C5CE7)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: ['High', 'Medium', 'Low'].map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedPriority = val!;
                  });
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (FormKey.currentState!.validate()) {
                      var data = {
                        "task": TaskControler.text,
                        "Description": DescriptionControler.text,
                        "date": DateControler.text,
                        "priority": selectedPriority,
                        "isDone": false,
                      };

                      if (isEditing) {
                        Task.putAt(widget.index!, data);
                      } else {
                        Task.add(data);
                      }

                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff6C5CE7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    isEditing ? "Edit Task" : "Add Task",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}