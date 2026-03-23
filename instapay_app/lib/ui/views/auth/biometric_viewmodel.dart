import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricViewModel extends ChangeNotifier {
  final LocalAuthentication auth = LocalAuthentication();

  bool isAuthenticating = false;
  bool isBiometricAvailable = false;

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

  Future<bool> authenticate() async {
    try {
      isAuthenticating = true;
      notifyListeners();

      /// If NOT available → allow fallback (for emulator)
      if (!isBiometricAvailable) {
        isAuthenticating = false;
        notifyListeners();
        return true; // allow access (fallback)
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
      notifyListeners();
      return false;
    }
  }
}