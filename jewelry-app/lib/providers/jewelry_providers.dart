import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:jewelry_app/models/jewelry_model.dart';

class JewelryProviders extends ChangeNotifier {
  bool isLoading = false;

  List<JewelryModel> _jewelrys = [];
  List<JewelryModel> _favoriteJewelry = [];

  // 🔹 Getters esperados por la UI
  List<JewelryModel> get items => _jewelrys;
  List<JewelryModel> get favoriteJewelry => _favoriteJewelry;

  String getBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:12345';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:12345';
    } else if (Platform.isIOS) {
      return 'http://localhost:12345';
    } else {
      return 'http://localhost:12345';
    }
  }

  // 🔹 Método renombrado como espera la pantalla
  Future<void> fetchJewelry() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse('${getBaseUrl()}/details');
    print("Fetch jewelrys");

    try {
      final response = await http.get(url);
      print("response status ${response.statusCode}");
      print("respuesta ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _jewelrys = List<JewelryModel>.from(
          data['jewelrys'].map((j) => JewelryModel.fromJSON(j)),
        );
      } else {
        _jewelrys = [];
      }
    } catch (e) {
      _jewelrys = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Modo local sin conexión
  Future<void> toggleFavoriteStatus(JewelryModel jewelry) async {
    final isFavorite = _favoriteJewelry.contains(jewelry);

    if (isFavorite) {
      _favoriteJewelry.remove(jewelry);
    } else {
      _favoriteJewelry.add(jewelry);
    }

    notifyListeners();
  }

  // 🔹 Guardar joya en lista local
  Future<bool> saveJewelry(JewelryModel jewelry) async {
    try {
      _jewelrys.add(jewelry);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error saving jewelry: $e');
      return false;
    }
  }
}
