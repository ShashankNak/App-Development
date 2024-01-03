import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_chat/widgets/drawer_tile.dart';

class GroupDrawer extends StatefulWidget {
  const GroupDrawer({super.key, required this.groupData});
  final Map<String, dynamic> groupData;

  @override
  State<GroupDrawer> createState() => _GroupDrawerState();
}

class _GroupDrawerState extends State<GroupDrawer> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>>? userInfo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initData();
    });
  }

  void initData() async {
    List<Map<String, dynamic>> userDataList = [];

    for (String user in widget.groupData['users']) {
      final userData = await _firestore
          .collection('users')
          .where('email', isEqualTo: user)
          .get();

      setState(() {
        if (userData.docs[0].data()['uid'] != _auth.currentUser!.uid) {
          userDataList.add(userData.docs[0].data());
        }
      });
    }
    setState(() {
      userInfo = userDataList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const SizedBox(
          height: 50,
        ),
        Text(
          "User Status",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        ),
        userInfo != null
            ? Expanded(
                child: ListView.builder(
                    itemBuilder: (context, index) =>
                        GroupDrawerTile(userData: userInfo![index]),
                    itemCount: userInfo!.length),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ]),
    );
  }
}
