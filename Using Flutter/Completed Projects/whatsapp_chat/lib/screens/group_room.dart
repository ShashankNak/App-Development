import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_chat/providers/user_provider.dart';
import 'package:whatsapp_chat/widgets/chat_messages.dart';
import 'package:whatsapp_chat/widgets/drawer.dart';
import 'package:whatsapp_chat/widgets/group_profile.dart';
import 'package:whatsapp_chat/widgets/new_message.dart';

class GroupRoomScreen extends ConsumerWidget {
  const GroupRoomScreen(
      {super.key, required this.groupData, required this.roomCode});

  final Map<String, dynamic> groupData;
  final String roomCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            ref.watch(userProvider.notifier).getUserData(groupData);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => GroupProfile(groupData: groupData),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                foregroundImage: NetworkImage(groupData['image_url']),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(groupData['title']),
            ],
          ),
        ),
      ),
      endDrawer: GroupDrawer(groupData: groupData),
      body: Column(children: [
        Expanded(
          child: ChatMessages(chatRoomCode: roomCode),
        ),
        NewMessage(chatRoomCode: roomCode),
      ]),
    );
  }
}
