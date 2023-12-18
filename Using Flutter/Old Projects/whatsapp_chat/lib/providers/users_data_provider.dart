import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserDataProvider extends StateNotifier<Map<String, dynamic>> {
  UserDataProvider() : super({});

  void getUserData(String uid) async {
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userData.data() != null) {
      state = userData.data()!;
    }
  }

  void updateUserData(Map<String, dynamic> userData, String uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update(userData);
  }
}

final userDataProvider =
    StateNotifierProvider<UserDataProvider, Map<String, dynamic>>(
        (ref) => UserDataProvider());
