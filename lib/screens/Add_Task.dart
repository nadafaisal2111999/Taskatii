import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key,  this.task,  this.Description,  this.index});

  final String? task;
  final String ?Description;
  final int? index;

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var Task = Hive.box("taskati");
late TextEditingController TaskControler;
late TextEditingController DescriptionControler;
  var FormKey = GlobalKey<FormState>(); // مفتاح النموذج للتحقق من صحة البيانات

  //important

  @override
  void initState() { //داله initState() هي دالة في Flutter تُستخدم لتهيئة الحالة الأولية للعنصر (widget) قبل أن يتم عرضه على الشاشة. يتم استدعاؤها مرة واحدة عند إنشاء العنصر، وتُستخدم عادةً لإعداد المتغيرات، أو تهيئة عناصر التحكم، أو تنفيذ أي إعدادات أولية أخرى.
    super.initState();
    TaskControler = TextEditingController(text: widget.task ?? ""); //يمرر قيمة النص الافتراضية إلى عنصر التحكم في النص (TextEditingController) بناءً على القيمة المرسلة من العنصر (widget). إذا كانت القيمة المرسلة غير موجودة (null)، سيتم استخدام سلسلة فارغة كقيمة افتراضية.
    DescriptionControler = TextEditingController(text: widget.Description ?? "");
  }
  @override
  void dispose() {
    TaskControler.dispose();
    DescriptionControler.dispose();
    super.dispose();
  }



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
                  // 1. التأكد إن الخانات مش فاضية ومكتوب فيها بيانات صحيحة
                  if (FormKey.currentState!.validate()) {

                    // 2. تجميع البيانات الجديدة من الخانات جوه Map
                    var data = {
                      "task": TaskControler.text,
                      "Description": DescriptionControler.text,
                      "isDone": false,
                    };

                    // 3. اختبار حالة الشاشة: هل مبعوث لها index؟
                    if (widget.index != null) {
                      // إذا كان الـ index موجود، يبقى العملية تعديل (نستبدل البيانات القديمة في نفس المكان)
                      Task.putAt(widget.index!, data);
                    } else {
                      // إذا كان الـ index بـ null، يبقى العملية إضافة عنصر جديد للقائمة
                      Task.add(data);
                    }

                    // 4. إغلاق شاشة الإضافة/التعديل والرجوع للشاشة الرئيسية
                    Navigator.pop(context);
                  }
                },
                child: widget.index != null?Text("Edit Task"):Text("Add Task"),
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