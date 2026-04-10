import 'package:hive_flutter/hive_flutter.dart';

import 'hive_boxes.dart';

class LocalStorageService {
  Future<void>? _initialization;

  Future<void> initialize() {
    return _initialization ??= _initialize();
  }

  Future<void> _initialize() async {
    await Hive.initFlutter();
    await Future.wait<void>([
      Hive.openBox<dynamic>(HiveBoxes.settings),
      Hive.openBox<dynamic>(HiveBoxes.progression),
    ]);
  }

  Box<dynamic> get settingsBox => Hive.box<dynamic>(HiveBoxes.settings);
  Box<dynamic> get progressionBox => Hive.box<dynamic>(HiveBoxes.progression);
}
