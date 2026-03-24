import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const _jwtKey = 'jwt_token';
  static const _jwtExpiryKey = 'jwt_expiry';
  static const _pinKey = 'user_pin';

  // --- JWT Methods ---
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _jwtKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _jwtKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _jwtKey);
    await _storage.delete(key: _jwtExpiryKey);
  }

  static Future<void> saveTokenExpiry(DateTime expiry) async {
    await _storage.write(key: _jwtExpiryKey, value: expiry.toIso8601String());
  }

  static Future<DateTime?> getTokenExpiry() async {
    final value = await _storage.read(key: _jwtExpiryKey);
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  static Future<String?> getTokenIfValid() async {
    final token = await getToken();
    final expiry = await getTokenExpiry();
    if (token == null || expiry == null) return null;
    if (DateTime.now().isAfter(expiry)) {
      await deleteToken();
      return null;
    }
    return token;
  }

  static Future<void> saveTokenWithExpiry(
    String token,
    Duration duration,
  ) async {
    await saveToken(token);
    await saveTokenExpiry(DateTime.now().add(duration));
  }

  // --- PIN Methods ---
  static Future<void> savePin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
  }

  static Future<String?> getPin() async {
    return await _storage.read(key: _pinKey);
  }

  static Future<void> deletePin() async {
    await _storage.delete(key: _pinKey);
  }

  // --- Clear All ---
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
