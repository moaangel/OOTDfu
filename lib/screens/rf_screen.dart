import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ootdforyou/data/classificationCloth.dart';
import 'package:ootdforyou/model/cloth.dart';
import 'package:ootdforyou/screens/weather_screen.dart';
import 'package:ootdforyou/utils/decisionTree.dart';

class RFPage extends StatefulWidget {
  @override
  _RFPageState createState() => _RFPageState();
}

class _RFPageState extends State<RFPage> {
  final ClassificationCloth _classificationCloth = ClassificationCloth();

  String todaytmp = '';

  late Function isHot;
  late Function isWarm;
  late Function isCool;

  bool isMale = false;
  bool isFemale = false;

  Cloth? _selectedCloth;

  @override
  void initState() {
    super.initState();
    _loadData();
    isHot = () => WeatherScreen.feelstmp > 23;
    isWarm = () => WeatherScreen.feelstmp > 15;
    isCool = () => WeatherScreen.feelstmp > 4;

    // 날씨 판단
    var autumnNode =
    WeatherConditionNode(isCool, "autumn cloth", "winter cloth");
    var springNode = WeatherConditionNode(isWarm, "spring cloth", autumnNode);
    var summerNode = WeatherConditionNode(isHot, "summer cloth", springNode);

    switch (summerNode.decide()) {
      case "summer cloth":
        todaytmp = "Summer";
        break;
      case "spring cloth":
        todaytmp = "Spring";
        break;
      case "winter cloth":
        todaytmp = "Winter";
        break;
      case "autumn cloth":
        todaytmp = "Autumn";
        break;
    }
  }

  Future<void> _loadData() async {
    await _classificationCloth.loadClothes(); // 데이터 로드
    setState(() {}); // 화면 갱신
  }

  @override
  Widget build(BuildContext context) {
    late List<Cloth> topListM;
    late List<Cloth> outerListM;
    late List<Cloth> bottomListM;
    late List<Cloth> topListW;
    late List<Cloth> outerListW;
    late List<Cloth> bottomListW;
    final List<List<Cloth>> clothlist = _classificationCloth.clothes;

    // 계절에 따라 옷 리스트 설정
    if (todaytmp == "Spring") {
      topListM = clothlist[3].where((cloth) => cloth.gender == 1).toList();
      outerListM = clothlist[0].where((cloth) => cloth.gender == 1).toList();
      bottomListM = clothlist[7].where((cloth) => cloth.gender == 1).toList();
    } else if (todaytmp == "Summer") {
      topListM = clothlist[4].where((cloth) => cloth.gender == 1).toList();
      outerListM = [];
      bottomListM = clothlist[8].where((cloth) => cloth.gender == 1).toList();
    } else if (todaytmp == "Autumn") {
      topListM = clothlist[5].where((cloth) => cloth.gender == 1).toList();
      outerListM = clothlist[1].where((cloth) => cloth.gender == 1).toList();
      bottomListM = clothlist[7].where((cloth) => cloth.gender == 1).toList();
    } else if (todaytmp == "Winter") {
      topListM = clothlist[6].where((cloth) => cloth.gender == 1).toList();
      outerListM = clothlist[2].where((cloth) => cloth.gender == 1).toList();
      bottomListM = clothlist[7].where((cloth) => cloth.gender == 1).toList();
    }

    if (todaytmp == "Spring") {
      topListW = clothlist[3].where((cloth) => cloth.gender == 2).toList();
      outerListW = clothlist[0].where((cloth) => cloth.gender == 2).toList();
      bottomListW = clothlist[7].where((cloth) => cloth.gender == 2).toList();
    } else if (todaytmp == "Summer") {
      topListW = clothlist[4].where((cloth) => cloth.gender == 2).toList();
      outerListW = [];
      bottomListW = clothlist[8].where((cloth) => cloth.gender == 2).toList();
    } else if (todaytmp == "Autumn") {
      topListW = clothlist[5].where((cloth) => cloth.gender == 2).toList();
      outerListW = clothlist[1].where((cloth) => cloth.gender == 2).toList();
      bottomListW = clothlist[7].where((cloth) => cloth.gender == 2).toList();
    } else if (todaytmp == "Winter") {
      topListW = clothlist[6].where((cloth) => cloth.gender == 2).toList();
      outerListW = clothlist[2].where((cloth) => cloth.gender == 2).toList();
      bottomListW = clothlist[7].where((cloth) => cloth.gender == 2).toList();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('OOTD for You'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    if(!isMale) {
                      isFemale = false;
                      isMale = true;
                    }
                    else{
                      isMale = false;
                    }
                  });
                },
                backgroundColor: isMale ? Colors.blue : Colors.grey,
                child: Text('남자'),
              ),
              SizedBox(width: 16.0),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    if(!isFemale) {
                      isMale = false;
                      isFemale = true;
                    }
                    else{
                      isFemale = false;
                    }
                  });
                },
                backgroundColor: isFemale ? Colors.blue : Colors.grey,
                child: Text('여자'),
              ),
            ],
          ),
          Expanded(
            child: isMale || isFemale ? ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                Cloth? selectedCloth;
                String title = '';
                List<Cloth> clothes = [];
                if (isMale) {
                  switch (index) {
                    case 0:
                      title = 'Outer';
                      clothes = outerListM;
                      selectedCloth = clothes.isNotEmpty
                          ? clothes[Random().nextInt(clothes.length)]
                          : null;
                      break;
                    case 1:
                      title = 'Top';
                      clothes = topListM;
                      selectedCloth = clothes.isNotEmpty
                          ? clothes[Random().nextInt(clothes.length)]
                          : null;
                      break;
                    case 2:
                      title = 'Bottom';
                      clothes = bottomListM;
                      selectedCloth = clothes.isNotEmpty
                          ? clothes[Random().nextInt(clothes.length)]
                          : null;
                      break;
                  }
                } else if (isFemale) {
                  switch (index) {
                    case 0:
                      title = 'Outer';
                      clothes = outerListW;
                      selectedCloth = clothes.isNotEmpty
                          ? clothes[Random().nextInt(clothes.length)]
                          : null;
                      break;
                    case 1:
                      title = 'Top';
                      clothes = topListW;
                      selectedCloth = clothes.isNotEmpty
                          ? clothes[Random().nextInt(clothes.length)]
                          : null;
                      break;
                    case 2:
                      title = 'Bottom';
                      clothes = bottomListW;
                      selectedCloth = clothes.isNotEmpty
                          ? clothes[Random().nextInt(clothes.length)]
                          : null;
                      break;
                  }
                }

                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      selectedCloth != null
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('옷 이름: ${selectedCloth.name}'),
                          SizedBox(height: 8.0),
                          Image.network(
                            selectedCloth.imageUrl,
                            width: 300.0,
                            fit: BoxFit.cover,
                          ),
                        ],
                      )
                          : Text('입지 않아도 될 거 같아요!'),
                    ],
                  ),
                );
              },
            ) : Container(),
          ),
        ],
      ),
    );
  }
}