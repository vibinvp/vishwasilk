
class StroDetailsModel {
    bool? status;
    String? message;
    List<StoreData>? data;

    StroDetailsModel({
        this.status,
        this.message,
        this.data,
    });

    factory StroDetailsModel.fromJson(Map<String, dynamic> json) => StroDetailsModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<StoreData>.from(json["data"]!.map((x) => StoreData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class StoreData {
    String? id;
    String? settingKeys;
    String? value;
    DateTime? createdAt;

    StoreData({
        this.id,
        this.settingKeys,
        this.value,
        this.createdAt,
    });

    factory StoreData.fromJson(Map<String, dynamic> json) => StoreData(
        id: json["id"],
        settingKeys: json["setting_keys"],
        value: json["value"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "setting_keys": settingKeys,
        "value": value,
        "created_at": createdAt?.toIso8601String(),
    };
}
