import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nasa_app/api/auth_api.dart';
import 'package:nasa_app/models/user_model.dart';
import 'package:nasa_app/widgets/consts.dart';
import 'package:rive/rive.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  bool _isLogin = false;
  bool _isAuthenticating = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController conPassController = TextEditingController();

  Future<void> _submit() async {
    log(MediaQuery.of(context).viewInsets.bottom.toString());

    final isValid = _formkey.currentState!.validate();

    if (!isValid) {
      return;
    }

    FocusScope.of(context).unfocus();

    _formkey.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });

      if (_isLogin) {
        await API.auth.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passController.text.trim());
      } else {
        final userCredentials = await API.auth.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passController.text.trim());

        final userMap = UserModel(
            email: emailController.text.trim(), uid: userCredentials.user!.uid);

        await API.firestore
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set(userMap.toMap());
      }
      setState(() {
        _isAuthenticating = !_isAuthenticating;
        showSnackBar(context, "Welcome, User Your account is Created.");
        Navigator.of(context).pop();
        _isLogin = !_isLogin;
      });
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        setState(() {
          log("error:-----------");
          Navigator.of(context).pop();
          showSnackBar(context, "Email Already in use. Try login In");
        });
      }

      if (error.code == 'invalid-email') {
        setState(() {
          log("error:-----------");
          Navigator.of(context).pop();
          showSnackBar(context, "Invalid Email");
        });
      }

      if (error.code == 'operation-not-allowed' ||
          error.code == 'user-disabled') {
        setState(() {
          log("error:-----------");
          Navigator.of(context).pop();
          showSnackBar(context, "You are banned!.");
        });
      }

      if (error.code == 'user-not-found' ||
          error.code == 'INVALID_LOGIN_CREDENTIALS') {
        setState(() {
          log("error:-----------");
          Navigator.of(context).pop();
          showSnackBar(context, "No such user Exists. Try Creating Account");
        });
      }

      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Form(
      key: _formkey,
      child: Padding(
        padding: EdgeInsets.only(
            left: size.width / 30,
            right: size.width / 30,
            top: size.height / 90,
            bottom:
                size.height / 90 + MediaQuery.of(context).viewInsets.bottom),
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: size.width / 50),
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: size.width / 3),
              width: 100,
              height: size.height / 99,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onBackground,
                  borderRadius: BorderRadius.circular(20)),
            ),
            SizedBox(
              height: size.height / 30,
            ),
            Center(
              child: Text(
                _isLogin ? "Welcome back, User" : "Create Account",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: size.width / 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: size.height / 30,
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: size.width / 30,
                    fontWeight: FontWeight.w400),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                labelText: 'Email Address',
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.background,
                  fontSize: size.width / 20,
                  fontWeight: FontWeight.w700),
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
            ),
            SizedBox(
              height: size.height / 30,
            ),
            TextFormField(
              controller: passController,
              decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: size.width / 30,
                    fontWeight: FontWeight.w400),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                labelText: 'Password',
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
              obscureText: true,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.background,
                  fontSize: size.width / 20,
                  fontWeight: FontWeight.w700),
              validator: (value) {
                if (value == null || value.trim().length < 6) {
                  return 'Password must be aleast 6 characters long';
                }
                return null;
              },
            ),
            if (!_isLogin)
              SizedBox(
                height: size.height / 30,
              ),
            if (!_isLogin)
              TextFormField(
                controller: conPassController,
                decoration: InputDecoration(
                  labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: size.width / 30,
                      fontWeight: FontWeight.w400),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  labelText: 'Confirm Password',
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
                obscureText: true,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: size.width / 20,
                    fontWeight: FontWeight.w700),
                validator: (value) {
                  if ((value == null || value.trim().length < 6) ||
                      (conPassController.text.trim() !=
                          passController.text.trim())) {
                    return 'Password doesn\'t match';
                  }
                  return null;
                },
              ),
            SizedBox(
              height: size.height / 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                fixedSize: Size(size.width / 1.4, size.height / 20),
                shadowColor: Colors.white,
                backgroundColor: Colors.white,
                elevation: 10,
              ),
              onPressed: _isAuthenticating ? () {} : _submit,
              child: _isAuthenticating
                  ? const RiveAnimation.asset(
                      "assets/rive/2.riv",
                      fit: BoxFit.contain,
                    )
                  : Text(
                      _isLogin ? "Login" : "Register",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: size.width / 20,
                          fontWeight: FontWeight.w700),
                    ),
            ),
            TextButton(
              onPressed: _isAuthenticating
                  ? () {}
                  : () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
              child: Text(
                _isLogin ? 'Create an account.' : 'Already have an account?',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: size.width / 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
