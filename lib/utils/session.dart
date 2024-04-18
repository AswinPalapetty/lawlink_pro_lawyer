import 'package:shared_preferences/shared_preferences.dart';

class SessionManagement {
  static Future<void> storeUserData(userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', userData['name'] ?? '');
    await prefs.setString('email', userData['email'] ?? '');
    await prefs.setString('userId', userData['userId'] ?? '');
    await prefs.setString('phone', userData['phone'] ?? '');
    await prefs.setString('registration', userData['registration'] ?? '');
    await prefs.setString('education', userData['education'] ?? '');
    await prefs.setString('callCharge', userData['callCharge'] ?? '');
    await prefs.setString('sittingCharge', userData['sittingCharge'] ?? '');
    await prefs.setString('location', userData['location'] ?? '');
    await prefs.setString('practiceAreas', userData['practiceAreas'] ?? '');
    await prefs.setString('experience', userData['experience'] ?? '');
    await prefs.setString('courts', userData['courts'] ?? '');
  }

  static Future<Map<String, String>> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String name = prefs.getString('name') ?? '';
    final String email = prefs.getString('email') ?? '';
    final String userId = prefs.getString('userId') ?? '';
    final String phone = prefs.getString('phone') ?? '';
    final String registration = prefs.getString('registration') ?? '';
    final String education = prefs.getString('education') ?? '';
    final String callCharge = prefs.getString('callCharge') ?? '';
    final String sittingCharge = prefs.getString('sittingCharge') ?? '';
    final String location = prefs.getString('location') ?? '';
    final String practiceAreas = prefs.getString('practiceAreas') ?? '';
    final String experience = prefs.getString('experience') ?? '';
    final String courts = prefs.getString('courts') ?? '';
    return {'name': name, 'email': email, 'userId': userId, 'phone': phone, 'registration': registration, 'education': education, 'callCharge': callCharge, 'sittingCharge': sittingCharge, 'location': location, 'practiceAreas': practiceAreas, 'experience': experience, 'courts' : courts};
  }

  static Future<void> clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('userId');
    await prefs.remove('phone');
    await prefs.remove('registration');
    await prefs.remove('education');
    await prefs.remove('callCharge');
    await prefs.remove('sittingCharge');
    await prefs.remove('location');
    await prefs.remove('practiceAreas');
    await prefs.remove('experience');
    await prefs.remove('courts');
  }
}