import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProviderNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  UserProviderNotifier() : super([]);
  void getUserData(Map<String, dynamic> group) async {
    List<Map<String, dynamic>> userDataList = [];

    for (String user in group['users']) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user)
          .get();
      userDataList.add(userData.docs[0].data());
    }
    state = userDataList;
  }
}

final userProvider =
    StateNotifierProvider<UserProviderNotifier, List<Map<String, dynamic>>>(
        (ref) => UserProviderNotifier());
