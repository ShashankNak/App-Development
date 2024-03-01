import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:voting_app/utils/constants.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString("assets/abi.json");
  String contractAddress = contractAddress1;

  final contract = DeployedContract(ContractAbi.fromJson(abi, "Election"),
      EthereumAddress.fromHex(contractAddress));

  return contract;
}

Future<String> callFunction(String funcName, List<dynamic> args,
    Web3Client ethClient, String privateKey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  // EthereumAddress ownAddress = await credentials.extractAddress();
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(funcName);
  final result = await ethClient.sendTransaction(
    credentials,
    Transaction.callContract(
      contract: contract,
      function: ethFunction,
      parameters: args,
    ),
    chainId: null,
    fetchChainIdFromNetworkId: true,
  );
  return result;
}

Future<String> startElection(String name, Web3Client ethClient) async {
  List<dynamic> args = [name];
  String response =
      await callFunction("startElection", args, ethClient, ownerPrivateKey);
  log("Election Started Successfully");
  log(response);
  return response;
}

Future<String> addCandidate(String name, Web3Client ethClient) async {
  List<dynamic> args = [name];
  String response =
      await callFunction("addCandidate", args, ethClient, ownerPrivateKey);
  log("Candidate added Successfully");
  return response;
}

Future<String> authorizeVoter(String address, Web3Client ethClient) async {
  List<dynamic> args = [EthereumAddress.fromHex(address)];
  String response =
      await callFunction("authorizeVoter", args, ethClient, ownerPrivateKey);
  log("Voter Authorised Successfully");
  return response;
}

Future<List> getCandidatesNum(Web3Client ethClient) async {
  List<dynamic> result = await ask("getNameCandidates", [], ethClient);
  return result;
}

Future<List> getTotalVotes(Web3Client ethClient) async {
  List<dynamic> result = await ask("getTotalVotes", [], ethClient);
  return result;
}

Future<List<dynamic>> ask(
    String funcName, List<dynamic> args, Web3Client ethClient) async {
  final contract = await loadContract();
  final ethFunction = contract.function(funcName);
  final result = await ethClient.call(
    contract: contract,
    function: ethFunction,
    params: args,
  );
  return result;
}

Future<String> vote(int candidateIndex, Web3Client ethClient) async {
  List<dynamic> args = [BigInt.from(candidateIndex)];
  String response =
      await callFunction("vote", args, ethClient, voterPrivateKey);
  log("Vote counted Successfully");
  return response;
}

Future<List> candidatesInfo(int index, Web3Client ethClient) async {
  List<dynamic> result =
      await ask("CandidateInfo", [BigInt.from(index)], ethClient);
  return result;
}
