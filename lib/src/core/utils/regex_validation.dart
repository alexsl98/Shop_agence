abstract class RegExpUtil {
  // Nombres válidos
  static const nameRegExp = r'^[A-Za-z ÁÉÍÓÚÜÇáéíóúüç.-]+$';
  static const phoneRegExp = r'^[0-9 +*-]+$';
  // Identificaciones válidas
  static const idRegExp =
      r'^([0-9]{2})(0[1-9]|1[012])(0[1-9]|1[0-9]|2[0-9]|3[01])([0-9]{1})([0-9]{2})([0-9]{2})$';
  static const idRegExpJose =
      r'^d{2}((0[1-9])|10|11|12)((0[1-9])|([1-2][0-9])|30|31)([0-9]){5}$';

  // Fechas válidas
  static const dateRegExp =
      r'^(0[1-9]|1[0-9]|2[0-9]|3[01])[-/.](0[1-9]|1[012])[-/.](19[23456789][0-9]|20[0][12])$';

  // Correos electrónicos o nombres de usuario válidos
  static const emailOrUsernameRegExp =
      r'^[a-zA-Z0-9._%+-]+(@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})?$';

  // Username
  static const usernameRegExp = r'^[a-zA-Z][a-zA-Z0-9._]{2,19}$';

  // Correos electrónicos
  static const emailRegExp = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  // Contraseñas seguras
  static const passwordRegExp = r'^(?=.*[A-Z])(?=.*[a-z]).{8,}$';

  static const passwordMinLength = r'^.{8,}$';
  static const passwordHasUpperCase = r'[A-Z]';
  static const passwordHasLowerCase = r'[a-z]';
  static const passwordHasNumber = r'[0-9]';
  static const passwordHasSpecialChar = r'[!@#$%&*]';
  static const passwordNoLeadingTrailingSpaces = r'^\S.*\S$|^\S$';

  // Expresión regular completa para contraseña segura
  static const passwordStrongRegExp =
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%&*])\S.{6,}\S$';

  // ConfirmPassword
  static bool confirmPasswordMatch(String pass, String confirm) =>
      pass == confirm;
}
