class ProductModel {
    bool? status;
    String? message;
    List<ProductList>? data;

    ProductModel({
        this.status,
        this.message,
        this.data,
    });

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<ProductList>.from(json["data"]!.map((x) => ProductList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class ProductList {
    String? id;
    String? vendor;
    String? product;
    String? vendorCost;
    String? tax;
    DateTime? createdAt;
    String? prodName;
    String? prodDescription;
    String? prodImg;

    ProductList({
        this.id,
        this.vendor,
        this.product,
        this.vendorCost,
        this.tax,
        this.createdAt,
        this.prodName,
        this.prodDescription,
        this.prodImg,
    });

    factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
        id: json["id"],
        vendor: json["vendor"],
        product: json["product"],
        vendorCost: json["vendor_cost"],
        tax: json["tax"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        prodName: json["prod_name"],
        prodDescription: json["prod_description"],
        prodImg: json["prod_img"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "vendor": vendor,
        "product": product,
        "vendor_cost": vendorCost,
        "tax": tax,
        "created_at": createdAt?.toIso8601String(),
        "prod_name": prodName,
        "prod_description": prodDescription,
        "prod_img": prodImg,
    };
}
