# Security Core

This folder contains the security framework for the InstaPay Clone app.

## Files

- `security_policy.dart`
  - App-wide policy constants and hardening thresholds.
  - Includes:
    - `maxInputLength = 256`
    - `minPasswordLength = 8`
    - `pinLength = 6`
    - `biometricsRequiredForHighRisk = true`
    - `maxFailedAttempts = 5`
    - `highRiskTransactionThreshold = 5000.0`
    - CSP/CORS constants and blacklist-check helper.

- `security_utils.dart`
  - Input validation and security checks.
  - Includes:
    - `sanitizeInput(String)`
    - `isValidAmount(String)`
    - `isValidPhoneNumber(String)`
    - `isHighRiskTransfer(double, {bool isUrgent = false})`
    - `requireAdditionalChallenge(double, {bool isUrgent = false})`

- `secure_storage_service.dart`
  - Secure token/pin storage via `flutter_secure_storage`.
  - Includes:
    - JWT `saveToken`, `getToken`, `deleteToken`
    - token expiry `saveTokenExpiry`, `getTokenExpiry`
    - `saveTokenWithExpiry`, `getTokenIfValid`
    - PIN save/get/delete
    - `clearAll`

## Integration

- `AppSession` uses `SecureStorageService` and policy settings for
  login session, token expiry/rotation, logout, and auth state.
- Send flow uses `SecurityUtils` to validate user input and
  enforce high-risk multi-factor decisions.
- `pin_entry_view.dart` and `biometric_view.dart` enforce
  MFA support according to `SecurityPolicy` settings.

## Notes

- Analyzer is clean for this security module.
- Existing app warnings (`withOpacity` deprecations, async BuildContext, etc.) remain separate to existing app UX.
