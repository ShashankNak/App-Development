import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JoinRoom extends StatefulWidget {
  const JoinRoom({super.key});

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  final _formkey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredCode = '';
  bool _isJoining = false;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String groupCode(String user, String code) {
    return '$user$code';
  }

  void exitCreate() {
    Navigator.of(context).pop();
  }

  void showSnackbar(String s) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(s),
    ));
  }

  void _submit() async {
    final isValid = _formkey.currentState!.validate();

    if (!isValid) {
      return;
    }

    FocusScope.of(context).unfocus();
    _formkey.currentState!.save();

    setState(() {
      _isJoining = true;
    });
    try {
      final group = await _firestore
          .collection('group')
          .where('admin', arrayContains: _enteredEmail)
          .where('code', isEqualTo: _enteredCode)
          .get();

      final userData = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      if (group.docs.isEmpty) {
        setState(() {
          _isJoining = false;
        });
        showSnackbar("No such group exist");
        return;
      }

      List users = group.docs[0].data()['users'];
      if (users.contains(userData.data()!['email'])) {
        showSnackbar("You are already a member");
        exitCreate();
        return;
      }
      users.add(userData.data()!['email']);

      List usersGroup = userData.data()!['group_joined'];
      if (!usersGroup.contains(groupCode(_enteredEmail, _enteredCode))) {
        usersGroup.add(groupCode(_enteredEmail, _enteredCode));
      }

      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'group_joined': usersGroup,
      });

      await _firestore
          .collection('group')
          .doc('$_enteredEmail$_enteredCode')
          .update({
        'users': users,
      });
    } catch (e) {
      showSnackbar("Something went Wrong. Try again later.");
      exitCreate();
      return;
    }
    setState(() {
      _isJoining = false;
    });
    showSnackbar("Group Joined");
    exitCreate();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Join Room',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      content: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 10, top: 10, left: 30, right: 30),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Group Admin Email',
                  ),
                  enableSuggestions: false,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length < 4) {
                      return 'Please enter valid email';
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredEmail = newValue!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Code',
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return 'Code must be aleast 6 characters long';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredCode = newValue!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: !_isJoining ? _submit : () {},
                  child: _isJoining
                      ? const SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                          ),
                        )
                      : const Text('Join'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
