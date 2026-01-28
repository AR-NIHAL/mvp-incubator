import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/tasks/ui/task_home_page.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settings_box');
  runApp(const TaskMateApp());
}
class TaskMateApp extends StatelessWidget {
  const TaskMateApp({super.key});
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.indigo);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskMate',
      theme: ThemeData(useMaterial3: true, colorScheme: colorScheme),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const TaskHomePage(),
    );
  }
}