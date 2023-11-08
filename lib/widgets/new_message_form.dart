import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessageForm extends StatefulWidget {
  const NewMessageForm({super.key});

  @override
  State<NewMessageForm> createState() => _NewMessageFormState();
}

class _NewMessageFormState extends State<NewMessageForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();

  //dispose
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    //removes keyboard
    FocusScope.of(context).unfocus();

    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      "created_at": Timestamp.now(),
      'message': _messageController.text,
      'user_id': user.uid,
      'username': userData.data()!["username"],
      'user_image': userData.data()!["image_url"],
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 1,
        bottom: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: TextFormField(
                autocorrect: true,
                controller: _messageController,
                enableSuggestions: true,
                decoration: const InputDecoration(
                  labelText: 'Send a message...',
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) =>
                    value!.trim().isEmpty ? 'Please enter a message' : null,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: _validateAndSubmit,
          ),
        ],
      ),
    );
  }
}
