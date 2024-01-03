// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:whatsapp_chat/providers/user_list_provider.dart';
import 'package:whatsapp_chat/providers/users_data_provider.dart';

class SearchUserTab extends ConsumerStatefulWidget {
  const SearchUserTab({super.key});

  @override
  ConsumerState<SearchUserTab> createState() => _SearchUserTabState();
}

class _SearchUserTabState extends ConsumerState<SearchUserTab> {
  bool _isloading = false;
  final _emailController = TextEditingController();
  Map<String, dynamic>? userMap;
  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void showSnackbar(String s) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(s),
    ));
  }

  void _addUser() {
    try {
      if (userMap == null) {
        return;
      }

      ref.read(userDataProvider.notifier).getUserData(_auth.currentUser!.uid);
      final currentUserData = ref.read(userDataProvider);

      // print(currentUserData.data());

      final List listOfUser = currentUserData['connected_users'];
      final List listOfUserofOther = userMap!['connected_users'];
      if (listOfUser.contains(userMap!['email'])) {
        showSnackbar("user Already Added");
        setState(() {
          userMap = null;
        });
        return;
      }

      setState(() {
        listOfUser.add(userMap!['email']);
        listOfUserofOther.add(currentUserData['email']);

        userMap!.update('connected_users', (value) => listOfUserofOther);
        currentUserData.update('connected_users', (value) => listOfUser);
      });

      ref
          .watch(userDataProvider.notifier)
          .updateUserData(userMap!, userMap!['uid']);
      ref
          .watch(userDataProvider.notifier)
          .updateUserData(currentUserData, currentUserData['uid']);
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(userMap!['uid'])
      //     .update();

      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(_auth.currentUser!.uid)
      //     .update({'connected_users': listOfUser});

      showSnackbar("User Added");
      setState(() {
        userMap = null;
      });
    } catch (e) {
      return;
    }
  }

  void _submitMessage() async {
    FocusScope.of(context).unfocus();
    final curUser = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();

    if (curUser.data()!['username'] == '') {
      showSnackbar('Create Your Profile First');
      return;
    }

    final enteredUsername = _emailController.text;
    _emailController.clear();
    if (enteredUsername == '') {
      return;
    }

    setState(() {
      _isloading = true;
    });
    // ref
    //     .watch(userDataListProvider.notifier)
    //     .getUserDataList('email', enteredEmail);
    // final userSnapshot = ref.read(userDataListProvider);
    final userSnapShot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: enteredUsername)
        .get();

    if (userSnapShot.docs.isEmpty) {
      setState(() {
        _isloading = false;
      });
      return;
    }

    setState(() {
      userMap = userSnapShot.docs[0].data();
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: _isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: (value) => _submitMessage(),
                          autocorrect: true,
                          enableSuggestions: true,
                          decoration: InputDecoration(
                            disabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: 'Search...',
                            labelStyle: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.bold),
                          ),

                          controller: _emailController,
                          cursorColor: Colors.white,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.bold),
                          // style: const TextStyle(
                          //     color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: _submitMessage,
                        icon: Icon(Icons.search,
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                    ],
                  ),
                ),
                userMap != null
                    ? ListTile(
                        onTap: () {},
                        leading: CircleAvatar(
                            foregroundImage: NetworkImage(
                          userMap!['image_url'],
                        )),
                        title: Text(
                          userMap!['username'],
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          userMap!['email'],
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        trailing: GestureDetector(
                            onTap: _addUser, child: const Icon(Icons.add)),
                      )
                    : const Center(
                        child: Text('No such Users'),
                      ),
              ],
            ),
    );
  }
}
