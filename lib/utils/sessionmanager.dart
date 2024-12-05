import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String KEY_USER_ID = 'user_id';
  static const String KEY_USER_TYPE = 'user_type';
  static const String KEY_USER_NAME = 'user_name';
  static const String KEY_USER_EMAIL = 'user_email';

  // Get current logged in user details
  static Future<Map<String, String?>> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'user_id': prefs.getString(KEY_USER_ID),
      'user_type': prefs.getString(KEY_USER_TYPE),
      'user_name': prefs.getString(KEY_USER_NAME),
      'user_email': prefs.getString(KEY_USER_EMAIL),
    };
  }

  // Save user session after successful login/signup
  static Future<void> saveUserSession(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_USER_ID, user['id']);
    await prefs.setString(KEY_USER_TYPE, user['user_type']);
    await prefs.setString(KEY_USER_NAME, user['name']);
    await prefs.setString(KEY_USER_EMAIL, user['email']);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_USER_ID) != null;
  }

  // Logout user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

