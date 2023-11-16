import 'package:namma_bike/helper/api/base_constatnt.dart';

class ApiEndPoint {
  static const String userLogin = '${ApiBaseConstant.baseUrl}vendorLogin';
  static const String userRegister = '${ApiBaseConstant.baseUrl}vendorRegister';
  static const String updateFcm = '${ApiBaseConstant.baseSubUrl}updateFcmKey';
  static const String getUser = '${ApiBaseConstant.baseUrl}vendorProfile';
  static const String updateProfile = '${ApiBaseConstant.baseUrl}vendorEdit';
  static const String banner = '${ApiBaseConstant.baseUrl}getBanner';
  static const String pendingOrders = '${ApiBaseConstant.baseUrl}orders';
  static const String onGoingOrders = '${ApiBaseConstant.baseUrl}ongoing';
  static const String completeOrders = '${ApiBaseConstant.baseUrl}completed';
  static const String downloadInvoice =
      '${ApiBaseConstant.baseSubUrl}orderInvoice';
  static const String acceptOrders = '${ApiBaseConstant.baseUrl}accepted';
  static const String rejecttOrders = '${ApiBaseConstant.baseUrl}rejected';
  static const String getOrderVendors =
      '${ApiBaseConstant.baseUrl}vendorFromOrders';

  static const String completedOrder =
      '${ApiBaseConstant.baseUrl}order/completed';
  static const String getPlans = '${ApiBaseConstant.baseUrl}plans';
  static const String planPurchase = '${ApiBaseConstant.baseUrl}purchase';
  static const String getCount = '${ApiBaseConstant.baseUrl}dashboard';
  static const String walletTransactions = '${ApiBaseConstant.baseUrl}wallet';
  static const String getSettings =
      '${ApiBaseConstant.baseSubUrl}companySetting';
  static const String getOrder = '${ApiBaseConstant.baseUrl}vendorOrders';
  static const String getProducts = '${ApiBaseConstant.baseUrl}vendorProducts';
}
