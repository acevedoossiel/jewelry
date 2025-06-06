class JewelryModel {
  int id;
  String name;
  String material;
  List<String> mediaLinks; // 👈 CAMBIADO: ahora es una lista
  List<String> details;
  double price;
  int quantity;

  JewelryModel({
    required this.id,
    required this.name,
    required this.material,
    required this.mediaLinks, // 👈 CAMBIO
    required this.details,
    required this.price,
    this.quantity = 1,
  });

  factory JewelryModel.fromJSON(Map<String, dynamic> json) {
    return JewelryModel(
      id: json['id'],
      name: json['name'],
      material: json['material'],
      mediaLinks: List<String>.from(json['mediaLinks']), // 👈 CAMBIO
      details: List<String>.from(json['details']),
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'name': name,
      'material': material,
      'mediaLinks': mediaLinks, // 👈 CAMBIO
      'details': details,
      'price': price,
      'quantity': quantity,
    };
  }

  @override
  String toString() {
    return 'Jewelry(id: $id, name: $name, material: $material, mediaLinks: $mediaLinks, price: $price, quantity: $quantity, details: $details)';
  }
}
