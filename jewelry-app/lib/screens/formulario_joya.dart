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
  final TextEditingController _imageUrl = TextEditingController();
  final TextEditingController _details = TextEditingController();
  final TextEditingController _price = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _material.dispose();
    _imageUrl.dispose();
    _details.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final jewelryProvider = Provider.of<JewelryProviders>(context, listen: false);

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
            Text("Nueva Joya", style: TextStyle(fontSize: 20, color: colors.primary)),
            const SizedBox(height: 10),
            _buildTextField(_name, "Nombre de la joya", (value) {
              if (value == null || value.isEmpty) return "Campo obligatorio";
              return null;
            }),
            const SizedBox(height: 10),
            _buildTextField(_material, "Material (ej. Oro, Plata)", (value) {
              if (value == null || value.isEmpty) return "Campo obligatorio";
              return null;
            }),
            const SizedBox(height: 10),
            _buildTextField(_imageUrl, "URL de la imagen", (value) {
              if (value == null || value.isEmpty) return "Campo obligatorio";
              return null;
            }),
            const SizedBox(height: 10),
            _buildTextField(_price, "Precio (ej. 1499.99)", (value) {
              if (value == null || value.isEmpty) return "Campo obligatorio";
              if (double.tryParse(value) == null) return "Debe ser un número válido";
              return null;
            }, keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            _buildTextField(_details, "Características", (value) {
              if (value == null || value.isEmpty) return "Campo obligatorio";
              return null;
            }, maxLines: 3),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final newJoya = JewelryModel(
                      id: jewelryProvider.items.length + 1,
                      name: _name.text,
                      material: _material.text,
                      imageLink: _imageUrl.text,
                      details: [_details.text],
                      price: double.parse(_price.text),
                    );

                    final success = await jewelryProvider.saveJewelry(newJoya);
                    if (success) Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Guardar joya", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
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
