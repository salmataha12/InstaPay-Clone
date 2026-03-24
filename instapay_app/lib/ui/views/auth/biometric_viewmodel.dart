import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../../../core/services/secure_storage_service.dart';

class BiometricViewModel extends ChangeNotifier {
  final LocalAuthentication auth = LocalAuthentication();

  bool isAuthenticating = false;
  bool isBiometricAvailable = false;
  
  String pinInput = "";
  String? errorMsg;

  Future<void> checkBiometricAvailability() async {
    try {
      final isSupported = await auth.isDeviceSupported();
      final available = await auth.getAvailableBiometrics();

      isBiometricAvailable = isSupported && available.isNotEmpty;
      notifyListeners();
    } catch (e) {
      isBiometricAvailable = false;
      notifyListeners();
    }
  }

  void updatePin(String value) {
    pinInput = value.replaceAll(RegExp(r'[^\d]'), '');
    errorMsg = null;
    notifyListeners();
  }

  Future<bool> authenticate() async {
    try {
      isAuthenticating = true;
      errorMsg = null;
      notifyListeners();

      /// If NOT available → enforce PIN fallback
      if (!isBiometricAvailable) {
        return await _verifyPin();
      }

      final didAuthenticate = await auth.authenticate(
        localizedReason: 'Authenticate to continue',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );

      isAuthenticating = false;
      notifyListeners();

      return didAuthenticate;
    } catch (e) {
      isAuthenticating = false;
      errorMsg = "Biometric error occurred";
      notifyListeners();
      return false;
    }
  }

  Future<bool> _verifyPin() async {
    final savedPin = await SecureStorageService.getPin();
    isAuthenticating = false;
    
    if (savedPin != null && savedPin == pinInput && pinInput.length == 6) {
      notifyListeners();
      return true;
    } else {
      errorMsg = "Invalid PIN";
      notifyListeners();
      return false;
    }
  }
}