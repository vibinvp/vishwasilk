import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:namma_bike/helper/api/api_post_request.dart';
import 'package:namma_bike/helper/api/endpoint_constant.dart';
import 'package:namma_bike/helper/core/color_constant.dart';
import 'package:namma_bike/helper/core/message.dart';
import 'package:namma_bike/helper/core/routes.dart';
import 'package:namma_bike/helper/core/string_constant.dart';
import 'package:namma_bike/model/Authentication/register_model.dart';
import 'package:namma_bike/utility/dio_exception.dart';
import 'package:namma_bike/view/Authentication/screen_sndotp.dart';

class SignUpController with ChangeNotifier {
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  RegisterModel? registerModel;
  bool checkedValue = true;
  void onRememberMeChecked(bool newValue) {
    checkedValue = newValue;
    notifyListeners();
  }

  Future getCurrentLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      await Geolocator.requestPermission();
    } else {
      Geolocator.getCurrentPosition().then((value) async {
        latitudeController.text = value.latitude.toString();
        longitudeController.text = value.longitude.toString();

        log(latitudeController.text.toString());
        log(longitudeController.text.toString());
        List<Placemark> placemark =
            await placemarkFromCoordinates(value.latitude, value.longitude);

        var address;
        address = placemark[0].name;
        address = address + ',' + placemark[0].subLocality;
        address = address + ',' + placemark[0].locality;
        address = address + ',' + placemark[0].administrativeArea;
        address = address + ',' + placemark[0].country;
        address = address + ',' + placemark[0].postalCode;
        addressController.text = address ?? '';
        cityController.text = placemark[0].locality ?? '';
        pincodeController.text = placemark[0].postalCode ?? '';
        stateController.text = placemark[0].administrativeArea ?? '';
        notifyListeners();
      });
    }
  }

  bool isLoadRegister = false;
  void registerUser(BuildContext context) async {
    try {
      isLoadRegister = true;
      notifyListeners();

      var paremeters = {
        USERNAME: nameController.text,
        EMAIL: emailController.text,
        MOBILE: mobileController.text,
        CITY: cityController.text,
        PINCODE: pincodeController.text,
        STATE: stateController.text,
        ADDRESS: addressController.text,
        LATITUDE: latitudeController.text,
        LONGITUDE: longitudeController.text,
      };

      await ApiBaseHelper.postAPICall(ApiEndPoint.userRegister, paremeters)
          .then((value) {
        registerModel = RegisterModel.fromJson(value);
        if (registerModel != null) {
          if (registerModel!.status == true) {
            showToast(
                msg: registerModel!.message ?? '',
                clr: AppColoring.successPopup);
            RouteConstat.nextRemoveUntileNamed(context, const ScreenSndOTP());
            isLoadRegister = false;
            notifyListeners();
          } else {
            showToast(
                msg: registerModel!.message ?? '', clr: AppColoring.errorPopUp);
            isLoadRegister = false;
            notifyListeners();
          }
        } else {
          isLoadRegister = false;
          notifyListeners();
        }
      });
    } catch (e) {
      isLoadRegister = false;
      notifyListeners();
      DioExceptionhandler.errorHandler(e);
    }
  }
}
