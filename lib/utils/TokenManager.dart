import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const _key = 'auth_token';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
  }

  // In your TokenManager or equivalent
static Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  print('Retrieved token: ${token != null ? '*****' + token.substring(token.length - 5) : 'null'}');
  return token;
}
static Future<int?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('user_id');
}


  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_key);
  }
}