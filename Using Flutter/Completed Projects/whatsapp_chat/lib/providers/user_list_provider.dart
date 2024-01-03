import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserListDataProvider extends StateNotifier<List<Map<String, dynamic>>> {
  UserListDataProvider() : super([]);

  void getUserDataList(String keyPair, String value) async {
    final userDataList = await FirebaseFirestore.instance
        .collection('users')
        .where(keyPair, isEqualTo: value)
        .get();

    state = userDataList.docs.map((e) => e.data()).toList();
  }

  void getUserDataListArray(String keyPair, String arrayvalue) async {
    final userDataList = await FirebaseFirestore.instance
        .collection('users')
        .where(keyPair, arrayContains: arrayvalue)
        .get();

    state = userDataList.docs.map((e) => e.data()).toList();
  }
}

final userDataListProvider =
    StateNotifierProvider<UserListDataProvider, List<Map<String, dynamic>>>(
        (ref) => UserListDataProvider());
