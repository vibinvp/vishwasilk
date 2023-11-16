class UserDetailsModel {
  bool? status;
  String? message;
  List<User>? data;

  UserDetailsModel({
    this.status,
    this.message,
    this.data,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) =>
      UserDetailsModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<User>.from(json["data"]!.map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class User {
  String? id;
  String? vendorId;
  String? vendorName;
  dynamic password;
  String? vendorMobile;
  String? vendorCity;
  String? vendorAddress;
  String? vendorPincode;
  String? vendorAdhar;
  String? vendorPhoto;
  String? vendorEmail;
  String? state;
  String? country;
  dynamic lattitude;
  String? longitude;
  String? ipAddress;
  dynamic forgottenPass;
  dynamic forgottenPassTime;
  dynamic active;
  dynamic loginOtp;
  dynamic referalCode;
  String? createdAt;

  User({
    this.id,
    this.vendorId,
    this.vendorName,
    this.password,
    this.vendorMobile,
    this.vendorCity,
    this.vendorAddress,
    this.vendorPincode,
    this.vendorAdhar,
    this.vendorPhoto,
    this.vendorEmail,
    this.state,
    this.country,
    this.lattitude,
    this.longitude,
    this.ipAddress,
    this.forgottenPass,
    this.forgottenPassTime,
    this.active,
    this.loginOtp,
    this.referalCode,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        vendorId: json["vendor_id"],
        vendorName: json["vendor_name"],
        password: json["password"],
        vendorMobile: json["vendor_mobile"],
        vendorCity: json["vendor_city"],
        vendorAddress: json["vendor_address"],
        vendorPincode: json["vendor_pincode"],
        vendorAdhar: json["vendor_adhar"],
        vendorPhoto: json["vendor_photo"],
        vendorEmail: json["vendor_email"],
        state: json["state"],
        country: json["country"],
        lattitude: json["lattitude"],
        longitude: json["longitude"],
        ipAddress: json["ip_address"],
        forgottenPass: json["forgotten_pass"],
        forgottenPassTime: json["forgotten_pass_time"],
        active: json["active"],
        loginOtp: json["login_otp"],
        referalCode: json["referal_code"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vendor_id": vendorId,
        "vendor_name": vendorName,
        "password": password,
        "vendor_mobile": vendorMobile,
        "vendor_city": vendorCity,
        "vendor_address": vendorAddress,
        "vendor_pincode": vendorPincode,
        "vendor_adhar": vendorAdhar,
        "vendor_photo": vendorPhoto,
        "vendor_email": vendorEmail,
        "state": state,
        "country": country,
        "lattitude": lattitude,
        "longitude": longitude,
        "ip_address": ipAddress,
        "forgotten_pass": forgottenPass,
        "forgotten_pass_time": forgottenPassTime,
        "active": active,
        "login_otp": loginOtp,
        "referal_code": referalCode,
        "created_at": createdAt,
      };
}
