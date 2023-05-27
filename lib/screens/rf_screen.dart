import 'dart:math';

import 'package:ootdforyou/model/cloth.dart';
import 'package:ootdforyou/data/clothDB.dart';
import 'package:ootdforyou/screens/weather_screen.dart';
import 'package:flutter/material.dart';
import 'package:sklite/ensemble/forest.dart';
import 'package:sklite/tree/tree.dart';

class RFPage extends StatefulWidget {
  final ClothDB clothDB;
  RFPage({required this.clothDB});

  @override
  _RFPageState createState() => _RFPageState();
}

class _RFPageState extends State<RFPage> {
  RandomForestClassifier randomForest = RandomForestClassifier([], []);

  @override
  void initState() {
    super.initState();
    trainRandomForest();
  }

  void trainRandomForest() {
    List<Cloth> clothes = widget.clothDB.clothes;
    List<List<int>> features = [];
    List<int> targets = [];

    for (var cloth in clothes) {
      List<int> feature = [
        cloth.thickness,
        // 다른 특성을 추가할 수 있습니다.
      ];
      features.add(feature);
      targets.add(cloth.season);
    }

    randomForest = RandomForestClassifier(
      targets.toSet().toList(),
      [], // 결정 트리 설정을 추가하여야 합니다.
    );
    Random random = Random();
    for (int i = 0; i < 50; i++) {
      DecisionTreeClassifier decisionTree = DecisionTreeClassifier([],[],[],features);
      randomForest.dtrees.add(decisionTree.toMap());
    }

    randomForest.initDtrees(randomForest.dtrees);
  }

  String classifyCloth(Cloth cloth) {
    List<int> feature = [
      cloth.thickness,
      // 다른 특성을 추가할 수 있습니다.
    ];
    int predictedClass = randomForest.predict(feature.cast<double>());
    String predictedSeason = randomForest.classes[predictedClass] as String;
    return predictedSeason;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: 페이지 레이아웃 구성 및 분류 적용
    return Scaffold(
      appBar: AppBar(
        title: Text('RFPage'),
      ),
      body: Center(
        child: Text(
          'Random Forest Classification',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}