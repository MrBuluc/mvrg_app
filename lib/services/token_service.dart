import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class TokenService {
  final String blockchainUrl = dotenv.env["blockchainUrl"]!;

  late Client httpClient;

  late Web3Client ethClient;

  TokenService() {
    httpClient = Client();
    ethClient = Web3Client(blockchainUrl, httpClient);
  }

  Future<String> getTokenBalance(String address) async {
    return ((await callGetFunc(
            "balanceOf", [EthereumAddress.fromHex(address)]))[0])
        .toString();
  }

  Future<List> callGetFunc(String funcName, List params) async {
    DeployedContract contract = await getContract();
    ContractFunction function = contract.function(funcName);
    return await ethClient.call(
        contract: contract, function: function, params: params);
  }

  Future<DeployedContract> getContract() async {
    String abiFile = await rootBundle.loadString("assets/mvrg_token_abi.json");

    return DeployedContract(ContractAbi.fromJson(abiFile, "MvRGToken"),
        EthereumAddress.fromHex(dotenv.env["mvRGTokenAddress"]!));
  }

  Future<String> callSetFunc(String funcName, List params) async {
    DeployedContract contract = await getContract();
    return await ethClient.sendTransaction(
        EthPrivateKey.fromHex(dotenv.env["privateAddress"]!),
        Transaction.callContract(
            contract: contract,
            function: contract.function(funcName),
            parameters: params,
            maxGas: 100000),
        chainId: 5);
  }

  Future<String> sendToken(String receiverAddress, BigInt value) async {
    return await callSetFunc(
        "transfer", [EthereumAddress.fromHex(receiverAddress), value]);
  }
}
