import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/widgets.dart';

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy("created_at", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }

        final loadedMessages = snapshot.data!.docs;

        if (!snapshot.hasData || loadedMessages.isEmpty) {
          return const Center(
            child: Text("No messages found"),
          );
        }

        return ListView.builder(
          itemCount: loadedMessages.length,
          itemBuilder: (context, index) {
            try {
              final message = loadedMessages[index]["message"] as String;
              final nextMessage = index + 1 < loadedMessages.length
                  ? loadedMessages[index + 1]["message"] as String
                  : null;

              final currentMessageUserId =
                  loadedMessages[index]["user_id"] as String;
              final nextMessageUserId = nextMessage != null
                  ? loadedMessages[index + 1]["user_id"] as String
                  : null;
              final nextUserIsSame = currentMessageUserId == nextMessageUserId;

              if (nextUserIsSame) {
                return ChatMessageListItem.next(
                  message: message,
                  isMe: user!.uid == currentMessageUserId,
                );
              } else {
                return ChatMessageListItem.first(
                  userImage: loadedMessages[index]["user_image"],
                  username: loadedMessages[index]["username"],
                  message: message,
                  isMe: user!.uid == currentMessageUserId,
                );
              }
            } catch (error) {
              developer.log(
                "Error processing message at index $index: $error",
                name: "ChatMessageList",
              );
              return const SizedBox(); // or any placeholder widget
            }
          },
          padding: const EdgeInsets.only(
            bottom: 20,
            left: 12,
            right: 12,
          ),
          reverse: true,
        );
      },
    );
  }
}
