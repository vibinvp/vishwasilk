import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:namma_bike/helper/api/api_post_request.dart';
import 'package:namma_bike/helper/api/endpoint_constant.dart';
import 'package:namma_bike/helper/core/color_constant.dart';
import 'package:namma_bike/helper/core/string_constant.dart';
import 'package:namma_bike/helper/storage/local_storage.dart';
import 'package:namma_bike/model/Product/product_model.dart';
import 'package:namma_bike/model/home/banner_model.dart';
import 'package:namma_bike/model/order/order_list_model.dart';
import 'package:namma_bike/model/order/orderd_venders_model.dart';
import 'package:namma_bike/model/order/pdf_invoice.dart';
import 'package:namma_bike/utility/dio_exception.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_filex/open_filex.dart';

class HomeController with ChangeNotifier {
  int selectedSliderIndex = 0;
  GetBannersModel? getBannersModel1;
  List<BannerData> banner = [];

  void changeSliderIndex(int index) {
    selectedSliderIndex = index;
    notifyListeners();
  }

  String selectedVendor = '';
  String selectedProductId = '';

  void selectVendor(String id) {
    selectedVendor = id;
    debugPrint(selectVendor.toString());
    notifyListeners();
  }

  void setForm(String productId) {
    selectedProductId = productId;
    notifyListeners();
  }

  bool isLoadBannner = false;

  void getBanners(BuildContext context) async {
    try {
      isLoadBannner = true;
      notifyListeners();
      var paremeters = {
        BANNERTYPE: '1',
      };

      final response =
          await ApiBaseHelper.postAPICall(ApiEndPoint.banner, paremeters);

      if (response != null) {
        print("aaaaaaaaaaaaaaaaaaaaa$response");
        getBannersModel1 = GetBannersModel.fromJson(response);
        if (getBannersModel1 != null && getBannersModel1!.data != null) {
          banner = ((response['data']) as List)
              .map((data) => BannerData.fromJson(data))
              .toList();
          isLoadBannner = false;
          notifyListeners();
        } else {
          isLoadBannner = false;

          notifyListeners();
        }
      } else {
        isLoadBannner = false;

        notifyListeners();
      }
    } catch (e) {
      isLoadBannner = false;
      log("Error occurred: $e");
      notifyListeners();
      DioExceptionhandler.errorHandler(e);
    }
  }

  String fromDate = 'Select From Date';
  String toDate = 'Select To Date';



  void setFromDate(date) {
    fromDate = date;

    notifyListeners();
  }

  void setToDate(date) {
    toDate = date;
    notifyListeners();
  }

  void setToDateDefault() {
    fromDate = 'Select From Date';
    toDate = 'Select To Date';
    notifyListeners();
  }

  OrdersModel? ordersModel;
  Map<String, List<OrderList>> groupedData = {};
  Map<String, num> productQuantities = {};
  Map<String, num> productAmounts = {};
  Map<String, String> productNames = {};
  num totalAmount = 0.0;
  num totalBalance = 0.0;
  num totalPaid = 0.0;

  List<OrderList> orderList = [];
  bool isLoadgetOrders = false;

  void getOrders(BuildContext context, String offset) async {
    try {
      // if (offset == '0') {
      isLoadgetOrders = true;
      notifyListeners();
      // }
      final userId = await LocalStorage.getUserUserIdSF();

      var paremeters = {
        USERID: userId,
        FROMDATE: fromDate == 'Select From Date' ? '' : fromDate,
        TODATE: toDate == 'Select To Date' ? '' : toDate,
        PRODUCTID: selectedProductId.toString()

        // LIMIT: AppConstant.perPage,
        // OFFSET: offset,
      };
      final response =
          await ApiBaseHelper.postAPICall(ApiEndPoint.getOrder, paremeters);

      if (response != null) {
        ordersModel = OrdersModel.fromJson(response);

        if (ordersModel != null && ordersModel!.data != null) {
          if (ordersModel!.status == true) {
            List<OrderList> data = ((response['data']) as List)
                .map((data) => OrderList.fromJson(data))
                .toList();
            // if (offset != '0') {
            //   orderList.addAll(data);
            // } else {
            orderList = data;
            // }
            groupedData = {};
            productQuantities = {};
            productAmounts = {};
            productNames = {};
            totalAmount = 0.0;
            totalBalance = 0.0;
            totalPaid = 0.0;
            for (var order in data) {
              String orderDate = order.orderDate ??
                  ''; // Replace 'orderDate' with the actual field name
              if (groupedData.containsKey(orderDate)) {
                groupedData[orderDate]?.add(order);
              } else {
                groupedData[orderDate] = [order];
              }

              String productId = order.productId ?? '';
              num quantity = num.parse(
                  order.weight ?? '0'); // Assuming weight is the quantity

              if (productQuantities.containsKey(productId)) {
                productQuantities[productId] =
                    quantity + productQuantities[productId]!;
              } else {
                productQuantities[productId] = quantity;
              }

              if (productQuantities.containsKey(productId)) {
                productNames[productId] = order.prodName ?? '';
              } else {
                productNames[productId] = order.prodName ?? '';
              }

              int totalAmount = int.parse(order.totalPrice ?? '');
              if (productAmounts.containsKey(productId)) {
                productAmounts[productId] =
                    totalAmount + productAmounts[productId]!;
              } else {
                productAmounts[productId] = totalAmount;
              }
            }

            for (var i = 0; i < orderList.length; i++) {
              totalAmount =
                  totalAmount + num.parse(orderList[i].totalPrice ?? '0.0');
              totalPaid =
                  totalPaid + num.parse(orderList[i].paidAmount ?? '0.0');
            }
            totalBalance = totalAmount - totalPaid;
            notifyListeners();
            isLoadgetOrders = false;
            notifyListeners();
          } else {
            orderList = [];

            isLoadgetOrders = false;
            notifyListeners();
          }
        } else {
          isLoadgetOrders = false;
          orderList = [];
          notifyListeners();
        }
      } else {
        isLoadgetOrders = false;

        notifyListeners();
      }
    } catch (e) {
      isLoadgetOrders = false;
      log("Error occurred: $e");
      notifyListeners();
      DioExceptionhandler.errorHandler(e);
    }
  }

