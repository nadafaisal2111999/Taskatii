import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pro9/screens/HomeScreen.dart';

// 1. تعريف المتغير المسؤول عن التبديل بين الثيمات (خارج الكلاس)
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); /*سطر نحطو عشان نستخدم اللوكل بيز*/
  await Hive.initFlutter(); /* تشغيل مكتبة Hive */
  await Hive.openBox("taskati"); // فتح صندوق البيانات
  await Hive.openBox("DoneBox");
  await Hive.openBox("userBox");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. استخدام ValueListenableBuilder لمراقبة التغيير في الثيم
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          home: const Homescreen(),

          // 3. ربط وضع الثيم الحالي بالمتغير
          themeMode: currentMode,

          // الثيم الفاتح العادي
          theme: ThemeData.light(),

          // الثيم الداكن (Dark Mode)
          darkTheme: ThemeData.dark(),
        );
      },
    );
  }
}