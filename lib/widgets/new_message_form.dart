import 'package:flutter/material.dart';

class NewMessageForm extends StatefulWidget {
  const NewMessageForm({super.key});

  @override
  State<NewMessageForm> createState() => _NewMessageFormState();
}

class _NewMessageFormState extends State<NewMessageForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _messageController = TextEditingController();

  //dispose
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    print(_messageController.text);

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
