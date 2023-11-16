class CountModel {
  bool? status;
  String? message;
  Data? data;

  CountModel({
    this.status,
    this.message,
    this.data,
  });

  factory CountModel.fromJson(Map<String, dynamic> json) => CountModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  dynamic pendingOrders;
  dynamic ongoingOrders;
  dynamic completeOrders;

  Data({
    this.pendingOrders,
    this.ongoingOrders,
    this.completeOrders,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        pendingOrders: json["Pending Orders"],
        ongoingOrders: json["Ongoing Orders"],
        completeOrders: json["Complete Orders"],
      );

  Map<String, dynamic> toJson() => {
        "Pending Orders": pendingOrders,
        "Ongoing Orders": ongoingOrders,
        "Complete Orders": completeOrders,
      };
}
