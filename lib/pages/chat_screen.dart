import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(_controller.text);
        _controller.clear();
      });
    }
  }

  String? conversationId; // Add this to manage the conversation

// Add this to store the conversation ID
  String? _conversationId;

// Function to create a conversation
  Future<void> _createConversation() async {
    final String botpressApiUrl = 'https://api.botpress.cloud/v1/chat/conversations';
    final String botId = '793d92eb-b0ce-4fe1-bcd5-a2e61312988f'; // Replace with your Bot ID
    final String token = 'bp_pat_YuxOLm3aTKEKFZD7cW3fpxfNkzirbnx7Nhr7'; // Replace with your token

    try {
      final response = await http.post(
        Uri.parse(botpressApiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'x-bot-id': botId,
        },
        body: json.encode({
          'tags': {},
          'integrationName': 'webchat',
          'channel': 'channel-web',// Optional tags; provide an empty object if not used
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        setState(() {
          _conversationId = data['id'];
        });
      } else {
        print('Error creating conversation: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _sendAiMessage(String userMessage) async {
    if (_conversationId == null) {
      await _createConversation();
      if (_conversationId == null) {
        print('Failed to create a conversation.');
        return;
      }
    }

    final String botpressApiUrl =
        'https://api.botpress.cloud/v1/chat/conversations/$_conversationId/messages';
    final String botId = '793d92eb-b0ce-4fe1-bcd5-a2e61312988f'; // Replace with your Bot ID
    final String token = 'bp_pat_YuxOLm3aTKEKFZD7cW3fpxfNkzirbnx7Nhr7'; // Replace with your token

    try {
      // Send a message to the bot
      final response = await http.post(
        Uri.parse(botpressApiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'x-bot-id': botId,
        },
        body: json.encode({
          'type': 'text',
          'text': userMessage,
          'integrationName': 'webchat',
          'channel': 'webchat',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Optionally, you can process the response here
        // Get the bot's response
        await _getBotResponse();
      } else {
        print('Error sending message: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _getBotResponse() async {
    final String botpressApiUrl =
        'https://api.botpress.cloud/v1/chat/conversations/$_conversationId/messages';
    final String botId = '793d92eb-b0ce-4fe1-bcd5-a2e61312988f'; // Replace with your Bot ID
    final String token = 'bp_pat_YuxOLm3aTKEKFZD7cW3fpxfNkzirbnx7Nhr7'; // Replace with your token

    try {
      final response = await http.get(
        Uri.parse(botpressApiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'x-bot-id': botId,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final messages = data['messages'] as List;

        // Find the latest message from the bot
        final botMessages = messages.where((msg) => msg['authorId'] == 'bot').toList();
        if (botMessages.isNotEmpty) {
          final botMessage = botMessages.last['payload']['text'];
          setState(() {
            _messages.add(botMessage);
          });
        }
      } else {
        print('Error retrieving messages: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }




  @override
  void initState() {
    super.initState();
    _createConversation();
    _messages.add('What can I help you with?');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: _messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    final userMessage = _controller.text.trim();
                    if (userMessage.isNotEmpty) {
                      setState(() {
                        _messages.add(userMessage);
                        _controller.clear();
                      });
                      await _sendAiMessage(userMessage);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({Key? key, required this.message, this.isUser = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.greenAccent : Colors.blueAccent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
