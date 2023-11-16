import 'package:flutter/material.dart';
import 'package:namma_bike/helper/api/api_post_request.dart';
import 'package:namma_bike/helper/api/endpoint_constant.dart';
import 'package:namma_bike/helper/core/color_constant.dart';
import 'package:namma_bike/helper/core/message.dart';
import 'package:namma_bike/helper/core/routes.dart';
import 'package:namma_bike/helper/core/string_constant.dart';
import 'package:namma_bike/model/Authentication/message_response_model.dart';
import 'package:namma_bike/utility/dio_exception.dart';
import 'package:namma_bike/view/Authentication/screen_loginwithotp.dart';

class SendOTPController with ChangeNotifier {
  TextEditingController mobileController = TextEditingController();
  bool checkedValue = true;
  MessageModel? model;
  void onRememberMeChecked(bool newValue) {
    checkedValue = newValue;
    notifyListeners();
  }

  bool isLoadSndOtp = false;
  void loginSndotp(BuildContext context) async {
    try {
      isLoadSndOtp = true;
      notifyListeners();

      var paremeters = {
        MOBILE: mobileController.text,
        // OTP: '',
      };

      await ApiBaseHelper.postAPICall(ApiEndPoint.userLogin, paremeters)
          .then((value) {
        model = MessageModel.fromJson(value);
        if (model != null) {
          if (model!.status == true) {
            showToast(msg: model!.message ?? '', clr: AppColoring.successPopup);
            RouteConstat.nextNamed(
                context,
                ScreenLogin(
                  mobile: mobileController.text,
                ));
            isLoadSndOtp = false;
            notifyListeners();
          } else {
            showToast(msg: model!.message ?? '', clr: AppColoring.errorPopUp);
            isLoadSndOtp = false;
            notifyListeners();
          }
        } else {
          isLoadSndOtp = false;
          notifyListeners();
        }
      });
    } catch (e) {
      isLoadSndOtp = false;
      notifyListeners();
      DioExceptionhandler.errorHandler(e);
    }
  }
}
