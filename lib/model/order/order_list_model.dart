class OrdersModel {
  bool? status;
  String? message;
  List<OrderList>? data;

  OrdersModel({
    this.status,
    this.message,
    this.data,
  });

  factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<OrderList>.from(
                json["data"]!.map((x) => OrderList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class OrderList {
  String? id;
  String? orderId;
  String? pickupBoyId;
  String? productId;
  String? vendorId;
  String? prodName;
  String? prodDesc;
  String? prodImg;
  String? weight;
  String? paidAmount;
  String? totalPrice;
  String? balanceAmount;
  String? cityId;
  String? note;
  String? orderDate;
  String? createdAt;
  String? status;
  String? vendorName;
  String? password;
  String? vendorMobile;
  String? vendorCity;
  String? vendorAddress;
  String? vendorPincode;
  String? vendorAdhar;
  String? vendorPhoto;
  String? vendorEmail;
  String? state;
  String? country;
  String? lattitude;
  String? longitude;
  String? ipAddress;
  dynamic forgottenPass;
  dynamic forgottenPassTime;
  dynamic active;
  dynamic loginOtp;
  String? referalCode;
  String? userName;
  String? fullname;
  String? mobile;
  String? prodDescription;

  OrderList({
    this.id,
    this.orderId,
    this.pickupBoyId,
    this.productId,
    this.vendorId,
    this.prodName,
    this.prodDesc,
    this.prodImg,
    this.weight,
    this.totalPrice,
    this.paidAmount,
    this.balanceAmount,
    this.cityId,
    this.note,
    this.orderDate,
    this.createdAt,
    this.status,
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
    this.userName,
    this.fullname,
    this.mobile,
    this.prodDescription,
  });

  factory OrderList.fromJson(Map<String, dynamic> json) => OrderList(
        id: json["id"],
        orderId: json["order_id"],
        pickupBoyId: json["pickup_boy_id"],
        productId: json["product_id"],
        vendorId: json["vendor_id"],
        prodName: json["prod_name"],
        prodDesc: json["prod_desc"],
        prodImg: json["prod_img"],
        weight: json["weight"],
        totalPrice: json["total_price"],
        paidAmount: json["paid_amount"],
        balanceAmount: json["balanced_amount"],
        cityId: json["city_id"],
        note: json["note"],
        orderDate: json["order_date"],
        createdAt: json["created_at"],
        status: json["status"],
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
        userName: json["user_name"],
        fullname: json["fullname"],
        mobile: json["mobile"],
        prodDescription: json["prod_description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "pickup_boy_id": pickupBoyId,
        "product_id": productId,
        "vendor_id": vendorId,
        "prod_name": prodName,
        "prod_desc": prodDesc,
        "prod_img": prodImg,
        "weight": weight,
        "total_price": totalPrice,
        "city_id": cityId,
        "note": note,
        "order_date": orderDate,
        "created_at": createdAt,
        "status": status,
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
        "user_name": userName,
        "fullname": fullname,
        "mobile": mobile,
        "prod_description": prodDescription,
      };
}
