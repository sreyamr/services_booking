class SignupValidator {
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return "Name is required";
    if (value.trim().length < 3) return "Name must be at least 3 characters";
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return "Email is required";
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value.trim())) return "Invalid email format";
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return "Confirm your password";
    if (value != password) return "Passwords do not match";
    return null;
  }
}