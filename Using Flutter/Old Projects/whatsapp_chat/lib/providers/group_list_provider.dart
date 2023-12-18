import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupListDataProvider extends StateNotifier<List<Map<String, dynamic>>> {
  GroupListDataProvider() : super([]);

  void getGroupDataList(String keyPair, String arrayvalue) async {
    final userDataList = await FirebaseFirestore.instance
        .collection('group')
        .where(keyPair, arrayContains: arrayvalue)
        .get();

    state = userDataList.docs.map((e) => e.data()).toList();
  }
}

final groupDataListProvider =
    StateNotifierProvider<GroupListDataProvider, List<Map<String, dynamic>>>(
        (ref) => GroupListDataProvider());
