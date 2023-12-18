import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_chat/screens/profile.dart';
import 'package:whatsapp_chat/widgets/chat_messages.dart';
import 'package:whatsapp_chat/widgets/new_message.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen(
      {super.key, required this.user2Data, required this.chatRoomCode});

  final Map<String, dynamic> user2Data;
  final String chatRoomCode;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  Color statusColor = Colors.white54;
  Color colorChange(String status) {
    if (status == "Online") {
      statusColor = Colors.green.shade700;
    } else {
      statusColor = Colors.white54;
    }
    return statusColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.user2Data['uid'])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return SizedBox(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(userData: widget.user2Data),
                    ));
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        foregroundImage:
                            NetworkImage(widget.user2Data['image_url']),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text(
                            widget.user2Data['username'],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 5,
                                backgroundColor:
                                    colorChange(snapshot.data!['status']),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                snapshot.data!['status'],
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                        color: colorChange(
                                            snapshot.data!['status'])),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
        // title:
      ),
      body: Column(children: [
        Expanded(
          child: ChatMessages(chatRoomCode: widget.chatRoomCode),
        ),
        NewMessage(
          chatRoomCode: widget.chatRoomCode,
        ),
      ]),
    );
  }
}
