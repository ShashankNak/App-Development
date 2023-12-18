import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupDrawerTile extends StatefulWidget {
  const GroupDrawerTile({
    super.key,
    required this.userData,
  });

  final Map<String, dynamic> userData;
  @override
  State<GroupDrawerTile> createState() => _GroupDrawerTileState();
}

class _GroupDrawerTileState extends State<GroupDrawerTile> {
  Color statusColor = Colors.white54;
  Color colorChange(String status) {
    if (status == "Online") {
      statusColor = Colors.green.shade700;
    } else {
      statusColor = Colors.white54;
    }
    return statusColor;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userData['uid'])
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text('No messages'),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong..'),
          );
        }

        if (snapshot.data != null) {
          return ListTile(
            leading: CircleAvatar(
              foregroundImage: NetworkImage(widget.userData['image_url']),
            ),
            title: Text(
              widget.userData['username'],
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 5,
                  backgroundColor: colorChange(snapshot.data!['status']),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  snapshot.data!['status'],
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: colorChange(snapshot.data!['status'])),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
