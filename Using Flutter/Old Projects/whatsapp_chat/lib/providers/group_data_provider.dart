import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupDataProvider extends StateNotifier<Map<String, dynamic>> {
  GroupDataProvider() : super({});

  void getGroupData(String code) async {
    final userData =
        await FirebaseFirestore.instance.collection('group').doc(code).get();

    Map<String, dynamic> user = userData.data()!;
    state = user;
  }

  void updateGroupData(Map<String, dynamic> group, String code) async {
    await FirebaseFirestore.instance
        .collection('group')
        .doc(code)
        .update(group);
  }

  void setGroupData(Map<String, dynamic> group, String code) async {
    await FirebaseFirestore.instance.collection('group').doc(code).set(group);
  }

  void getGroupDataByValue(String keyPair, String valuePair) async {
    final groupData = await FirebaseFirestore.instance
        .collection('group')
        .where(keyPair, isEqualTo: valuePair)
        .get();

    if (groupData.docs.isEmpty) {
      state = {};
      return;
    }

    state = groupData.docs[0].data();
  }
}

final groupDataProvider =
    StateNotifierProvider<GroupDataProvider, Map<String, dynamic>>(
        (ref) => GroupDataProvider());
