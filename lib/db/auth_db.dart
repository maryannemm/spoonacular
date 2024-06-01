import 'package:hive_flutter/hive_flutter.dart';

class AuthDB {
  static const String _authBox = 'authBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_authBox);
  }

  static Box<dynamic> get box => Hive.box(_authBox);
}
