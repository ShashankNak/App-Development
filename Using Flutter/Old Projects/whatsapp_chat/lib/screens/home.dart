import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:whatsapp_chat/screens/profile.dart';
import 'package:whatsapp_chat/screens/user_fillup.dart';
import 'package:whatsapp_chat/tabs/group_chat.dart';
import 'package:whatsapp_chat/tabs/search_user.dart';
import 'package:whatsapp_chat/tabs/user_chats.dart';
import 'package:whatsapp_chat/widgets/create_room.dart';
import 'package:whatsapp_chat/widgets/join_room.dart';
import 'package:whatsapp_chat/widgets/menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Setting { edit, profile, logout }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  Setting? selectedMenu;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.uid).update({
      'status': status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (mounted) {
      if (state == AppLifecycleState.resumed) {
        setState(() {
          setStatus("Online");
        });
      } else {
        setState(() {
          setStatus("Offline");
        });
      }
    }
    // final isBg = state == AppLifecycleState.paused;
    // final isClosed = state == AppLifecycleState.detached;
    // final isScreen = state == AppLifecycleState.resumed;
    // if (mounted) {
    //   isBg || isScreen == true || isClosed == false
    //       ? setState(() {
    //           // SET ONLINE
    //           setStatus("Online");
    //         })
    //       : setState(() {
    //           //SET  OFFLINE
    //           setStatus("Offline");
    //         });
    // }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   WidgetsBinding.instance.addObserver(this);
  //   // setStatus("Offline");
  // }

  void showSnackbar(String s) {
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(s),
      ));
    }
  }

  void _userData() async {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.uid)
        .get();
    if (userData.data() == null) {
      return;
    }

    if (userData.data()!['username'] == '') {
      showSnackbar('Create your Profile First');
      return;
    }

    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfileScreen(userData: userData.data()!),
      ),
    );
  }

  void createRoom() async {
    final curUser = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.uid)
        .get();

    if (curUser.data()!['username'] == '') {
      showSnackbar('Create Your Profile First');
      return;
    }

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) {
        return const CreateRoom();
      },
    );
  }

  void joinRoom() async {
    final curUser = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.uid)
        .get();

    if (curUser.data()!['username'] == '') {
      showSnackbar('Create Your Profile First');
      return;
    }

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) {
        return const JoinRoom();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              ImageIcon(
                const AssetImage('assets/images/bot.png'),
                size: 24,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Chat-I/O',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.5),
                    ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                IconButton(
                    tooltip: 'Create',
                    onPressed: createRoom,
                    icon: const Icon(Icons.create)),
                const SizedBox(
                  width: 6,
                ),
                IconButton(
                  tooltip: 'Join Room',
                  onPressed: joinRoom,
                  icon: const Icon(Icons.join_inner_sharp),
                ),
                const SizedBox(
                  width: 6,
                ),
                PopupMenuButton(
                  initialValue: selectedMenu,
                  onSelected: (Setting value) {
                    if (value == Setting.edit) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const UserFillupScreen(),
                      ));
                    }

                    if (value == Setting.profile) {
                      _userData();
                    }

                    if (value == Setting.logout) {
                      setState(() {
                        setStatus("Offline");
                      });
                      FirebaseAuth.instance.signOut();
                      // Navigator.of(context).pushAndRemoveUntil(
                      //     MaterialPageRoute(
                      //       builder: (context) => const AuthScreen(),
                      //     ),
                      //     (route) => false);
                    }
                  },
                  itemBuilder: (context) => <PopupMenuEntry<Setting>>[
                    const PopupMenuItem<Setting>(
                        value: Setting.edit,
                        child: MenuIconBar(menuItem: Setting.edit)),
                    const PopupMenuItem<Setting>(
                        value: Setting.profile,
                        child: MenuIconBar(menuItem: Setting.profile)),
                    const PopupMenuItem<Setting>(
                        value: Setting.logout,
                        child: MenuIconBar(menuItem: Setting.logout))
                  ],
                )
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(Icons.more_vert_rounded),
                //   color: Theme.of(context).colorScheme.onBackground,
                // ),
              ],
            ),
          ],
          bottom: const TabBar(isScrollable: false, tabs: [
            Tab(
              icon: Icon(Icons.chat),
              child: Center(
                child: Text('Chat'),
              ),
            ),
            Tab(
              icon: Icon(Icons.group),
              child: Center(
                child: Text('Group'),
              ),
            ),
            Tab(
              icon: Icon(Icons.search),
              child: Center(
                child: Text('Search'),
              ),
            ),
          ]),
        ),
        body: const TabBarView(viewportFraction: 0.97, children: <Widget>[
          UserChatsTab(),
          GroupChat(),
          SearchUserTab(),
        ]),
      ),
    );
  }
}
