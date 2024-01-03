import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupUpdateProviderNotifier extends StateNotifier<Map<String, dynamic>> {
  GroupUpdateProviderNotifier() : super({});

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  void updateGroup(Map<String, dynamic> groupCode) async {
    List admin = groupCode['admin'];
    List users = groupCode['users'];
    String code1 = '${admin[0]}${groupCode['code']}';
    final userData =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    admin.remove(userData.data()!['email']);
    users.remove(userData.data()!['email']);

    if (admin.isEmpty) {
      await _firestore.collection('group').doc(code1).delete();
      if (users.isNotEmpty) {
        admin.add(users[0]);
      } else {
        return;
      }
    }

    groupCode['admin'] = admin;
    groupCode['users'] = users;

    String code2 = '${admin[0]}${groupCode['code']}';
    await _firestore.collection('group').doc(code2).set(groupCode);

    if (code1 != code2) {
      final listUserData = await _firestore
          .collection('users')
          .where('group_joined', arrayContains: code1)
          .get();
      for (int i = 0; i < listUserData.docs.length; i++) {
        Map<String, dynamic> data = listUserData.docs[i].data();
        String id = data['uid'];

        List a = listUserData.docs[i].data()['group_joined'];
        a.remove(code1);
        if (id != _auth.currentUser!.uid) {
          a.add(code2);
        }
        data.update('group_joined', (value) => a);
        await _firestore.collection('users').doc(id).update(data);
      }
    } else {
      List data = userData.data()!['group_joined'];
      data.remove(code1);
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'group_joined': data});
    }
  }
}

final groupUpdateProvider =
    StateNotifierProvider<GroupUpdateProviderNotifier, Map<String, dynamic>>(
        (ref) => GroupUpdateProviderNotifier());
