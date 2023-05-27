import 'package:ootdforyou/model/cloth.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ClothDB {
  List<Cloth> _clothes = [];
  List<Cloth> get clothes => _clothes;

  Future<void> loadClothes() async {
    String data = await rootBundle.loadString('assets/data/topDB.json');
    List<dynamic> jsonList = json.decode(data);
    _clothes = jsonList.map((json) => Cloth.fromJson(json)).toList(); //map() 순회함수 모든 요소에 대해 해당 함수를 실행함
  }



  Cloth getCloth(int index) => _clothes[index];

  int get length => _clothes.length;

  List<String> get names => _clothes.map((cloth) => cloth.name).toList();

  List<int> get categories => _clothes.map((cloth) => cloth.category).toList();

  List<int> get subcategories => _clothes.map((cloth) => cloth.subcategory).toList();

  List<String> get imageUrls => _clothes.map((cloth) => cloth.imageUrl).toList();

  List<int> get genders => _clothes.map((cloth) => cloth.gender).toList();

  List<int> get materials => _clothes.map((cloth) => cloth.material).toList();

  List<int> get colors => _clothes.map((cloth) => cloth.color).toList();

  List<int> get thicknesses => _clothes.map((cloth) => cloth.thickness).toList();

  List<int> get season => _clothes.map((cloth) => cloth.season).toList();
}