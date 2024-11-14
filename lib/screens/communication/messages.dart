import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  // Sample list of conversations
  final List<Map<String, String>> _conversations = [
    {
      "name": "Jane Doe",
      "lastMessage": "Thank you, doctor!",
      "time": "10:30 AM",
    },
    {
      "name": "John Smith",
      "lastMessage": "When should I come for the follow-up?",
      "time": "9:45 AM",
    },
    {
      "name": "Alice Johnson",
      "lastMessage": "Please confirm my appointment time.",
      "time": "Yesterday",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildConversationList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _composeNewMessage,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.message),
      ),
    );
  }

  // Builds the list of conversations
  Widget _buildConversationList() {
    return ListView.builder(
      itemCount: _conversations.length,
      itemBuilder: (context, index) {
        final conversation = _conversations[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text(
                conversation["name"]![0], // Initial of the name
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(conversation["name"]!),
            subtitle: Text(conversation["lastMessage"]!),
            trailing: Text(
              conversation["time"]!,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            onTap: () {
              _openConversation(conversation["name"]!);
            },
          ),
        );
      },
    );
  }

  // Opens a new message composition screen
  void _composeNewMessage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewMessagePage(),
      ),
    );
  }

  // Opens the conversation screen with selected contact
  void _openConversation(String contactName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationPage(contactName: contactName),
      ),
    );
  }
}

// Page for composing a new message
class NewMessagePage extends StatelessWidget {
  final TextEditingController _messageController = TextEditingController();

  NewMessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Message"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "To",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Message",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Send message logic here
                Navigator.pop(context);
              },
              child: const Text("Send"),
            ),
          ],
        ),
      ),
    );
  }
}

// Page for viewing a conversation with a specific contact
class ConversationPage extends StatelessWidget {
  final String contactName;
  final TextEditingController _messageController = TextEditingController();

  ConversationPage({Key? key, required this.contactName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contactName),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(context),
        ],
      ),
    );
  }

  // Builds the list of messages in the conversation
  Widget _buildMessageList() {
    // Sample messages for the conversation
    final List<Map<String, String>> messages = [
      {"sender": "Me", "message": "Hello, how can I help you?"},
      {"sender": contactName, "message": "I have a question about my treatment."},
      {"sender": "Me", "message": "Sure, go ahead!"},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        bool isMe = message["sender"] == "Me";
        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue[100] : Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(message["message"]!),
          ),
        );
      },
    );
  }

  // Builds the message input field
  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              // Send message logic here
              _messageController.clear();
            },
          ),
        ],
      ),
    );
  }
}

