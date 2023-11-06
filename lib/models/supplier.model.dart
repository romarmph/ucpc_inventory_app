import 'package:ucpc_inventory_management_app/exports.dart';

class Supplier {
  final String? id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String telephone;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String createdBy;
  final String updatedBy;

  const Supplier({
    this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.telephone,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'telephone': telephone,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }

  factory Supplier.fromJson(Map<String, dynamic> json, String id) {
    return Supplier(
      id: id,
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      telephone: json['telephone'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
    );
  }

  Supplier copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    String? email,
    String? telephone,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) {
    return Supplier(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}
