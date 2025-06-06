import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jewelry_app/models/jewelry_model.dart';
import 'package:jewelry_app/providers/jewelry_providers.dart';

class FormularioJoya extends StatefulWidget {
  const FormularioJoya({super.key});

  @override
  State<FormularioJoya> createState() => _FormularioJoyaState();
}

class _FormularioJoyaState extends State<FormularioJoya> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _material = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _details = TextEditingController();

  // Lista de URLs para imágenes o videos
  List<TextEditingController> _mediaLinkControllers = [TextEditingController()];

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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final jewelryProvider = Provider.of<JewelryProviders>(
      context,
      listen: false,
    );

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
              "Nueva Joya",
              style: TextStyle(fontSize: 20, color: colors.primary),
            ),
            const SizedBox(height: 10),
            _buildTextField(_name, "Nombre de la joya", _requiredValidator),
            const SizedBox(height: 10),
            _buildTextField(
              _material,
              "Material (ej. Oro, Plata)",
              _requiredValidator,
            ),
            const SizedBox(height: 10),

            // Campos dinámicos de URLs
            Text(
              "URLs de imagen/video:",
              style: TextStyle(color: colors.primary),
            ),
            const SizedBox(height: 6),
            ..._mediaLinkControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controller = entry.value;
              return Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller,
                      "URL ${index + 1}",
                      _requiredValidator,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (_mediaLinkControllers.length > 1)
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _mediaLinkControllers.removeAt(index).dispose();
                        });
                      },
                    ),
                ],
              );
            }).toList(),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _mediaLinkControllers.add(TextEditingController());
                });
              },
              icon: const Icon(Icons.add),
              label: const Text("Agregar otra URL"),
            ),

            const SizedBox(height: 10),
            _buildTextField(
              _price,
              "Precio (ej. 1499.99)",
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

                    final newJoya = JewelryModel(
                      id: jewelryProvider.items.length + 1,
                      name: _name.text.trim(),
                      material: _material.text.trim(),
                      mediaLinks: mediaLinks,
                      details: [_details.text.trim()],
                      price: double.parse(_price.text.trim()),
                    );

                    final success = await jewelryProvider.saveJewelry(newJoya);
                    if (success) {
                      Navigator.pop(context, true);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Guardar joya",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
