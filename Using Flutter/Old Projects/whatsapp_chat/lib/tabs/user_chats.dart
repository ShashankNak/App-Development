import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:whatsapp_chat/providers/user_list_provider.dart';
// import 'package:whatsapp_chat/providers/users_data_provider.dart';
import 'package:whatsapp_chat/screens/chat_room.dart';
import 'package:whatsapp_chat/screens/profile.dart';

class UserChatsTab extends ConsumerStatefulWidget {
  const UserChatsTab({super.key});

  @override
  ConsumerState<UserChatsTab> createState() => _UserChatsTabState();
}

final _auth = FirebaseAuth.instance;

class _UserChatsTabState extends ConsumerState<UserChatsTab> {
  List<Map<String, dynamic>> userListData = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initialData();
    });
  }

  String chatRoomCode(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void initialData() async {
    try {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      final userMap = userData.data()!;
      // ref.watch(userDataProvider.notifier).getUserData(_auth.currentUser!.uid);
      // final userMap = ref.watch(userDataProvider);

      if (userMap.isEmpty) {
        return;
      }

      final userDataList = await FirebaseFirestore.instance
          .collection('users')
          .where('connected_users', arrayContains: userMap['email'])
          .get();

      setState(() {
        userListData = userDataList.docs.map((e) => e.data()).toList();
      });

      // ref
      //     .watch(userDataListProvider.notifier)
      //     .getUserDataListArray('connected_users', userMap['email']);
      // final listofUser = ref.watch(userDataListProvider);

      // setState(() {
      //   userListData = listofUser;
      // });
    } catch (e) {
      // _auth.signOut();
    }
  }

  Future refresh() async {
    initialData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: userListData.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    final roomCode = chatRoomCode(
                        _auth.currentUser!.uid, userListData[index]['uid']);

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChatRoomScreen(
                          user2Data: userListData[index],
                          chatRoomCode: roomCode),
                    ));
                  },
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(userData: userListData[index]),
                      ));
                    },
                    child: CircleAvatar(
                      foregroundImage:
                          NetworkImage(userListData[index]['image_url']),
                    ),
                  ),
                  title: Text(
                    userListData[index]['username'],
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    userListData[index]['email'],
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.5)),
                  ),
                );
              },
              itemCount: userListData.length,
            )
          : const Center(
              child: Text('No Chats Yet'),
            ),
    );
  }
}
