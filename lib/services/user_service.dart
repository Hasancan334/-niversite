import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static String? _cache;

  static Future<String> getUserId() async {
    if (_cache != null) return _cache!;
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('user_id');
    if (id == null) {
      final r = Random.secure();
      id = 'u_${DateTime.now().millisecondsSinceEpoch}_${r.nextInt(1 << 32)}';
      await prefs.setString('user_id', id);
    }
    _cache = id;
    return id;
  }
}