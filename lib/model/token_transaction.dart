import 'package:cloud_firestore/cloud_firestore.dart';

class TokenTransaction {
  String userId;
  int beforeToken;
  int afterToken;
  String walletAdd;
  int transferToken;
  Timestamp time;

  TokenTransaction(
      {required this.userId,
      required this.beforeToken,
      required this.afterToken,
      required this.walletAdd,
      required this.transferToken,
      required this.time});

  TokenTransaction.fromFirestore(Map<String, dynamic> map)
      : this(
            userId: map["userId"],
            beforeToken: map["beforeToken"],
            afterToken: map["afterToken"],
            walletAdd: map["walletAdd"],
            transferToken: map["transferToken"],
            time: map["time"]);

  Map<String, dynamic> toFirestore() => {
        "userId": userId,
        "beforeToken": beforeToken,
        "afterToken": afterToken,
        "walletAdd": walletAdd,
        "transferToken": transferToken,
        "time": time
      };
}
