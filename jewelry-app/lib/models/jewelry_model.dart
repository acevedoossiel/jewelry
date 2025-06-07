class JewelryModel {
  String? mongoId; // 👈 Nuevo: ID real de Mongo (_id)
  int id;
  String name;
  String material;
  List<String> mediaLinks;
  List<String> details;
  double price;
  int quantity;
  bool isFavorite;

  JewelryModel({
    this.mongoId, // 👈 Nuevo
    required this.id,
    required this.name,
    required this.material,
    required this.mediaLinks,
    required this.details,
    required this.price,
    this.quantity = 1,
    this.isFavorite = false,
  });

  factory JewelryModel.fromJSON(Map<String, dynamic> json) {
    return JewelryModel(
      mongoId: json['_id'], // 👈 Extraído del backend
      id: json['id'],
      name: json['name'],
      material: json['material'],
      mediaLinks: List<String>.from(json['mediaLinks']),
      details: List<String>.from(json['details']),
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] ?? 1,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      // No incluimos _id aquí porque no es necesario al enviar JSON
      'id': id,
      'name': name,
      'material': material,
      'mediaLinks': mediaLinks,
      'details': details,
      'price': price,
      'quantity': quantity,
    };
  }

  @override
  String toString() {
    return 'Jewelry(_id: $mongoId, id: $id, name: $name, material: $material, mediaLinks: $mediaLinks, price: $price, quantity: $quantity, details: $details, isFavorite: $isFavorite)';
  }
}
