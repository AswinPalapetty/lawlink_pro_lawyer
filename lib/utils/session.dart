import 'package:shared_preferences/shared_preferences.dart';

class SessionManagement {
  static Future<void> storeUserData(userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', userData['name']);
    await prefs.setString('email', userData['email']);
    await prefs.setString('userId', userData['userId']);
    await prefs.setString('phone', userData['phone']);
  }

  static Future<Map<String, String>> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String name = prefs.getString('name') ?? 'Aswin';
    final String email = prefs.getString('email') ?? '';
    final String userId = prefs.getString('userId') ?? '';
    final String phone = prefs.getString('phone') ?? '';
    return {'name': name, 'email': email, 'userId': userId, 'phone': phone};
  }

  static Future<void> clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('userId');
    await prefs.remove('phone');
  }
}