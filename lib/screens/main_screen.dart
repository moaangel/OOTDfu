import 'package:flutter/material.dart';
import 'package:ootdforyou/data/clothDB.dart';
import 'package:ootdforyou/model/cloth.dart';
import 'package:ootdforyou/screens/review.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:ootdforyou/screens/decision_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ClothDB _clothDB = ClothDB();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _clothDB.loadClothes(); // 데이터 로드
    setState(() {}); // 화면 갱신
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 옷장'),
      ),
      body: Column(
        children: [
      Expanded(
      child: ListView.builder(
      itemCount: _clothDB.clothes.length,
        itemBuilder: (BuildContext context, int index) {
          final Cloth cloth = _clothDB.clothes[index];
          return ListTile(
            leading: Image.network(
              cloth.imageUrl,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Container(
                  width: 50.0,
                  height: 50.0,
                  color: Colors.grey,
                );
              },
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            title: Text(cloth.name, style: TextStyle(fontSize: 30.0)),
          );
        },
      ),
    ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DecisionPage(clothDB: _clothDB),
                ),
              );
            },
            child: Text('옷 선택하기'),
          ),
        ],
      ),
    );
  }
}