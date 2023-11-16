class VendorPlansModel {
  bool? status;
  String? message;
  List<PlanData>? data;

  VendorPlansModel({
    this.status,
    this.message,
    this.data,
  });

  factory VendorPlansModel.fromJson(Map<String, dynamic> json) =>
      VendorPlansModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<PlanData>.from(
                json["data"]!.map((x) => PlanData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class PlanData {
  String? planId;
  String? planName;
  String? planImage;
  String? planDetails;
  String? planAmount;
  String? planPoints;
  String? planStatus;
  DateTime? planCreated;

  PlanData({
    this.planId,
    this.planName,
    this.planImage,
    this.planDetails,
    this.planAmount,
    this.planPoints,
    this.planStatus,
    this.planCreated,
  });

  factory PlanData.fromJson(Map<String, dynamic> json) => PlanData(
        planId: json["plan_id"],
        planName: json["plan_name"],
        planImage: json["plan_image"],
        planDetails: json["plan_details"],
        planAmount: json["plan_amount"],
        planPoints: json["plan_points"],
        planStatus: json["plan_status"],
        planCreated: json["plan_created"] == null
            ? null
            : DateTime.parse(json["plan_created"]),
      );

  Map<String, dynamic> toJson() => {
        "plan_id": planId,
        "plan_name": planName,
        "plan_image": planImage,
        "plan_details": planDetails,
        "plan_amount": planAmount,
        "plan_points": planPoints,
        "plan_status": planStatus,
        "plan_created": planCreated?.toIso8601String(),
      };
}
