import 'dart:math';
import '../data/classificationCloth.dart';
import 'package:ootdforyou/model/cloth.dart';
import 'package:ootdforyou/data/clothDB.dart';
import 'package:ootdforyou/screens/weather_screen.dart';
import 'package:flutter/material.dart';
import 'package:ootdforyou/utils/decisionTree.dart';

class DecisionPage extends StatefulWidget {
  final ClothDB clothDB;
  DecisionPage({required this.clothDB});

  @override
  _DecisionPageState createState() => _DecisionPageState();
}

class _DecisionPageState extends State<DecisionPage> {

  int i = 0;
  String season = '';

  late Function isHot;
  late Function isWarm;
  late Function isCool;
  late Function isCold;
  late Function isWind;

  late Function isOuter;
  late Function isTop;
  late Function isBot;
  late Function isSubcate;
  late Function isThick;
  late Function isMater;

  List<Cloth> springTop = [];
  List<Cloth> summerTop = [];
  List<Cloth> autumnTop = [];
  List<Cloth> winterTop = [];
  List<Cloth> springOuter = [];
  List<Cloth> autumnOuter = [];
  List<Cloth> winterOuter = [];
  List<Cloth> longBot = [];
  List<Cloth> shortBot = [];

  @override
  void initState() {

    super.initState();
    isHot = () => WeatherScreen.feelstmp > 23;
    isWarm = () => WeatherScreen.feelstmp > 12;
    isCool = () => WeatherScreen.feelstmp >= 5;
    isWind = () => WeatherScreen.winds > 8;

    bool isOuter(Cloth cloth) {
      return widget.clothDB.clothes[i].category == 1;
    }
    bool isTop(Cloth cloth) {
      return widget.clothDB.clothes[i].category == 2;
    }
    //isBot = () => widget.clothDB.clothes[i].category == '하의';
    bool isWinterSubcate(Cloth cloth) {
      return widget.clothDB.clothes[i].subcategory >= 7;
    }
    bool isWinterThick(Cloth cloth) {
      return widget.clothDB.clothes[i].thickness >= 7;
    }
    bool isWinterMater(Cloth cloth) {
      return widget.clothDB.clothes[i].material >= 7;
    }
    bool isAutumnSubcate(Cloth cloth) {
      return widget.clothDB.clothes[i].subcategory >= 4;
    }
    bool isAutumnThick(Cloth cloth) {
      return widget.clothDB.clothes[i].thickness >= 4;
    }
    bool isAutumnMater(Cloth cloth) {
      return widget.clothDB.clothes[i].material >= 4;
    }

    //하의 로직
    var botNode = new ClothConditionNode(
        isAutumnSubcate, (cloth) => longBot.add(cloth), (cloth) =>
        shortBot.add(cloth));

    //상의 로직
    var winterTopThickNode = new ClothConditionNode(
        isWinterThick, (cloth) => winterTop.add(cloth), (cloth) =>
        autumnTop.add(cloth));
    var otherTopThickNode = new ClothConditionNode(
        isAutumnThick, (cloth) => springTop.add(cloth), (cloth) =>
        summerTop.add(cloth));
    var otherTopSubNode = new ClothConditionNode(
        isAutumnSubcate, otherTopThickNode, (cloth) => summerTop.add(cloth));
    var winterTopSubNode = new ClothConditionNode(
        isWinterSubcate, winterTopThickNode, otherTopSubNode);
    var topNode = new ClothConditionNode(isTop, winterTopSubNode, botNode);

    //아우터 로직
    var materNode = new ClothConditionNode(
        isAutumnMater, (cloth) => autumnOuter.add(cloth), (cloth) =>
        springOuter.add(cloth));
    var outerthickNode = new ClothConditionNode(
        isWinterThick, materNode, (cloth) => autumnOuter.add(cloth));
    var winterOutSubNode = new ClothConditionNode(
        isWinterSubcate, (cloth) => winterOuter.add(cloth), outerthickNode);
    var StartNode = new ClothConditionNode(isOuter, winterOutSubNode, topNode);

    //날씨 판단
    var windNode = new WeatherConditionNode(
        isWind, "autumn to winter cloth", "autumn cloth");
    var autumnNode = new WeatherConditionNode(isCool, windNode, "winter cloth");
    var springNode = new WeatherConditionNode(
        isWarm, "spring cloth", autumnNode);
    var summerNode = new WeatherConditionNode(
        isHot, "summer cloth", springNode);

    print(summerNode.decide());
    switch(summerNode.decide())
    {
      case "summer cloth":
        season = "Summer";
        break;
      case "spring cloth":
        season = "Spring";
        break;
      case "winter cloth":
        season = "Winter";
        break;
      default:
        season = "Autumn";
    }
    //옷 데이터 분류
    for (i; i < widget.clothDB.clothes.length; i++) {
      StartNode.decide(widget.clothDB.clothes[i]);
    }
    print(autumnTop.length);
  }


  @override
  Widget build(BuildContext context) {
    late List<Cloth> topList;
    late List<Cloth> outerList;
    late List<Cloth> bottomList;

    // 계절에 따라 옷 리스트 설정
    if (season == "Spring") {
      topList = springTop;
      outerList = springOuter;
      bottomList = longBot;
    } else if (season == "Summer") {
      topList = summerTop;
      outerList = [];
      bottomList = shortBot;
    } else if (season == "Autumn") {
      topList = autumnTop;
      outerList = autumnOuter;
      bottomList = longBot;
    } else if (season == "Winter") {
      topList = winterTop;
      outerList = winterOuter;
      bottomList = longBot;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('OOTD for You'),
      ),
      body: ListView.builder(
        itemCount: 3, // top, outer, bottom 각각 하나씩 총 3개의 아이템 표시
        itemBuilder: (context, index) {
          Cloth? selectedCloth;
          String title = '';
          List<Cloth> clothes = [];

          switch(index) {
            case 0: // 아우터
              title = 'Outer';
              clothes = outerList;
              selectedCloth = clothes.isNotEmpty ? clothes[Random().nextInt(clothes.length)] : null;
              break;
            case 1: // 상의
              title = 'Top';
              clothes = topList;
              selectedCloth = clothes.isNotEmpty ? clothes[Random().nextInt(clothes.length)] : null;
              break;
            case 2: // 하의
              title = 'Bottom';
              clothes = bottomList;
              selectedCloth = clothes.isNotEmpty ? clothes[Random().nextInt(clothes.length)] : null;
              break;
          }

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                selectedCloth != null ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('옷 이름: ${selectedCloth.name}'),
                    SizedBox(height: 8.0),
                    Image.network(selectedCloth.imageUrl,
                      width: 300.0,
                      fit: BoxFit.cover,),
                  ],
                ) : Text('입지 않아도 될 거 같아요!'),
              ],
            ),
          );
        },
      ),
    );
  }
}