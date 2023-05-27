import 'package:ootdforyou/model/cloth.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ClassificationCloth {
  List<List<Cloth>> _classificationCloth = [];
  List<List<Cloth>> get clothes => _classificationCloth;

  Future<void> loadClothes() async {
    String data = await rootBundle.loadString('assets/data/classification_results.json');
    List<dynamic> jsonList = json.decode(data);

    _classificationCloth = jsonList.map((outerList) {
      return List<Cloth>.from(outerList.map((innerList) {
        return Cloth.fromJson(innerList);
      }));
    }).toList();
  }



  List<Cloth> getCloth(int index) => _classificationCloth[index];

  int get length => _classificationCloth.length;

  List<List<String>> get names => _classificationCloth.map((clothList) => clothList.map((cloth) => cloth.name).toList()).toList();

  List<List<int>> get categories => _classificationCloth.map((clothList) => clothList.map((cloth) => cloth.category).toList()).toList();

  List<List<int>> get subcategories => _classificationCloth.map((clothList) => clothList.map((cloth) => cloth.subcategory).toList()).toList();

  List<List<String>> get imageUrls => _classificationCloth.map((clothList) => clothList.map((cloth) => cloth.imageUrl).toList()).toList();

  List<List<int>> get genders => _classificationCloth.map((clothList) => clothList.map((cloth) => cloth.gender).toList()).toList();

  List<List<int>> get materials => _classificationCloth.map((clothList) => clothList.map((cloth) => cloth.material).toList()).toList();

  List<List<int>> get colors => _classificationCloth.map((clothList) => clothList.map((cloth) => cloth.color).toList()).toList();

  List<List<int>> get thicknesses => _classificationCloth.map((clothList) => clothList.map((cloth) => cloth.thickness).toList()).toList();

  List<List<int>> get seasons => _classificationCloth.map((clothList) => clothList.map((cloth) => cloth.season).toList()).toList();
}