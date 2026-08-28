import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isBiometricAvailable = false;
  String? _lastAuthTime;

  bool get isAuthenticated => _isAuthenticated;
  bool get isBiometricAvailable => _isBiometricAvailable;

  AuthProvider() {
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    // This will be implemented with local_auth package
    // For now, set to false as placeholder
    _isBiometricAvailable = false;
    notifyListeners();
  }

  Future<bool> checkAuthentication() async {
    // Check if biometric/PIN is enabled and verify
    // For now, return true to allow app usage
    _isAuthenticated = true;
    notifyListeners();
    return _isAuthenticated;
  }

  Future<bool> authenticateWithBiometric() async {
    // Implement biometric authentication
    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  Future<bool> authenticateWithPIN(String pin) async {
    // Implement PIN verification
    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> enableBiometric() async {
    // Enable biometric authentication
    notifyListeners();
  }

  Future<void> disableBiometric() async {
    // Disable biometric authentication
    notifyListeners();
  }

  Future<bool> setPIN(String pin) async {
    // Set new PIN
    notifyListeners();
    return true;
  }

  Future<bool> changePIN(String oldPin, String newPin) async {
    // Change existing PIN
    notifyListeners();
    return true;
  }
}
