import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt_lib;
import 'dart:convert';

class AuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  static const String _pinKey = 'app_pin_hash';
  static const String _biometricEnabledKey = 'biometric_enabled';
  
  // Simple hash for PIN (in production, use stronger hashing)
  String _hashPin(String pin) {
    final key = encrypt_lib.Key.fromUtf8('32charactertempencryptionkey!!');
    final iv = encrypt_lib.IV.fromLength(16);
    final encrypter = encrypt_lib.Encrypter(encrypt_lib.AES(key));
    final encrypted = encrypter.encrypt(pin, iv: iv);
    return base64Encode(encrypted.bytes);
  }
  
  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> isDeviceSupported() async {
    return await _localAuth.isDeviceSupported();
  }
  
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }
  
  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to access your expense data',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
  
  Future<void> setPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinKey, _hashPin(pin));
  }
  
  Future<bool> verifyPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final storedHash = prefs.getString(_pinKey);
    if (storedHash == null) return false;
    return storedHash == _hashPin(pin);
  }
  
  Future<bool> hasPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_pinKey);
  }
  
  Future<void> removePin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pinKey);
  }
  
  Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, enabled);
  }
  
  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricEnabledKey) ?? false;
  }
}
