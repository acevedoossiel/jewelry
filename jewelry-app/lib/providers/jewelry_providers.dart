import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:jewelry_app/models/jewelry_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class JewelryProviders extends ChangeNotifier {
  bool isLoading = false;

  List<JewelryModel> _jewelrys = [];
  List<JewelryModel> _favoriteJewelry = [];

  // Getters para la UI
  List<JewelryModel> get items => _jewelrys;
  List<JewelryModel> get favoriteJewelry => _favoriteJewelry;

  // ✅ Determina la URL base según la plataforma
  String getBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:3000';
    } else if (Platform.isAndroid) {
      return dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';
    } else if (Platform.isIOS) {
      return 'http://localhost:3000';
    } else {
      return 'http://localhost:3000';
    }
  }

  // ✅ Cargar joyas desde la API
  Future<void> fetchJewelry() async {
    final baseUrl = dotenv.env['API_BASE_URL']!;
    final url = Uri.parse('$baseUrl/api/jewelry');
    // final url = Uri.parse('${getBaseUrl()}/api/jewelry');
    print("Fetching jewelry from $url");

    try {
      isLoading = true;
      notifyListeners();

      final response = await http.get(url);
      print("Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _jewelrys = data.map((j) => JewelryModel.fromJSON(j)).toList();
      } else {
        print('Error al obtener joyas: ${response.statusCode}');
        _jewelrys = [];
      }
    } catch (e) {
      print("Excepción en fetchJewelry: $e");
      _jewelrys = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Alternar favorito (solo en memoria local)
  Future<void> toggleFavoriteStatus(JewelryModel jewelry) async {
    final exists = _favoriteJewelry.contains(jewelry);
    if (exists) {
      _favoriteJewelry.remove(jewelry);
    } else {
      _favoriteJewelry.add(jewelry);
    }
    notifyListeners();
  }

  // ✅ Guardar joya en el backend
  Future<bool> saveJewelry(JewelryModel jewelry) async {
    final url = Uri.parse('${getBaseUrl()}/api/jewelry');
    print("POST to $url");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jewelry.toJSON()),
      );

      if (response.statusCode == 201) {
        final created = JewelryModel.fromJSON(jsonDecode(response.body));
        _jewelrys.add(created);
        notifyListeners();
        return true;
      } else {
        print('Error en POST: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error al guardar joya: $e');
      return false;
    }
  }
}
