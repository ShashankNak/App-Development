// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:whatsapp_chat/providers/group_list_provider.dart';
// import 'package:whatsapp_chat/providers/users_data_provider.dart';
import 'package:whatsapp_chat/screens/group_room.dart';

class GroupChat extends ConsumerStatefulWidget {
  const GroupChat({super.key});

  @override
  ConsumerState<GroupChat> createState() => _GroupChatState();
}

final _auth = FirebaseAuth.instance;

class _GroupChatState extends ConsumerState<GroupChat> {
  List<Map<String, dynamic>> listOfgroupData = [];

  String generateCode(String user, String code) {
    return "$user$code";
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initialData();
    });
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
          .collection('group')
          .where('users', arrayContains: userMap['email'])
          .get();
      setState(() {
        listOfgroupData = userDataList.docs.map((e) => e.data()).toList();
      });
      // ref
      //     .watch(groupDataListProvider.notifier)
      //     .getGroupDataList('users', userMap['email']);
      // setState(() {
      //   listOfgroupData = ref.watch(groupDataListProvider);
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
      child: listOfgroupData.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    final roomCode = generateCode(
                        listOfgroupData[index]['admin'][0],
                        listOfgroupData[index]['code']);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => GroupRoomScreen(
                            groupData: listOfgroupData[index],
                            roomCode: roomCode),
                      ),
                    );
                  },
                  leading: GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      foregroundImage:
                          NetworkImage(listOfgroupData[index]['image_url']),
                    ),
                  ),
                  title: Text(
                    listOfgroupData[index]['title'],
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );
              },
              itemCount: listOfgroupData.length,
              padding: const EdgeInsets.all(10),
            )
          : const Center(
              child: Text('No Group Yet'),
            ),
    );
  }
}
