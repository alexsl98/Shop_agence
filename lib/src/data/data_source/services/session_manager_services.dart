import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _loginTimeKey = 'last_login_timestamp';
  static const String _userIdKey = 'current_user_id';
  static const int _sessionDurationHours = 2;

  // Guardar timestamp del login
  static Future<void> saveLoginTimestamp(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await prefs.setString(_loginTimeKey, now.toIso8601String());
    await prefs.setString(_userIdKey, userId);
  }

  // Verificar si la sesión es válida (menos de 2 horas)
  static Future<bool> isSessionValid() async {
    final prefs = await SharedPreferences.getInstance();
    final loginTimeStr = prefs.getString(_loginTimeKey);
    final userId = prefs.getString(_userIdKey);

    if (loginTimeStr == null || userId == null) {
      return false;
    }

    final loginTime = DateTime.parse(loginTimeStr);
    final now = DateTime.now();
    final difference = now.difference(loginTime);

    // Verificar si han pasado menos de 2 horas
    return difference.inHours < _sessionDurationHours;
  }

  // Obtener tiempo restante de sesión
  static Future<Duration?> getRemainingSessionTime() async {
    final prefs = await SharedPreferences.getInstance();
    final loginTimeStr = prefs.getString(_loginTimeKey);

    if (loginTimeStr == null) {
      return null;
    }

    final loginTime = DateTime.parse(loginTimeStr);
    final now = DateTime.now();
    final difference = now.difference(loginTime);
    final totalSessionDuration = Duration(hours: _sessionDurationHours);

    if (difference < totalSessionDuration) {
      return totalSessionDuration - difference;
    }
    return Duration.zero;
  }

  // Cerrar sesión (limpiar datos)
  static Future<void> clearSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginTimeKey);
    await prefs.remove(_userIdKey);
  }

  // Verificar y actualizar sesión
  static Future<bool> checkAndUpdateSession() async {
    if (await isSessionValid()) {
      return true;
    } else {
      await clearSessionData();
      return false;
    }
  }
}
