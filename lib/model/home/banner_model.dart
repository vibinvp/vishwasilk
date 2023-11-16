class GetBannersModel {
  bool? status;
  String? message;
  List<BannerData>? data;

  GetBannersModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetBannersModel.fromJson(Map<String, dynamic> json) =>
      GetBannersModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<BannerData>.from(
                json["data"]!.map((x) => BannerData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class BannerData {
  String? id;
  String? image;
  String? type;

  BannerData({
    this.id,
    this.image,
    this.type,
  });

  factory BannerData.fromJson(Map<String, dynamic> json) => BannerData(
        id: json["ban_id"],
        image: json["ban_img"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "type": type,
      };
}
