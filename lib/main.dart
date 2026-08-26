import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/HomeScreen.dart';

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("taskati");
  await Hive.openBox("DoneBox");
  await Hive.openBox("userBox");
  runApp(const TaskatiiApp());
}

class TaskatiiApp extends StatelessWidget {
  const TaskatiiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'Taskatii',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,

          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: const Color(0xff6C5CE7),
            scaffoldBackgroundColor: const Color(0xffF8F9FA),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xff6C5CE7),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),

          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: const Color(0xff6C5CE7),
            scaffoldBackgroundColor: const Color(0xff121212),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xff1F1F1F),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),

          home: const HomeScreen(),
        );
      },
    );
  }
}