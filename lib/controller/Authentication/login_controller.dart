// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:namma_bike/controller/Settings/settind_controller.dart';
import 'package:namma_bike/helper/api/api_post_request.dart';
import 'package:namma_bike/helper/api/endpoint_constant.dart';
import 'package:namma_bike/helper/core/color_constant.dart';
import 'package:namma_bike/helper/core/message.dart';
import 'package:namma_bike/helper/core/routes.dart';
import 'package:namma_bike/helper/core/string_constant.dart';
import 'package:namma_bike/helper/storage/local_storage.dart';
import 'package:namma_bike/model/Authentication/login_model.dart';
import 'package:namma_bike/utility/dio_exception.dart';
import 'package:namma_bike/view/home/screen_home.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:provider/provider.dart';

class LoginController with ChangeNotifier {
  OtpFieldController otpController = OtpFieldController();
  TextEditingController enteirdOTPController = TextEditingController();
  int timeRemaining = 59;
  bool isShowPIN = true;
  bool enableResend = false;
  late Timer timer;
  LoginModel? loginModel;

  setPinFromPayment(String pin) {
    enteirdOTPController.text = pin;
    log('PIN ---------${enteirdOTPController.text}');
    notifyListeners();
  }

  showPin() {
    isShowPIN = !isShowPIN;
    notifyListeners();
  }

  void setTimer() {
    timeRemaining = 59;
    notifyListeners();
  }

  void changeTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (timeRemaining != 0) {
          timeRemaining--;
          notifyListeners();
        } else {
          enableResend = true;
          notifyListeners();
        }
      },
    );
  }

  void setResendVisibility(bool newValue) {
    // enableResend = newValue;
    timeRemaining = 59;
    notifyListeners();
  }

  bool isLoadLogin = false;
  void loginUser(String phone, BuildContext context) async {
    try {
      isLoadLogin = true;
      notifyListeners();

      var paremeters = {
        MOBILE: phone,
        OTP: enteirdOTPController.text,
      };

      await ApiBaseHelper.postAPICall(ApiEndPoint.userLogin, paremeters)
          .then((value) async {
        loginModel = LoginModel.fromJson(value);
        if (loginModel != null) {
          if (loginModel!.status == true) {
            var getmodel = loginModel!.data![0];
            await LocalStorage.saveUserLoggedInStatus('true');
            await LocalStorage.saveUserEmailSF(getmodel.email.toString());
            await LocalStorage.saveNameSF(getmodel.username.toString());
            await LocalStorage.saveUserUserIdSF(getmodel.userId.toString());
            await LocalStorage.saveUserNameSF(getmodel.username.toString());
            await LocalStorage.saveUserAddressSF(getmodel.address.toString());
            await LocalStorage.saveUserPPSF(getmodel.image.toString());
            await LocalStorage.saveUserCitySF(getmodel.city.toString());
            await LocalStorage.saveUserLatSF(getmodel.latitude.toString());
            await LocalStorage.saveUserLngSF(getmodel.longitude.toString());
            await LocalStorage.saveUserSexSF(getmodel.gender.toString());
            await LocalStorage.saveUserPincodeSF(getmodel.pincode.toString());
            await LocalStorage.saveUserStateInSF(getmodel.state.toString());
            showToast(
                msg: loginModel!.message ?? '', clr: AppColoring.successPopup);

            RouteConstat.nextRemoveUntileNamed(context, const ScreenHome());
            await context
                .read<SettingController>()
                .updateFcmToken(getmodel.userId ?? '', context);

            isLoadLogin = false;
            notifyListeners();
          } else {
            showToast(
                msg: loginModel!.message ?? '', clr: AppColoring.errorPopUp);
            isLoadLogin = false;
            notifyListeners();
          }
        } else {
          isLoadLogin = false;
          notifyListeners();
        }
      });
    } catch (e) {
      DioExceptionhandler.errorHandler(e);
    }
  }
}
