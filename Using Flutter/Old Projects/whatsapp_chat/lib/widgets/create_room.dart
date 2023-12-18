import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:whatsapp_chat/providers/users_data_provider.dart';
import 'package:whatsapp_chat/widgets/user_image_picker.dart';

import '../providers/group_data_provider.dart';

class CreateRoom extends ConsumerStatefulWidget {
  const CreateRoom({super.key});

  @override
  ConsumerState<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends ConsumerState<CreateRoom> {
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;
  bool _isCreating = false;
  File? _selectedImage;
  var _enteredTitle = '';
  var _enteredCode = '';

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

  void addToFirebase(String imageUrl) {
    ref.watch(userDataProvider.notifier).getUserData(_auth.uid);
    final userData = ref.watch(userDataProvider);
    // final userData = await _firestore.collection('users').doc(_auth.uid).get();

    Map<String, dynamic> groupData = {
      'admin': [userData['email']],
      'title': _enteredTitle,
      'image_url': imageUrl,
      'code': _enteredCode,
      'users': [userData['email']],
    };
    ref
        .read(groupDataProvider.notifier)
        .setGroupData(groupData, groupCode(_auth.email!, _enteredCode));

    // await _firestore
    //     .collection('group')
    //     .doc(groupCode(_auth.email!, _enteredCode))
    //     .set(groupData);

    List usersGroup = userData['group_joined'];
    setState(() {
      if (!usersGroup.contains(groupCode(userData['email'], _enteredCode))) {
        usersGroup.add(groupCode(userData['email'], _enteredCode));
        userData.update('group_joined', (value) => usersGroup);
      }
    });

    ref.read(userDataProvider.notifier).updateUserData(userData, _auth.uid);
    // await _firestore.collection('users').doc(_auth.uid).update({
    //   'group_joined': usersGroup,
    // });
  }

  void _submit() async {
    final isValid = _formkey.currentState!.validate();

    if (_selectedImage == null) {
      showSnackbar('Select an Image');
      return;
    }

    if (!isValid) {
      return;
    }

    FocusScope.of(context).unfocus();
    _formkey.currentState!.save();

    setState(() {
      _isCreating = true;
    });
    try {
      // ref.watch(imageStorageProvider.notifier).uploadImage(
      //     'group', '${_auth.uid}$_enteredCode.jpg', _selectedImage!);
      // final imageUrl = ref.watch(imageStorageProvider);
      // print(imageUrl);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('group')
          .child('${_auth.uid}$_enteredCode.jpg');

      await storageRef.putFile(_selectedImage!);
      final imageUrl = await storageRef.getDownloadURL();

      final snapshot = await _firestore.collection('group').get();
      if (snapshot.size != 0) {
        ref
            .watch(groupDataProvider.notifier)
            .getGroupDataByValue('code', _enteredCode);
        final matched = ref.watch(groupDataProvider);
        // final matched = await _firestore
        //     .collection('group')
        //     .where('code', isEqualTo: _enteredCode)
        //     .get();

        if (matched.isNotEmpty) {
          setState(() {
            _isCreating = false;
          });
          showSnackbar('Group Already Exist');
          return;
        }
      }
      showSnackbar('Group Created');
      addToFirebase(imageUrl);
      exitCreate();
      setState(() {
        _isCreating = false;
      });
    } catch (e) {
      showSnackbar('Something Went Wrong. Try again Later.');
      exitCreate();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Create Room',
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
                UserImagePicker(
                  onPickedImage: (pickedImage) {
                    _selectedImage = pickedImage;
                  },
                  imagesize: 40,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  enableSuggestions: false,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length < 4) {
                      return 'Please enter valid title';
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredTitle = newValue!;
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
                  onPressed: !_isCreating ? _submit : () {},
                  child: _isCreating
                      ? const SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                          ),
                        )
                      : const Text('Create'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
