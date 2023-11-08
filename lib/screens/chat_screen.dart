import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_chat/widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();

  void _setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    // final String? token = await fcm.getToken();
    // print("Token: $token");
    fcm.subscribeToTopic("chat");
  }
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    widget._setupPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        title: const Text("Chat"),
      ),
      body: const Column(
        children: [
          Expanded(
            child: ChatMessageList(),
          ),
          Divider(),
          NewMessageForm(),
        ],
      ),
    );
  }
}
