class Validators {
  static String? requiredField(String? v, {String message = 'هذا الحقل مطلوب'}) {
    if (v == null || v.trim().isEmpty) return message;
    return null;
  }

  static String? email(String? v) {
    final req = requiredField(v);
    if (req != null) return req;
    final value = v!.trim();
    final reg = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!reg.hasMatch(value)) return 'البريد الإلكتروني غير صحيح';
    return null;
  }

  static String? password(String? v) {
    final req = requiredField(v);
    if (req != null) return req;
    if (v!.trim().length < 8) return 'كلمة المرور يجب ألا تقل عن 8 أحرف';
    return null;
  }

  static String? confirmPassword(String? v, String original) {
    final req = requiredField(v);
    if (req != null) return req;
    if (v!.trim() != original.trim()) return 'كلمتا المرور غير متطابقتين';
    return null;
  }

  static String? otp(String? v, {int length = 6}) {
    final req = requiredField(v);
    if (req != null) return req;
    final value = v!.trim();
    final reg = RegExp(r'^[0-9]+$');
    if (!reg.hasMatch(value) || value.length != length) {
      return 'رمز التحقق غير صحيح';
    }
    return null;
  }
}
