import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class NotePage extends StatelessWidget {
  final TextEditingController _postController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser; // user 변수 선언 및 초기화
  int selectedRating = 0;

  Future<void> _addPost(int selectedRating) async {
    if (user != null) {
      if (_postController.text.isNotEmpty) {
        await FirebaseFirestore.instance.collection('posts').add({
          'content': _postController.text.trim(),
          'timestamp': DateTime.now().toLocal(),
          'userId': user!.email,
          'rating': selectedRating, // 추가된 부분
        });
        _postController.clear();
      }
    }
  }


  Future<void> _deletePost(BuildContext context, String documentId, String postUserId) async {
    if (user != null && user!.email == postUserId) {
      await FirebaseFirestore.instance.collection('posts')
          .doc(documentId)
          .delete();
    } else {
      // 권한이 없는 경우 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('글을 삭제할 권한이 없습니다.'),
        ),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    void _showReviewDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          int selectedRating = 0; // 사용자가 선택한 별점을 저장하는 변수

          return AlertDialog(
            title: Text('만족도 평가'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('별점을 선택하세요:'),
                // 별점 선택 위젯
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 30.0,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    selectedRating = rating.toInt();
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  _addPost(selectedRating);
                  Navigator.pop(context);
                },
                child: Text('작성'),
              ),
            ],
          );
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('리뷰 게시판'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('posts')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('데이터를 불러오는 중 오류가 발생했습니다.');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['content']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(data['timestamp'].toDate())),
                          // 별점 표시
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber),
                              Text(' ${data['rating'] ?? 'N/A'}'), // 별점이 없는 경우 'N/A'를 표시
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deletePost(context, document.id, data['userId']),
                      ),
                      leading: Text(data['userId'] ?? 'Unknown'),
                    );

                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _postController,
              decoration: InputDecoration(
                hintText: '게시물 작성',
              ),
            ),
          ),
          ElevatedButton(
            child: Text('작성'),
            onPressed: () => _showReviewDialog(),
          ),

        ],
      ),
    );
  }

}
