class JewelryModel {
  String? id; // Ahora este será el _id de Mongo
  String name;
  String material;
  List<String> mediaLinks;
  List<String> details;
  double price;
  int quantity;
  bool isFavorite;

  JewelryModel({
    this.id, // opcional, porque al crear no lo tienes aún
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
      id: json['_id'], // leer el ObjectId de Mongo
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
      'name': name,
      'material': material,
      'mediaLinks': mediaLinks,
      'details': details,
      'price': price,
      'quantity': quantity,
      // ❌ No se incluye `id` al mandar datos
    };
  }

  @override
  String toString() {
    return 'Jewelry(id: $id, name: $name, material: $material, mediaLinks: $mediaLinks, price: $price, quantity: $quantity, details: $details, isFavorite: $isFavorite)';
  }
}
