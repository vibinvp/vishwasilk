class WalletTransactionModel {
  bool? status;
  String? message;
  List<TransactionData>? data;

  WalletTransactionModel({
    this.status,
    this.message,
    this.data,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) =>
      WalletTransactionModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<TransactionData>.from(
                json["data"]!.map((x) => TransactionData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class TransactionData {
  String? id;
  String? transactionId;
  String? orderId;
  String? planId;
  String? vendorId;
  String? vendorPoints;
  String? transType;
  String? message;
  DateTime? transDate;

  TransactionData({
    this.id,
    this.transactionId,
    this.orderId,
    this.planId,
    this.vendorId,
    this.vendorPoints,
    this.transType,
    this.message,
    this.transDate,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) =>
      TransactionData(
        id: json["id"],
        transactionId: json["transaction_id"],
        orderId: json["order_id"],
        planId: json["plan_id"],
        vendorId: json["vendor_id"],
        vendorPoints: json["vendor_points"],
        transType: json["trans_type"],
        message: json["message"],
        transDate: json["trans_date"] == null
            ? null
            : DateTime.parse(json["trans_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "transaction_id": transactionId,
        "order_id": orderId,
        "plan_id": planId,
        "vendor_id": vendorId,
        "vendor_points": vendorPoints,
        "trans_type": transType,
        "message": message,
        "trans_date": transDate?.toIso8601String(),
      };
}
