import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class NotePage extends StatelessWidget {
  final TextEditingController _postController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser; // user 변수 선언 및 초기화

  Future<void> _addPost() async {
    if (user != null) {
      if (_postController.text.isNotEmpty) {
        await FirebaseFirestore.instance.collection('posts').add({
          'content': _postController.text.trim(),
          'timestamp': DateTime.now().toLocal(),
          'userId': user!.email,
        });
        _postController.clear();
      }
    }
  }

  Future<void> _deletePost(String documentId) async {
    await FirebaseFirestore.instance.collection('posts')
        .doc(documentId)
        .delete();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시판'),
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
                      subtitle: Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(data['timestamp'].toDate())),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deletePost(document.id),
                      ),
                      // 작성자 표시
                      leading: Text(user?.email ?? 'Unknown'),
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
            onPressed: _addPost,
          ),
        ],
      ),
    );
  }
}