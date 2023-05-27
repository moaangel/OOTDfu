import 'package:http/http.dart' as http;
import 'dart:io';


class Cloth {
  final String name;
  final int category;
  final int subcategory;
  final String imageUrl;
  final int gender;
  final int material;
  final int color;
  final int thickness;
  final int season;

  Cloth({
    required this.name,
    required this.category,
    required this.subcategory,
    required this.imageUrl,
    required this.gender,
    required this.material,
    required this.color,
    required this.thickness,
    required this.season
  });

  factory Cloth.fromJson(Map<String, dynamic> json) {
    return Cloth(
      name: json['name'],
      category: json['category'],
      subcategory: json['subcategory'],
      imageUrl: json['imageUrl'],
      gender: json['gender'],
      material: json['material'],
      color: json['color'],
      thickness: json['thickness'],
      season: json['season']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'subcategory': subcategory,
      'imageUrl': imageUrl,
      'gender': gender,
      'material': material,
      'color': color,
      'thickness': thickness,
      'season': season
    };
  }
}