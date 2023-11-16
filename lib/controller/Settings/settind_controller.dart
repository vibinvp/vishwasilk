import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:namma_bike/helper/api/api_post_request.dart';
import 'package:namma_bike/helper/api/endpoint_constant.dart';
import 'package:namma_bike/helper/core/color_constant.dart';
import 'package:namma_bike/helper/core/message.dart';
import 'package:namma_bike/helper/core/routes.dart';
import 'package:namma_bike/helper/core/string_constant.dart';
import 'package:namma_bike/helper/storage/local_storage.dart';
import 'package:namma_bike/model/Authentication/message_response_model.dart';
import 'package:namma_bike/model/Settings/admin_details_model.dart';
import 'package:namma_bike/utility/dio_exception.dart';

class SettingController with ChangeNotifier {
  String currentAddresss = '';
  double currentLatitude = 0.0;
  double currentlongitude = 0.0;
  StroDetailsModel? stroDetailsModel;
  List<StoreData> storeDetailsList = [];
  String? contactUs;
  String? termCondition;
  String? privacyPolicy;
  String? agrimentPolicy;
  String? shippingPolicy;
  String? faq;

  Future getCurrentLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      await Geolocator.requestPermission();
    } else {
      Geolocator.getCurrentPosition().then((value) async {
        currentLatitude = value.latitude;
        currentlongitude = value.longitude;
        notifyListeners();
        List<Placemark> placemark =
            await placemarkFromCoordinates(value.latitude, value.longitude);

        var address;
        address = placemark[0].name;
        address = address + ',' + placemark[0].subLocality;
        address = address + ',' + placemark[0].locality;
        address = address + ',' + placemark[0].administrativeArea;
        address = address + ',' + placemark[0].country;
        address = address + ',' + placemark[0].postalCode;
        currentAddresss = address ?? '';

        notifyListeners();
      });
    }
  }

  Future<void> updateFcmToken(String userId, context) async {
    try {
      final fcmToken = await LocalStorage.getUseFcmTokentSF();

      var paremeters = {
        USERID: userId,
        FCMKEY: fcmToken,
      };
      final response =
          await ApiBaseHelper.postAPICall(ApiEndPoint.updateFcm, paremeters);

      if (response != null) {
      } else {}
    } catch (e) {
      log("Error occurred: $e");
      notifyListeners();
      DioExceptionhandler.errorHandler(e);
    }
  }

  ///--------------------------get Strore Details-------------------------------------///
  bool isLoadgetDetails = false;
  void getStoreDetails(
    BuildContext context,
  ) async {
    try {
      isLoadgetDetails = true;
      notifyListeners();

      final response =
          await ApiBaseHelper.getAPICall(ApiEndPoint.getSettings, {});

      if (response != null) {
        stroDetailsModel = StroDetailsModel.fromJson(response);

        if (stroDetailsModel != null) {
          if (stroDetailsModel!.status == true) {
            List<StoreData> data = ((response['data']) as List)
                .map((data) => StoreData.fromJson(data))
                .toList();
            storeDetailsList = data;
            notifyListeners();

            for (var i = 0; i < storeDetailsList.length; i++) {
              if (kDebugMode) {
                print(storeDetailsList[i].settingKeys.toString());
              }
              if (storeDetailsList[i].settingKeys == 'Privacy Policy') {
                privacyPolicy = storeDetailsList[i].value;
                notifyListeners();
              } else if (storeDetailsList[i].settingKeys ==
                  'Terms And Condition') {
                termCondition = storeDetailsList[i].value;
                notifyListeners();
              } else if (storeDetailsList[i].settingKeys == 'Contact Us') {
                contactUs = storeDetailsList[i].value;
                notifyListeners();
              } else if (storeDetailsList[i].settingKeys == 'FAQ') {
                faq = storeDetailsList[i].value;
                notifyListeners();
              } else if (storeDetailsList[i].settingKeys ==
                  'Agreement Policy') {
                agrimentPolicy = storeDetailsList[i].value;
                notifyListeners();
              } else {
                // pp = 'No Details Found!';
              }
            }

            isLoadgetDetails = false;
            notifyListeners();
          } else {
            storeDetailsList = [];
            showToast(
                msg: stroDetailsModel!.message ?? '',
                clr: AppColoring.errorPopUp);
            isLoadgetDetails = false;
            notifyListeners();
          }
        } else {
          isLoadgetDetails = false;

          notifyListeners();
        }
      } else {
        isLoadgetDetails = false;

        notifyListeners();
      }
    } catch (e) {
      isLoadgetDetails = false;
      log("Error occurred: $e");
      notifyListeners();
      DioExceptionhandler.errorHandler(e);
    }
  }
}
