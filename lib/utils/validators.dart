/// Form validators shared by the auth and listing forms.
/// Each one returns an error message, or null when the value is valid.
class Validators {
  Validators._();

  static final RegExp _email = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
  static final RegExp _phone = RegExp(r'^0?5\d{9}$');

  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!_email.hasMatch(value.trim())) return 'Please enter a valid email';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  /// Phone is optional on sign up, but if given it must look like 05xx xxx xx xx.
  static String? optionalPhone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final digits = value.replaceAll(RegExp(r'\s'), '');
    if (!_phone.hasMatch(digits)) return 'Enter a phone like 05xx xxx xx xx';
    return null;
  }

  static String? title(String? value) {
    final error = required(value, 'Title');
    if (error != null) return error;
    if (value!.trim().length < 3) return 'Title must be at least 3 characters';
    return null;
  }

  static String? price(String? value) {
    final error = required(value, 'Price');
    if (error != null) return error;
    final parsed = int.tryParse(value!.trim());
    if (parsed == null) return 'Price must be a whole number';
    if (parsed <= 0) return 'Price must be greater than 0';
    if (parsed > 1000000) return 'Price is too high';
    return null;
  }
}
