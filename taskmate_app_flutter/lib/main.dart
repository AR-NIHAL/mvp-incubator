import 'package:flutter/material.dart';
import 'package:taskmate_app_flutter/features/tasks/ui/task_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.indigo);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "TaskMate",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme
      ),

       darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),

      themeMode: ThemeMode.system,
      home: TaskHomePage(
      ),

    );
  }
}
