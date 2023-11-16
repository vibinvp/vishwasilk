class RegisterModel {
  bool? status;
  String? message;
  List<Datum>? data;

  RegisterModel({
    this.status,
    this.message,
    this.data,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? id;
  String? userId;
  String? ipAddress;
  String? username;
  String? email;
  String? mobile;
  dynamic image;
  dynamic forgottenPasswordCode;
  dynamic forgottenPasswordTime;
  dynamic rememberSelector;
  dynamic rememberCode;
  dynamic lastLogin;
  dynamic active;
  dynamic dob;
  dynamic countryCode;
  String? address;
  String? city;
  String? state;
  dynamic area;
  dynamic street;
  String? pincode;
  dynamic serviceableZipcodes;
  dynamic apikey;
  String? loginOtp;
  dynamic referralCode;
  String? latitude;
  String? longitude;
  DateTime? createdAt;
  dynamic adharCard;
  dynamic panCard;
  dynamic gender;

  Datum({
    this.id,
    this.userId,
    this.ipAddress,
    this.username,
    this.email,
    this.mobile,
    this.image,
    this.forgottenPasswordCode,
    this.forgottenPasswordTime,
    this.rememberSelector,
    this.rememberCode,
    this.lastLogin,
    this.active,
    this.dob,
    this.countryCode,
    this.address,
    this.city,
    this.state,
    this.area,
    this.street,
    this.pincode,
    this.serviceableZipcodes,
    this.apikey,
    this.loginOtp,
    this.referralCode,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.adharCard,
    this.panCard,
    this.gender,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["vendor_id"],
        ipAddress: json["ip_address"],
        username: json["vendor_name"],
        email: json["email"],
        mobile: json["mobile"],
        image: json["image"],
        forgottenPasswordCode: json["forgotten_password_code"],
        forgottenPasswordTime: json["forgotten_password_time"],
        rememberSelector: json["remember_selector"],
        rememberCode: json["remember_code"],
        lastLogin: json["last_login"],
        active: json["active"],
        dob: json["dob"],
        countryCode: json["country_code"],
        address: json["address"],
        city: json["city"],
        state: json["state"],
        area: json["area"],
        street: json["street"],
        pincode: json["pincode"],
        serviceableZipcodes: json["serviceable_zipcodes"],
        apikey: json["apikey"],
        loginOtp: json["login_otp"],
        referralCode: json["referral_code"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        adharCard: json["adhar_card"],
        panCard: json["pan_card"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vendor_id": userId,
        "ip_address": ipAddress,
        "vendor_name": username,
        "email": email,
        "mobile": mobile,
        "image": image,
        "forgotten_password_code": forgottenPasswordCode,
        "forgotten_password_time": forgottenPasswordTime,
        "remember_selector": rememberSelector,
        "remember_code": rememberCode,
        "last_login": lastLogin,
        "active": active,
        "dob": dob,
        "country_code": countryCode,
        "address": address,
        "city": city,
        "state": state,
        "area": area,
        "street": street,
        "pincode": pincode,
        "serviceable_zipcodes": serviceableZipcodes,
        "apikey": apikey,
        "login_otp": loginOtp,
        "referral_code": referralCode,
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt?.toIso8601String(),
        "adhar_card": adharCard,
        "pan_card": panCard,
        "gender": gender,
      };
}
