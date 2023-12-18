import 'dart:io';

import 'package:chat_app/widgets/home_text.dart';
import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formkey = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _isAuthenticating = false;
  var _enteredUsername = '';

  File? _selectedImage;

  void _submit() async {
    final isValid = _formkey.currentState!.validate();

    if (!isValid || !_isLogin && _selectedImage == null) {
      return;
    }

    FocusScope.of(context).unfocus();

    _formkey.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });

      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'image_url': imageUrl,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        //
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed'),
        ),
      );

      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 30, bottom: 20, left: 20, right: 20),
                width: 200,
                child:
                    Image.asset('assets/images/chat_3.png', fit: BoxFit.cover),
              ),
              const HomeText(),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            if (!_isLogin)
                              UserImagePicker(
                                onPickedImage: (pickedImage) {
                                  _selectedImage = pickedImage;
                                },
                              ),
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                ),
                                enableSuggestions: false,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
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
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Email Address'),
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please Enter a valid email address';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enteredEmail = newValue!;
                              },
                            ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Password'),
                              obscureText: true,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return 'Password must be aleast 6 characters long';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enteredPassword = newValue!;
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            if (_isAuthenticating)
                              const CircularProgressIndicator(),
                            if (!_isAuthenticating)
                              ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                                child: Text(_isLogin ? 'Login' : 'Sign Up'),
                              ),
                            if (!_isAuthenticating)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(_isLogin
                                    ? 'Create an account'
                                    : 'Already have an account'),
                              ),
                          ],
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
