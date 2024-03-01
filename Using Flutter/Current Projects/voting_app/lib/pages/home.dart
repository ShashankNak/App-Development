import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:voting_app/pages/election_info.dart';
import 'package:voting_app/utils/constants.dart';
import 'package:web3dart/web3dart.dart';

import '../services/functions.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Client? httpClient;
  Web3Client? ethClient;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(infuriaURL, httpClient!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start Election"),
      ),
      body: Container(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                  labelText: "Enter Election Name", filled: true),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () async {
                  if (controller.text.trim().isNotEmpty) {
                    await startElection(controller.text.trim(), ethClient!)
                        .then(
                      (value) => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ElectionInfo(
                              ethClient: ethClient!,
                              electionName: controller.text.trim()),
                        ),
                      ),
                    );
                  }
                },
                child: const Text("Start Election"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              title: const Text("Election Name"),
              subtitle: const Text("class Monitor"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ElectionInfo(
                        ethClient: ethClient!, electionName: "class Monitor"),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
