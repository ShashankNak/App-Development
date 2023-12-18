import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key, required this.chatRoomCode});

  final String chatRoomCode;
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatRoomCode)
        .collection('chats')
        .add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(children: [
        Expanded(
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            onSubmitted: (value) => _submitMessage(),
            autocorrect: true,
            enableSuggestions: true,

            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(Icons.image),
                onPressed: () {},
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
              disabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              labelText: 'Send a message...',
              labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold),
            ),

            controller: _messageController,
            cursorColor: Colors.black,
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold),
            // style: const TextStyle(
            //     color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          color: Theme.of(context).colorScheme.secondary,
          onPressed: _submitMessage,
          icon: const Icon(Icons.send),
        ),
      ]),
    );
  }
}
