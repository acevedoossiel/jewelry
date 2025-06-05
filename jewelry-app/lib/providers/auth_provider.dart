import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  // Login
  Future<bool> login(String email, String password) async {
    final url = Uri.parse('http://localhost:3000/api/users/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _user = UserModel.fromJson(data['user']);

      // Guardar sesión localmente
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', _user!.email);
      await prefs.setString('userRole', _user!.role);

      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  // Cargar sesión existente
  Future<void> loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');
    final role = prefs.getString('userRole');

    if (email != null && role != null) {
      _user = UserModel(
        name: '',
        email: email,
        role: role,
      ); // Puedes cargar más info si lo necesitas
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // o remove individual si lo prefieres

    _user = null;
    notifyListeners();
  }
}
