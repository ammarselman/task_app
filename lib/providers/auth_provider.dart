import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  String? _token;

  String? get token => _token;

  Future<void> login(String username, String password) async {
    try {
      final response = await _apiService.login(username, password);
      _token = response['token'];
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
