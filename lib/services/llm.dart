import 'package:flutter/material.dart';
import 'package:hackathon/services/geminiservice.dart';
import 'package:hackathon/services/sharedpref.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? name;
  GeminiService? _geminiService;
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    name = await SharedPreferenceHelper().getUserName();
    _geminiService =
        GeminiService(userName: name ?? "User"); // Default to "User" if null
    setState(() {});
  }

  void _sendMessage() async {
    if (_geminiService == null) {
      _messages.add(ChatMessage(
          text: "Error: Service not initialized.", isUserMessage: false));
      setState(() {});
      return;
    }

    String message = _textController.text.trim();
    _textController.clear();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(text: message, isUserMessage: true));
        _isLoading = true;
      });
      try {
        final geminiResponse = await _geminiService!.sendMessage(message);
        setState(() {
          _messages.add(ChatMessage(
              text: geminiResponse ?? "Error occurred.", isUserMessage: false));
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _messages.add(ChatMessage(text: "Error: $e", isUserMessage: false));
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            SizedBox(width: 30),
            Icon(Icons.chat_bubble_outline_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text('ReliefLink Assistant',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                )),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: Colors.black),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Enter your query...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.message, color: Colors.black),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  backgroundColor: Colors.black,
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUserMessage;

  const ChatMessage({Key? key, required this.text, required this.isUserMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isUserMessage ? Colors.grey[300] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUserMessage)
            const Icon(Icons.android, color: Colors.black, size: 24),
          if (!isUserMessage) const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: isUserMessage ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
