import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  String _reviewText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Review'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: TextFormField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                labelText: 'Write your review here',
                contentPadding: EdgeInsets.all(20),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _reviewText = value;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewPage()));
            },
            child: Text('평가 하러 가기'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
