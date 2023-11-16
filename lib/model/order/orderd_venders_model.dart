class VendorFromOrdersModel {
    bool? status;
    String? message;
    List<OrderdVendorList>? data;

    VendorFromOrdersModel({
        this.status,
        this.message,
        this.data,
    });

    factory VendorFromOrdersModel.fromJson(Map<String, dynamic> json) => VendorFromOrdersModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<OrderdVendorList>.from(json["data"]!.map((x) => OrderdVendorList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class OrderdVendorList {
    String? vendorId;
    String? vendorName;

    OrderdVendorList({
        this.vendorId,
        this.vendorName,
    });

    factory OrderdVendorList.fromJson(Map<String, dynamic> json) => OrderdVendorList(
        vendorId: json["vendor_id"],
        vendorName: json["vendor_name"],
    );

    Map<String, dynamic> toJson() => {
        "vendor_id": vendorId,
        "vendor_name": vendorName,
    };
}
