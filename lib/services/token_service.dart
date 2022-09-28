import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:mvrg_app/services/secret.dart';
import 'package:web3dart/web3dart.dart';

class TokenService {
  final blockchainUrl = Secret.blockchainUrl;

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
        EthereumAddress.fromHex(Secret.mvRGTokenAddress));
  }
}
