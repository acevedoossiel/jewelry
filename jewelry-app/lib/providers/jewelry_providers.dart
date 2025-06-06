// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:jewelry_app/models/jewelry_model.dart';

// class JewelryProviders extends ChangeNotifier {
//   bool isLoading = false;

//   List<JewelryModel> _jewelrys = [];
//   List<JewelryModel> _favoriteJewelry = [];

//   // 🔹 Getters esperados por la UI
//   List<JewelryModel> get items => _jewelrys;
//   List<JewelryModel> get favoriteJewelry => _favoriteJewelry;

//   String getBaseUrl() {
//     if (kIsWeb) {
//       return 'http://localhost:3000'; // ← Asegúrate que esté bien
//     } else if (Platform.isAndroid) {
//       return 'http://10.0.2.2:3000';
//     } else if (Platform.isIOS) {
//       return 'http://localhost:3000';
//     } else {
//       return 'http://localhost:3000';
//     }
//   }

//   Future<void> fetchJewelry() async {
//     isLoading = true;
//     notifyListeners();

//     final url = Uri.parse('${getBaseUrl()}/api/jewelry');
//     print("Fetch jewelrys");

//     try {
//       final response = await http.get(url);
//       print("response status ${response.statusCode}");
//       print("respuesta ${response.body}");

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         _jewelrys = List<JewelryModel>.from(
//           data.map((j) => JewelryModel.fromJSON(j)),
//         );
//       } else {
//         _jewelrys = [];
//       }
//     } catch (e) {
//       print("Error: $e");
//       _jewelrys = [];
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   // 🔹 Modo local sin conexión
//   Future<void> toggleFavoriteStatus(JewelryModel jewelry) async {
//     final isFavorite = _favoriteJewelry.contains(jewelry);

//     if (isFavorite) {
//       _favoriteJewelry.remove(jewelry);
//     } else {
//       _favoriteJewelry.add(jewelry);
//     }

//     notifyListeners();
//   }

//   // 🔹 Guardar joya en lista local
//   Future<bool> saveJewelry(JewelryModel jewelry) async {
//     final url = Uri.parse('${getBaseUrl()}/api/jewelry');

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(jewelry.toJSON()),
//       );

//       if (response.statusCode == 201) {
//         // Si el backend devuelve el objeto creado, lo puedes parsear aquí
//         final created = JewelryModel.fromJSON(jsonDecode(response.body));
//         _jewelrys.add(created);
//         notifyListeners();
//         return true;
//       } else {
//         print('Error en POST: ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       print('Error al guardar joya en servidor: $e');
//       return false;
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:jewelry_app/models/jewelry_model.dart';

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
      return 'http://10.0.2.2:3000';
    } else if (Platform.isIOS) {
      return 'http://localhost:3000';
    } else {
      return 'http://localhost:3000';
    }
  }

  // ✅ Cargar joyas desde la API
  Future<void> fetchJewelry() async {
    final url = Uri.parse('${getBaseUrl()}/api/jewelry');
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
