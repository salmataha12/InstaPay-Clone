import 'security_policy.dart';

class SecurityUtils {
  static String sanitizeInput(String input) {
    var cleaned = input.trim();
    if (cleaned.length > SecurityPolicy.maxInputLength) {
      cleaned = cleaned.substring(0, SecurityPolicy.maxInputLength);
    }
    cleaned = cleaned.replaceAll(RegExp(r'[<>]'), '');
    cleaned = cleaned.replaceAll('javascript:', '');
    return cleaned;
  }

  static bool isValidAmount(String value) {
    if (value.isEmpty) return false;
    final num? parsed = num.tryParse(value);
    return parsed != null && parsed > 0 && parsed <= 100000;
  }

  static bool isValidPhoneNumber(String value) {
    if (value.isEmpty) return false;
    final cleaned = value.replaceAll(RegExp(r'\s+|-'), '');
    final phoneRegex = RegExp(r'^[0-9]{6,15}\$');
    return phoneRegex.hasMatch(cleaned);
  }

  static bool isHighRiskTransfer(double amount, {bool isUrgent = false}) {
    if (isUrgent) return true;
    return amount >= SecurityPolicy.highRiskTransactionThreshold;
  }

  static bool requireAdditionalChallenge(
    double amount, {
    bool isUrgent = false,
  }) {
    return isHighRiskTransfer(amount, isUrgent: isUrgent);
  }

  static bool isHighRisk(double amount) {
    return isHighRiskTransfer(amount);
  }
}
