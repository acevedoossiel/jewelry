class JewelryModel {
  int id;
  String name;
  String material;
  String imageLink;
  List<String> details;
  double price;
  int quantity; // 👈 NUEVO CAMPO

  // Constructor
  JewelryModel({
    required this.id,
    required this.name,
    required this.material,
    required this.imageLink,
    required this.details,
    required this.price,
    this.quantity = 1, // 👈 Valor por defecto
  });

  // Factory para crear desde JSON
  factory JewelryModel.fromJSON(Map<String, dynamic> json) {
    return JewelryModel(
      id: json['id'],
      name: json['name'],
      material: json['material'],
      imageLink: json['imageLink'],
      details: List<String>.from(json['details']),
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] ?? 1, 
    );
  }

  // Conversor a JSON
  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'name': name,
      'material': material,
      'imageLink': imageLink,
      'details': details,
      'price': price,
      'quantity': quantity, 
    };
  }

  @override
  String toString() {
    return 'Jewelry(id: $id, name: $name, material: $material, imageLink: $imageLink, price: $price, quantity: $quantity, details: $details)';
  }
}
