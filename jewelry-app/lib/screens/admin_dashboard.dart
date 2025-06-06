import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/jewelry_model.dart';
import 'formulario_joya.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<JewelryModel> _jewelryList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJewelry();
  }

  Future<void> fetchJewelry() async {
    final url = Uri.parse('http://10.0.2.2:3000/api/jewelry');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _jewelryList =
              data.map((item) => JewelryModel.fromJSON(item)).toList();
          _isLoading = false;
        });
      } else {
        print('Error de servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al cargar joyas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _jewelryList.length,
                itemBuilder: (context, index) {
                  final item = _jewelryList[index];
                  final thumbnail =
                      (item.mediaLinks.isNotEmpty)
                          ? item.mediaLinks.first
                          : null;

                  return ListTile(
                    leading:
                        thumbnail != null
                            ? Image.network(
                              thumbnail,
                              width: 60,
                              errorBuilder:
                                  (_, __, ___) => const Icon(Icons.image),
                            )
                            : const Icon(Icons.image_not_supported),
                    title: Text(item.name),
                    subtitle: Text(
                      "Precio: \$${item.price.toStringAsFixed(2)}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // TODO: Implementar edición
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // TODO: Implementar eliminación
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => const FormularioJoya(),
          );

          if (result == true) {
            fetchJewelry();
          }
        },
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
