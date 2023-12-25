
import 'package:equatable/equatable.dart';

class ProductCompany extends Equatable{
  final int id;
  final String logoPath;
  final String name;
  final String originCountry;

  const ProductCompany({ required this.id, required this.logoPath, required this.name, required this.originCountry});

  @override
  List<Object> get props => [id,logoPath,name,originCountry];

  factory ProductCompany.fromJson(Map<String, dynamic> json) {
    return ProductCompany(
      id: json['id'] ?? 0,
      logoPath: json['logo_path'] ?? "",
      name: json['name'] ?? "",
      originCountry: json['origin_country'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'logo_path': logoPath,
      'name': name,
      'origin_country': originCountry,
    };
  }


}