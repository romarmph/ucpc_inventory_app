import 'package:ucpc_inventory_management_app/exports.dart';

class ProductCategory {
  final String? id;
  final String name;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String createdBy;
  final String updatedBy;

  const ProductCategory({
    this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }

  factory ProductCategory.fromJson(Map<String, dynamic> json, String id) {
    return ProductCategory(
      id: id,
      name: json['name'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
    );
  }

  ProductCategory copyWith({
    String? id,
    String? name,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) {
    return ProductCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}
