import 'package:ucpc_inventory_management_app/exports.dart';

class Product {
  final String? id;
  final String name;
  final String description;
  final List imageUrls;
  final String? supplierId;
  final double price;
  final int quantity;
  final bool isPopular;
  final bool isHidden;
  final String barcode;
  final String createdBy;
  final String? updatedBy;
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  Product({
    this.id,
    this.description = "",
    this.imageUrls = const [],
    this.price = 0,
    this.quantity = 0,
    this.updatedBy,
    this.updatedAt,
    this.supplierId,
    this.isPopular = false,
    this.isHidden = false,
    this.barcode = "",
    required this.name,
    required this.createdBy,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrls': imageUrls,
      'supplierId': supplierId,
      'price': price,
      'quantity': quantity,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'isPopular': isPopular,
      'isHidden': isHidden,
      'barcode': barcode,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json, String id) {
    return Product(
      id: id,
      name: json['name'],
      description: json['description'],
      imageUrls: json['imageUrls'],
      supplierId: json['supplierId'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      isPopular: json['isPopular'],
      isHidden: json['isHidden'],
      barcode: json['barcode'],
    );
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? imageUrls,
    String? supplierId,
    double? price,
    int? quantity,
    bool? isPopular,
    bool? isHidden,
    String? barcode,
    String? createdBy,
    String? updatedBy,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      supplierId: supplierId ?? this.supplierId,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      isPopular: isPopular ?? this.isPopular,
      isHidden: isHidden ?? this.isHidden,
      barcode: barcode ?? this.barcode,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
