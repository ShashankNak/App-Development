import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:voting_app/services/functions.dart';
import 'package:voting_app/utils/constants.dart';
import 'package:web3dart/web3dart.dart';

class ElectionInfo extends StatefulWidget {
  const ElectionInfo(
      {super.key, required this.ethClient, required this.electionName});
  final Web3Client ethClient;
  final String electionName;

  @override
  State<ElectionInfo> createState() => _ElectionInfoState();
}

class _ElectionInfoState extends State<ElectionInfo> {
  TextEditingController addCandidateController = TextEditingController();
  TextEditingController authorisedVoterController =
      TextEditingController(text: voterPublicAddress);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.electionName),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        FutureBuilder<List>(
                            future: getTotalVotes(widget.ethClient),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  snapshot.connectionState ==
                                      ConnectionState.none) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (!snapshot.hasData) {
                                return const Text(
                                  "xxx",
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                              return Text(
                                snapshot.data![0].toString(),
                                style: const TextStyle(
                                    fontSize: 50, fontWeight: FontWeight.bold),
                              );
                            }),
                        const Text("Total Votes"),
                      ],
                    ),
                    Column(
                      children: [
                        FutureBuilder<List>(
                            future: getCandidatesNum(widget.ethClient),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (!snapshot.hasData) {
                                return const Text(
                                  "xxx",
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                              return Text(
                                snapshot.data![0].toString(),
                                style: const TextStyle(
                                    fontSize: 50, fontWeight: FontWeight.bold),
                              );
                            }),
                        const Text("Total Candidates"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: addCandidateController,
                        decoration: const InputDecoration(
                          hintText: "Enter Candidate Name",
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (addCandidateController.text.trim().isNotEmpty) {
                          addCandidate(addCandidateController.text.trim(),
                                  widget.ethClient)
                              .then((value) {
                            addCandidateController.clear();
                          });
                        }
                      },
                      child: const Text("Add Candidate"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: authorisedVoterController,
                        decoration: const InputDecoration(
                          hintText: "Enter Voter Name",
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (authorisedVoterController.text.trim().isNotEmpty) {
                          authorizeVoter(authorisedVoterController.text.trim(),
                                  widget.ethClient)
                              .then((value) {
                            authorisedVoterController.clear();
                          });
                        }
                      },
                      child: const Text("Authorised voter"),
                    ),
                  ],
                ),
                const Divider(),
                FutureBuilder(
                  future: getCandidatesNum(widget.ethClient),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Text(
                        "xxx",
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      );
                    }
                    final len = int.tryParse(snapshot.data![0].toString());
                    log(len.toString());
                    return SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: len,
                        itemBuilder: (context, index) {
                          return FutureBuilder<List>(
                            future: candidatesInfo(index, widget.ethClient),
                            builder: (context, candidateSnapshot) {
                              if (candidateSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (!candidateSnapshot.hasData) {
                                return const Text(
                                  "xxx",
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                              return ListTile(
                                title: Text(
                                    candidateSnapshot.data![0][0].toString()),
                                subtitle: Text(
                                    candidateSnapshot.data![0][1].toString()),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    vote(index, widget.ethClient);
                                  },
                                  child: const Text("Vote"),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }
}
