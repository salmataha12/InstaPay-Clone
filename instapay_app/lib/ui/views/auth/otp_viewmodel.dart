import 'dart:async';
import 'package:flutter/material.dart';

class OtpViewModel extends ChangeNotifier {
  String otp = "";
  int secondsRemaining = 60;
  bool canResend = false;
  bool isLoading = false;

  Timer? _timer;

  OtpViewModel() {
    startTimer();
  }

  /// Start OTP expiry timer
  void startTimer() {
    secondsRemaining = 60;
    canResend = false;

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
      } else {
        canResend = true;
        timer.cancel();
      }
      notifyListeners();
    });
  }

  /// Update OTP input
  void updateOtp(String value) {
    otp = value;
  }

  /// Validate OTP
  bool validate() {
    return otp.length == 6;
  }

  /// Simulate verification (backend)
  Future<bool> verifyOtp() async {
    if (!validate()) return false;

    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    isLoading = false;
    notifyListeners();

    return otp == "123456";
  }

  /// 🔐 Resend OTP
  void resendOtp() {
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}