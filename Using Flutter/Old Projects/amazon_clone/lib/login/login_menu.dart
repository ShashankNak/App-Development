import 'package:amazon_clone/const/snackbar.dart';
import 'package:amazon_clone/login/create_account.dart';
import 'package:amazon_clone/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/home_screen.dart';
import '../widget/custom_button.dart';

class LoginMenu extends StatelessWidget {
  const LoginMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height / 10,
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 30, bottom: 20, left: 20, right: 20),
                  width: 250,
                  child: Image.asset('assets/images/amazon_logo.png',
                      fit: BoxFit.cover),
                ),
                SizedBox(
                  height: size.height / 80,
                ),
                const Text(
                  "Sign in to your account",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: size.height / 90,
                ),
                const Text(
                  "View you wish list\nFind & reorder past purchases\nTracke your purchases",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
                SizedBox(
                  height: size.height / 40,
                ),
                CustomButton(
                  function: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const LoginScreen(uAccount: UserAccount.oldUser),
                    ));
                  },
                  color: const Color.fromARGB(255, 255, 193, 70),
                  text: "Already a customer? Sign in",
                  borderColor: const Color.fromARGB(255, 255, 111, 0),
                ),
                SizedBox(
                  height: size.height / 70,
                ),
                CustomButton(
                  function: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const LoginScreen(uAccount: UserAccount.newUser),
                    ));
                  },
                  color: const Color.fromARGB(255, 192, 192, 192),
                  text: "New to Amazon.in? Create an account",
                  borderColor: const Color.fromARGB(255, 102, 102, 102),
                ),
                SizedBox(
                  height: size.height / 70,
                ),
                CustomButton(
                  function: () async {
                    if (ap.isSignedIn) {
                      await ap.getDataFromSP().whenComplete(
                          () => Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                              (route) => false));
                    } else {
                      showSnackBar(context, "You haven't signed in yet");
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginScreen(uAccount: UserAccount.oldUser),
                        ),
                      );
                    }
                  },
                  color: const Color.fromARGB(255, 192, 192, 192),
                  text: "Skip sign in",
                  borderColor: const Color.fromARGB(255, 102, 102, 102),
                ),
                SizedBox(
                  height: size.height / 70,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
