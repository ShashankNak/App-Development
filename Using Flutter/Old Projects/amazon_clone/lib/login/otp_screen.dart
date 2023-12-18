import 'package:amazon_clone/const/snackbar.dart';
import 'package:amazon_clone/const/user_model.dart';
import 'package:amazon_clone/providers/auth_provider.dart';
import 'package:amazon_clone/screens/home_screen.dart';
import 'package:amazon_clone/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String name;
  final String password;
  const OtpScreen(
      {super.key,
      required this.verificationId,
      required this.phoneNumber,
      required this.name,
      required this.password});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool isTyped = false;
  final TextEditingController otpController = TextEditingController();

  void verifyOtp(BuildContext context, String userOtp) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    ap.verifyOtp(
        context: context,
        verificationId: widget.verificationId,
        userOtp: userOtp,
        onSuccess: () {
          ap.checkExistingUser().then((value) async {
            if (value) {
            } else {
              UserModel userModel = UserModel(
                  uid: ap.uid,
                  name: widget.name,
                  password: widget.password,
                  phoneNumber: widget.phoneNumber,
                  email: "");
              ap.saveUserDataToFirebase(
                  context: context,
                  userModel: userModel,
                  onSuccess: () {
                    ap.saveUserDataToSP().then((value) => ap.setSignIn().then(
                        (value) => Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (route) => false)));
                  });
            }
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 207, 207, 207),
      body: SafeArea(
        child: SingleChildScrollView(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Material(
                      elevation: 5,
                      color: const Color.fromARGB(255, 230, 230, 230),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomAppbar(),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              "Verify mobile number",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: Colors.black,
                                      fontSize: size.width / 14,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: size.height / 80,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 1, left: 15, right: 15, bottom: 10),
                            child: Text(
                              widget.phoneNumber,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Colors.black,
                                      fontSize: size.width / 27,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 1, left: 15, right: 15),
                            child: Text(
                              "A SMS with a One Time Password (OTP) has been sent to the number above.",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: Colors.black,
                                      fontSize: size.width / 22,
                                      fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            height: size.height / 80,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: size.width / 1.09,
                              child: TextField(
                                controller: otpController,
                                maxLength: 6,
                                onChanged: (value) {
                                  setState(() {
                                    isTyped = value.isNotEmpty;
                                  });
                                },
                                keyboardType: TextInputType.name,
                                showCursor: true,
                                autocorrect: false,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  suffixIcon: isTyped
                                      ? GestureDetector(
                                          onTap: () {
                                            otpController.clear();
                                          },
                                          child: const Icon(
                                            Icons.cancel,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : null,
                                  hintText: "Enter OTP",
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    borderSide: const BorderSide(
                                        width: 1.5,
                                        color:
                                            Color.fromARGB(143, 33, 208, 243)),
                                    gapPadding: size.width / 99,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    borderSide: const BorderSide(
                                        width: 1.5, color: Colors.black),
                                    gapPadding: size.width / 99,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height / 80,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
                                if (otpController.text.trim().length == 6) {
                                  verifyOtp(context, otpController.text.trim());
                                } else {
                                  showSnackBar(context, "Enter 6-Digit Code");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 10,
                                backgroundColor: Colors.amber.shade400,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                fixedSize:
                                    Size(size.width / 1.09, size.height / 16),
                              ),
                              child: const Text(
                                "Create your Amazon account",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height / 80,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, right: 16),
                            child: RichText(
                              text: const TextSpan(
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                  children: [
                                    TextSpan(
                                        text:
                                            "By creating an account or logging in, you agree to Amazon's "),
                                    TextSpan(
                                        text: "Conditions of Use ",
                                        style: TextStyle(color: Colors.blue)),
                                    TextSpan(text: "and "),
                                    TextSpan(
                                        text: "Privacy Policy",
                                        style: TextStyle(color: Colors.blue)),
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: size.height / 80,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                elevation: 1,
                                alignment: Alignment.centerLeft,
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                fixedSize:
                                    Size(size.width / 1.09, size.height / 16),
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Resend OTP",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Icon(Icons.keyboard_arrow_right)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height / 15,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Conditions of Use",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "Privacy Notice",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "Help",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height / 80,
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "1996-2023, Amazon.com, Inc. or its affiliates",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
