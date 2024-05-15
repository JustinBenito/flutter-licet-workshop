import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(ChatGPTApp());
}

class ChatGPTApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT Dark Mode',
      theme: ThemeData.dark(),
      home: ChatGPTScreen(),
    );
  }
}

class ChatGPTScreen extends StatefulWidget {
  @override
  _ChatGPTScreenState createState() => _ChatGPTScreenState();
}

class _ChatGPTScreenState extends State<ChatGPTScreen> {
  TextEditingController _messageController = TextEditingController();
  String _responseMessage = 'Ask Me Something bruh';

  Future<void> _sendMessage() async {
    setState(() {
      _responseMessage = 'Loading...';
    });

    final String apiKey = 'your open ai key';
    final String apiUrl = 'https://api.openai.com/v1/chat/completions';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          "messages": [
      {
        "role": "system",
        "content": "You are a helpful assistant."
      },
      {
        "role": "user",
        "content": _messageController.text
      }
    ]
        }),
      );

      debugPrint(response.body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _responseMessage = responseData['choices'][0]['message']['content'];
        });
      } else {
        setState(() {
          _responseMessage = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = 'Exception: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatGPT'),
      ),
      body: Column(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: _responseMessage.isNotEmpty ? Expanded(
              child: Text(
                _responseMessage,
                style: TextStyle(fontSize: 16.0),
              ),
            ) : CircularProgressIndicator()
            
      ),
    ),
    SizedBox(height: 20),
     Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensuring space between input field and button
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
              ),
            ),
          ),
          SizedBox(width: 10), // Adding space between input field and button
          IconButton(
            color: Colors.greenAccent,
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    ),
    
  ],
),

    );
  }
}
