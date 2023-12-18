import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_chat/providers/group_update_provider.dart';
import 'package:whatsapp_chat/providers/user_provider.dart';
import 'package:whatsapp_chat/screens/home.dart';
import 'package:whatsapp_chat/screens/profile.dart';

class GroupProfile extends ConsumerWidget {
  const GroupProfile({
    super.key,
    required this.groupData,
  });
  final Map<String, dynamic> groupData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(userProvider);
    final List admin = groupData['admin'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                foregroundImage: NetworkImage(groupData['image_url']),
                radius: 150,
              ),
              const SizedBox(
                height: 20,
              ),
              data.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreen(userData: data[index]),
                                ));
                              },
                              child: CircleAvatar(
                                foregroundImage:
                                    NetworkImage(data[index]['image_url']),
                              ),
                            ),
                            title: Text(
                              data[index]['username'],
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            subtitle: Text(
                              data[index]['email'],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.5)),
                            ),
                            trailing: admin.contains(data[index]['email'])
                                ? Text(
                                    "Admin",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  )
                                : null,
                          );
                        },
                        itemCount: data.length,
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
              ElevatedButton(
                  onPressed: () {
                    ref
                        .watch(groupUpdateProvider.notifier)
                        .updateGroup(groupData);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                        (route) => false);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Exit Group"),
                      Icon(Icons.exit_to_app),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