  VendorFromOrdersModel? vendorFromOrdersModel;
  List<OrderdVendorList> orderdVendorList = [];
  bool isLoadgetVendor = false;

  void vendorFromOrders(
    BuildContext context,
  ) async {
    try {
      // if (offset == '0') {
      isLoadgetVendor = true;
      notifyListeners();
      // }
      final userId = await LocalStorage.getUserUserIdSF();

      var paremeters = {
        USERID: userId,
      };
      final response = await ApiBaseHelper.postAPICall(
          ApiEndPoint.getOrderVendors, paremeters);

      if (response != null) {
        vendorFromOrdersModel = VendorFromOrdersModel.fromJson(response);

        if (vendorFromOrdersModel != null &&
            vendorFromOrdersModel!.data != null) {
          if (vendorFromOrdersModel!.status == true) {
            List<OrderdVendorList> data = ((response['data']) as List)
                .map((data) => OrderdVendorList.fromJson(data))
                .toList();

            orderdVendorList = data;

            isLoadgetVendor = false;
            notifyListeners();
          } else {
            orderdVendorList = [];

            isLoadgetVendor = false;
            notifyListeners();
          }
        } else {
          isLoadgetVendor = false;
          orderList = [];
          notifyListeners();
        }
      } else {
        isLoadgetVendor = false;

        notifyListeners();
      }
    } catch (e) {
      isLoadgetVendor = false;
      log("Error occurred: $e");
      notifyListeners();
      DioExceptionhandler.errorHandler(e);
    }
  }

  bool isLoadproductList = false;
  List<ProductList> productList = [];
  ProductModel? productModel;
  void getproductList(BuildContext context) async {
    try {
      isLoadproductList = true;
      notifyListeners();
      final userId = await LocalStorage.getUserUserIdSF();
      var paremeters = {
        USERID: userId,
      };
      final response =
          await ApiBaseHelper.postAPICall(ApiEndPoint.getProducts, paremeters);

      if (response != null) {
        productModel = ProductModel.fromJson(response);
        if (productModel != null && productModel!.data != null) {
          productList = ((response['data']) as List)
              .map((data) => ProductList.fromJson(data))
              .toList();
          isLoadproductList = false;
          notifyListeners();
        } else {
          isLoadproductList = false;
          productList = [];
          notifyListeners();
        }
      } else {
        isLoadproductList = false;

        notifyListeners();
      }
    } catch (e) {
      isLoadproductList = false;
      debugPrint("Error occurred: $e");
      notifyListeners();
      DioExceptionhandler.errorHandler(e);
    }
  }

  ///--------------------------DownLoad PDF-------------------------------------///

  bool isDownloadInvoice = false;

  Future<void> generateAndDownloadPDF(String orderId, context) async {
    try {
      isDownloadInvoice = true;
      notifyListeners();

      //final userId = await LocalStorage.getUserUserIdSF();

      var paremeters = {
        // USERID: userId,
        ORDERID: orderId,
      };
      final response = await ApiBaseHelper.postAPICall(
          ApiEndPoint.downloadInvoice, paremeters);

      if (response != null) {
        InvoicePdfModel ordersModel = InvoicePdfModel.fromJson(response);

        if (ordersModel.status == true) {
          var targetPath = await getApplicationDocumentsDirectory();
          var targetFileName = "invoice";

          var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
              ordersModel.data ?? '', targetPath.path, targetFileName);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                "CLICK HERE TO VIEW INVOICE",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColoring.kAppWhiteColor),
              ),
              action: SnackBarAction(
                label: 'View',
                textColor: AppColoring.kAppWhiteColor,
                onPressed: () async {
                  await OpenFilex.open(generatedPdfFile.path);
                  // launchUrl(Uri.parse(generatedPdfFile.path));
                },
              ),
              backgroundColor: AppColoring.successPopup,
            ),
          );

          isDownloadInvoice = false;
          notifyListeners();
        } else {
          isDownloadInvoice = false;
          notifyListeners();
        }
      } else {
        isDownloadInvoice = false;

        notifyListeners();
      }
    } catch (e) {
      isDownloadInvoice = false;
      log("Error occurred: $e");
      notifyListeners();
      DioExceptionhandler.errorHandler(e);
    }
  }
}
