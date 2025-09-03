class Validators {
  // Regex
  static final RegExp _usernameReg = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
  static final RegExp _passwordReg =
      RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');
  static final RegExp _emailReg =
      RegExp(r'^[\w\.-]+@([\w-]+\.)+[a-zA-Z]{2,4}$');

  /// Returns an error message if invalid, otherwise null

  static String? username(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Username is required';
    if (!_usernameReg.hasMatch(v)) {
      return 'Username 3–20 chars, letters/numbers/_ only';
    }
    return null;
  }

  static String? password(String? value) {
    final v = (value ?? '');
    if (v.isEmpty) return 'Password is required';
    if (!_passwordReg.hasMatch(v)) {
      return 'Password ≥8 chars, upper, lower, number, special';
    }
    return null;
  }

  static String? confirmPassword(String? pass, String? confirm) {
    if ((confirm ?? '').isEmpty) return 'Confirm password is required';
    if (pass != confirm) return 'Passwords do not match';
    return null;
  }

  static String? email(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Email is required';
    if (!_emailReg.hasMatch(v)) return 'Invalid email format';
    return null;
  }

  static String? fullName(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Full name is required';
    if (v.length < 3) return 'Full name is too short';
    return null;
  }
}
