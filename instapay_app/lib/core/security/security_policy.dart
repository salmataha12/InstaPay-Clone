class SecurityPolicy {
  static const int maxInputLength = 256;
  static const int minPasswordLength = 8;
  static const int pinLength = 6;
  static const bool biometricsRequiredForHighRisk = true;
  static const int maxFailedAttempts = 5;

  static const double highRiskTransactionThreshold = 5000.0; // EGP

  // For mobile, these are app-derived; for web the web layer must provide CSP/CORS.
  static const String contentSecurityPolicy =
      "default-src 'self'; script-src 'none';";
  static const String corsPolicy =
      "*"; // fallback; refine in real server environment

  static bool isBlacklistedChars(String text) {
    return text.contains('<') ||
        text.contains('>') ||
        text.contains('javascript:');
  }
}
