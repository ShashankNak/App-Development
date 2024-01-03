import 'package:amazon_clone/login/create_account.dart';
import 'package:amazon_clone/login/sign_in.dart';
import 'package:amazon_clone/widget/custom_appbar.dart';
import 'package:flutter/material.dart';

enum UserAccount { newUser, oldUser }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.uAccount});
  final UserAccount uAccount;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserAccount? userAccount;

  @override
  void initState() {
    super.initState();
    userAccount = widget.uAccount;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppbar(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Welcome",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: size.width / 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Card(
                elevation: 1,
                margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    side: BorderSide(width: 1, color: Colors.grey)),
                child: Column(
                  children: [
                    ListTile(
                      tileColor: userAccount == UserAccount.newUser
                          ? Colors.white
                          : const Color.fromARGB(255, 217, 217, 217),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Colors.grey),
                      ),
                      title: Row(
                        children: [
                          Transform.scale(
                            scale: 1.5,
                            child: Radio<UserAccount>(
                              activeColor: Colors.amber.shade700,
                              value: UserAccount.newUser,
                              groupValue: userAccount,
                              onChanged: (UserAccount? value) {
                                setState(() {
                                  userAccount = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: size.width / 90,
                          ),
                          const Text(
                            "Create account.",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text("New to Amazon?")
                        ],
                      ),
                      subtitle: userAccount != UserAccount.newUser
                          ? null
                          : const CreateAccountFields(),
                    ),
                    ListTile(
                      tileColor: userAccount == UserAccount.oldUser
                          ? Colors.white
                          : const Color.fromARGB(255, 217, 217, 217),
                      selectedTileColor: Colors.white,
                      title: Row(
                        children: [
                          Transform.scale(
                            scale: 1.5,
                            child: Radio<UserAccount>(
                              activeColor: Colors.amber.shade700,
                              value: UserAccount.oldUser,
                              groupValue: userAccount,
                              onChanged: (UserAccount? value) {
                                setState(() {
                                  userAccount = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: size.width / 90,
                          ),
                          const Text(
                            "Sign in.",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text("Already a Customer?")
                        ],
                      ),
                      subtitle: userAccount != UserAccount.oldUser
                          ? null
                          : const SignInFields(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
