import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy("created_at", descending: false)
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
            return Text(loadedMessages[index]["message"]);
          },
        );
      },
    );
  }
}
