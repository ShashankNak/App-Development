import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_chat/providers/username_provider.dart';
import 'package:whatsapp_chat/widgets/user_image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserFillupScreen extends ConsumerStatefulWidget {
  const UserFillupScreen({super.key});

  @override
  ConsumerState<UserFillupScreen> createState() => _UserFillupScreenState();
}

final _firestore = FirebaseFirestore.instance;
final _firebase = FirebaseAuth.instance;

class _UserFillupScreenState extends ConsumerState<UserFillupScreen> {
  final _formkey = GlobalKey<FormState>();

  var _enteredUsername = '';
  File? _selectedImage;
  bool _isLoading = false;

  void showSnackbar(String s) {
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(s),
      ));
    }
  }

  // void checkData() async {
  //   final userData = await _firestore
  //       .collection('users')
  //       .doc(_firebase.currentUser!.uid)
  //       .get();
  //   if (userData.data() != null || userData.data()!.isNotEmpty) {
  //     setState(() {
  //       _isSubmitted = true;
  //     });
  //   }
  // }

  void _submit() async {
    if (_selectedImage == null) {
      showSnackbar('Profile Image is needed');
      return;
    }

    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();

    _formkey.currentState!.save();

    final data = await _firestore
        .collection('users')
        .where("username", isEqualTo: _enteredUsername)
        .get();
    if (data.docs.isNotEmpty) {
      showSnackbar('Username Already Exist');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('${_firebase.currentUser!.uid}.jpg');

    await storageRef.putFile(_selectedImage!);
    final imageUrl = await storageRef.getDownloadURL();

    await _firestore
        .collection('users')
        .doc(_firebase.currentUser!.uid)
        .update({
      'username': _enteredUsername,
      'image_url': imageUrl,
    });

    setState(() {
      _isLoading = false;
    });

    ref.watch(usernameProvider.notifier).setUsername(true);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  void checkUsername(String value) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              'Create/Edit Profile',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.5),
                  ),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        UserImagePicker(
                          imagesize: 60,
                          onPickedImage: (pickedImage) {
                            _selectedImage = pickedImage;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Username',
                          ),
                          enableSuggestions: false,
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().length < 4) {
                              return 'Please enter valid username';
                            }

                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredUsername = newValue!;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (_isLoading) const CircularProgressIndicator(),
                        if (!_isLoading)
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            child: const Text('submit'),
                          ),
                      ],
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
