import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';


final initialThemeProvider = FutureProvider<bool>((ref) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    print('Tema inicial cargado: ${isDarkMode ? 'Oscuro' : 'Claro'}');
    return isDarkMode;
  } catch (e) {
    print(' Error cargando tema inicial: $e');
    return false;
  }
});

// StateNotifier para manejar cambios de tema
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  final initialTheme = ref.watch(initialThemeProvider).value ?? false;
  return ThemeNotifier(initialTheme);
});

class ThemeNotifier extends StateNotifier<bool> {
  static const String _themeKey = 'isDarkMode';

  ThemeNotifier(bool initialTheme) : super(initialTheme);

  // Guardar el tema
  Future<void> _saveTheme(bool isDarkMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, isDarkMode);
      print('Tema guardado: ${isDarkMode ? 'Oscuro' : 'Claro'}');
    } catch (e) {
      print('Error guardando tema: $e');
    }
  }

  // Cambiar entre tema claro y oscuro
  void toggleTheme() {
    final newTheme = !state;
    print('Cambiando tema: ${newTheme ? 'Oscuro' : 'Claro'}');
    state = newTheme;
    _saveTheme(newTheme);
  }

  // Establecer tema oscuro
  void setDarkTheme() {
    print('Estableciendo tema: Oscuro');
    state = true;
    _saveTheme(true);
  }

  // Establecer tema claro
  void setLightTheme() {
    print('Estableciendo tema: Claro');
    state = false;
    _saveTheme(false);
  }

  // Establecer tema específico
  void setTheme(bool isDarkMode) {
    print('Estableciendo tema: ${isDarkMode ? 'Oscuro' : 'Claro'}');
    state = isDarkMode;
    _saveTheme(isDarkMode);
  }
}
