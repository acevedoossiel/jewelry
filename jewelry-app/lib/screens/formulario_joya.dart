import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:jewelry_app/models/jewelry_model.dart';
import 'package:jewelry_app/providers/jewelry_providers.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FormularioJoya extends StatefulWidget {
  final JewelryModel? joya; // ✅ permite editar

  const FormularioJoya({super.key, this.joya});

  @override
  State<FormularioJoya> createState() => _FormularioJoyaState();
}

class _FormularioJoyaState extends State<FormularioJoya> {
  final formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _material = TextEditingController();
  final _price = TextEditingController();
  final _details = TextEditingController();
  List<TextEditingController> _mediaLinkControllers = [TextEditingController()];
  final ImagePicker _picker = ImagePicker();

  bool get isEditing => widget.joya != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      final joya = widget.joya!;
      _name.text = joya.name;
      _material.text = joya.material;
      _price.text = joya.price.toString();
      _details.text = joya.details.join(', ');

      _mediaLinkControllers =
          joya.mediaLinks
              .map((link) => TextEditingController(text: link))
              .toList();
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _material.dispose();
    _price.dispose();
    _details.dispose();
    for (final controller in _mediaLinkControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickAndUploadFile(
    ImageSource source, {
    required bool isImage,
  }) async {
    final picked =
        isImage
            ? await _picker.pickImage(source: source)
            : await _picker.pickVideo(source: source);

    if (picked != null) {
      final file = File(picked.path);
      final baseUrl = dotenv.env['API_BASE_URL']!;
      final uri = Uri.parse('$baseUrl/api/jewelry/upload');

      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();

      if (response.statusCode == 201) {
        final body = await response.stream.bytesToString();
        final url = RegExp(r'"url":"([^"]+)"').firstMatch(body)?.group(1);
        if (url != null) {
          setState(() {
            _mediaLinkControllers.add(
              TextEditingController(text: '$baseUrl$url'),
            );
          });
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Error al subir archivo")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final provider = Provider.of<JewelryProviders>(context, listen: false);

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? "Editar Joya" : "Nueva Joya",
              style: TextStyle(fontSize: 20, color: colors.primary),
            ),
            const SizedBox(height: 10),
            _buildTextField(_name, "Nombre de la joya", _requiredValidator),
            const SizedBox(height: 10),
            _buildTextField(_material, "Material", _requiredValidator),
            const SizedBox(height: 10),
            Text("Imágenes/Videos:", style: TextStyle(color: colors.primary)),
            const SizedBox(height: 6),
            ..._mediaLinkControllers.asMap().entries.map((entry) {
              final i = entry.key;
              final controller = entry.value;
              return Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller,
                      "URL ${i + 1}",
                      _requiredValidator,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (_mediaLinkControllers.length > 1)
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _mediaLinkControllers.removeAt(i).dispose();
                        });
                      },
                    ),
                ],
              );
            }).toList(),
            Row(
              children: [
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    _pickAndUploadFile(ImageSource.gallery, isImage: true);
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("Subir imagen"),
                ),
                TextButton.icon(
                  onPressed: () {
                    _pickAndUploadFile(ImageSource.gallery, isImage: false);
                  },
                  icon: const Icon(Icons.videocam),
                  label: const Text("Subir video"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildTextField(
              _price,
              "Precio",
              _priceValidator,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              _details,
              "Características",
              _requiredValidator,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final mediaLinks =
                        _mediaLinkControllers
                            .map((c) => c.text.trim())
                            .toList();
                    final joya = JewelryModel(
                      id:
                          isEditing
                              ? widget.joya!.id
                              : provider.items.length + 1,
                      name: _name.text.trim(),
                      material: _material.text.trim(),
                      mediaLinks: mediaLinks,
                      details: [_details.text.trim()],
                      price: double.parse(_price.text.trim()),
                    );

                    final success =
                        isEditing
                            ? await provider.updateJewelry(joya)
                            : await provider.saveJewelry(joya);

                    if (success) Navigator.pop(context, true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isEditing ? "Actualizar joya" : "Guardar joya",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Funciones auxiliares

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return "Campo obligatorio";
    return null;
  }

  String? _priceValidator(String? value) {
    if (value == null || value.trim().isEmpty) return "Campo obligatorio";
    if (double.tryParse(value) == null) return "Debe ser un número válido";
    return null;
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String? Function(String?) validator, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final colors = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: colors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.tertiary, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
