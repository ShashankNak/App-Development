import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_chat/providers/email_verified.dart';
import 'package:whatsapp_chat/screens/home.dart';

class EmailVerifyScreen extends ConsumerStatefulWidget {
  const EmailVerifyScreen({super.key});

  @override
  ConsumerState<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends ConsumerState<EmailVerifyScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResend = true;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        checkEmailVerified();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    timer?.cancel();
  }

  void showSnackbar(String s) {
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(s),
      ));
    }
  }

  Future checkEmailVerified() async {
    try {
      await FirebaseAuth.instance.currentUser!.reload();
      if (mounted) {
        setState(() {
          isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
        });
      }

      if (isEmailVerified) {
        ref.watch(emailVerifiedProvider.notifier).setVerified(true);
        timer?.cancel();
      }
    } catch (e) {
      if (mounted) {
        showSnackbar('Something went wrong');
        FirebaseAuth.instance.signOut();
        await FirebaseAuth.instance.currentUser!.delete();
      }
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;

      await user.sendEmailVerification();
      if (mounted) {
        setState(
          () => canResend = false,
        );
        await Future.delayed(const Duration(seconds: 30));
        setState(
          () => canResend = true,
        );
      }
    } catch (e) {
      if (mounted) {
        showSnackbar('Something went wrong');
        await FirebaseAuth.instance.currentUser!.delete();
        FirebaseAuth.instance.signOut();
      }
    }
  }

  void _cancelButton() async {
    await FirebaseAuth.instance.currentUser!.delete();
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const HomeScreen()
        : Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  ImageIcon(
                    const AssetImage('assets/images/bot.png'),
                    size: 24,
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.5),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Verification Page',
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
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your Verification is sent to your email account.',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50)),
                      icon: const Icon(Icons.email),
                      onPressed: canResend ? sendVerificationEmail : null,
                      label: canResend
                          ? const Text("Resend Email")
                          : const Text("Resending...."),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50)),
                      onPressed: _cancelButton,
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
