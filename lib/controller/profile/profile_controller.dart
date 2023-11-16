// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:namma_bike/helper/api/api_headers.dart';
import 'package:namma_bike/helper/api/api_post_request.dart';
import 'package:namma_bike/helper/api/endpoint_constant.dart';
import 'package:namma_bike/helper/core/color_constant.dart';
import 'package:namma_bike/helper/core/message.dart';
import 'package:namma_bike/helper/core/routes.dart';
import 'package:namma_bike/helper/core/string_constant.dart';
import 'package:namma_bike/helper/storage/local_storage.dart';
import 'package:namma_bike/model/Authentication/message_response_model.dart';
import 'package:namma_bike/model/profile/user_details_model.dart';
import 'package:namma_bike/utility/dio_exception.dart';
import 'package:namma_bike/view/Authentication/screen_sndotp.dart';

class ProfileController with ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  UserDetailsModel? userDetailsModel;
  MessageModel? updatemodel;
  String profilePic = "";
  String? dropDownValueGender;
  bool enable = false;
  File? image;
  Future<void> getImage(ImageSource source) async {
    final pikImage = await ImagePicker().pickImage(
      source: source,
    );
    if (pikImage == null) {
      return;
    } else {
      final imageTemp = File(pikImage.path);
      image = imageTemp;

      notifyListeners();
      log("image picked  $image ");
    }
  }

  void enableMap() {
    enable = true;
    notifyListeners();
  }

  void selectGender(String val) {
    dropDownValueGender = val;
    log(dropDownValueGender.toString());
    notifyListeners();
  }

  bool isLoadFetchUser = false;
  void getUserDetails(BuildContext context) async {
    try {
      isLoadFetchUser = true;
      notifyListeners();
      final userId = await LocalStorage.getUserUserIdSF();

      var paremeters = {
        USERID: userId,
      };

      await ApiBaseHelper.postAPICall(ApiEndPoint.getUser, paremeters)
          .then((value) async {
        if (value != null) {
          userDetailsModel = UserDetailsModel.fromJson(value);
          if (userDetailsModel!.status == true) {
            nameController.text = userDetailsModel!.data![0].vendorName ?? '';
            emailController.text = userDetailsModel!.data![0].vendorEmail ?? '';
            mobileController.text =
                userDetailsModel!.data![0].vendorMobile ?? '';
            pincodeController.text =
                userDetailsModel!.data![0].vendorPincode ?? '';
            stateController.text = userDetailsModel!.data![0].state ?? '';
            latitudeController.text =
                userDetailsModel!.data![0].lattitude ?? '';
            longitudeController.text =
                userDetailsModel!.data![0].longitude ?? '';
            cityController.text = userDetailsModel!.data![0].vendorCity ?? '';
            addressController.text =
                userDetailsModel!.data![0].vendorAddress ?? '';
            dropDownValueGender = null;

            profilePic = userDetailsModel!.data![0].vendorPhoto ?? '';

            if (addressController.text != '' ||
                addressController.text.isNotEmpty) {
              enable = true;
            }

            isLoadFetchUser = false;
            notifyListeners();
            await LocalStorage.saveUserLoggedInStatus('true');
            await LocalStorage.saveUserEmailSF(
                userDetailsModel!.data![0].vendorEmail ?? '');
            await LocalStorage.saveNameSF(
                userDetailsModel!.data![0].vendorName ?? '');
            await LocalStorage.saveUserUserIdSF(
                userDetailsModel!.data![0].vendorId ?? '');
            await LocalStorage.saveUserNameSF(
                userDetailsModel!.data![0].vendorName ?? '');
            await LocalStorage.saveUserAddressSF(
                userDetailsModel!.data![0].vendorAddress ?? '');
            await LocalStorage.saveUserPPSF(
                userDetailsModel!.data![0].vendorPhoto ?? '');
            await LocalStorage.saveUserCitySF(
                userDetailsModel!.data![0].vendorCity ?? '');
            await LocalStorage.saveUserLatSF(
                userDetailsModel!.data![0].lattitude ?? '');
            await LocalStorage.saveUserLngSF(
                userDetailsModel!.data![0].longitude ?? '');

            await LocalStorage.saveUserPincodeSF(
                userDetailsModel!.data![0].vendorPincode ?? '');
            await LocalStorage.saveUserStateInSF(
                userDetailsModel!.data![0].state ?? '');
          } else {
            isLoadFetchUser = false;
            notifyListeners();
          }
        } else {
          isLoadFetchUser = false;
          notifyListeners();
        }
      });
    } catch (e) {
      DioExceptionhandler.errorHandler(e);
    }
  }

  bool isLoadUpdateUser = false;
  void updateUser(BuildContext context) async {
    try {
      isLoadUpdateUser = true;
      notifyListeners();

      final userId = await LocalStorage.getUserUserIdSF();
      String imagePath = image?.path ?? '';
      print('$imagePath  ----------');
      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        USERID: userId,
        USERNAME: nameController.text,
        EMAIL: emailController.text,
        MOBILE: mobileController.text,
        CITY: cityController.text,
        PINCODE: pincodeController.text,
        STATE: stateController.text,
        ADDRESS: addressController.text,
        LATITUDE: latitudeController.text,
        LONGITUDE: longitudeController.text,
        VENDORIMAGE: imagePath.isEmpty
            ? ''
            : await MultipartFile.fromFile(
                imagePath,
                filename: imagePath
                    .split('/')
                    .last, // Use the last part of the path as filename
              ),
      });
      Response response = await dio.post(ApiEndPoint.updateProfile,
          data: formData, options: Options(headers: ApiHeader.headers));

      updatemodel = MessageModel.fromJson(response.data);

      if (updatemodel != null) {
        if (updatemodel!.status == true) {
          showToast(
              msg: updatemodel!.message ?? '', clr: AppColoring.successPopup);

          isLoadUpdateUser = false;
          notifyListeners();
          getUserDetails(context);
        } else {
          showToast(
              msg: updatemodel!.message ?? '', clr: AppColoring.errorPopUp);
          isLoadUpdateUser = false;
          notifyListeners();
        }
      }
    } catch (e) {
      print(e.toString());
      isLoadUpdateUser = false;
      notifyListeners();
      DioExceptionhandler.errorHandler(e);
    } finally {}
  }

  //////////////---------------------Logout----------------------------///

  void appLogOut(BuildContext context) async {
    await LocalStorage.saveUserLoggedInStatus('false');
    await LocalStorage.saveUserEmailSF("");
    await LocalStorage.saveNameSF("");
    await LocalStorage.saveUserUserIdSF("");
    await LocalStorage.saveUserNameSF("");
    await LocalStorage.saveUserAddressSF("");
    await LocalStorage.saveUserPPSF("");
    await LocalStorage.saveUserCitySF("");
    await LocalStorage.saveUserLatSF("");
    await LocalStorage.saveUserLngSF("");
    await LocalStorage.saveUserSexSF("");
    await LocalStorage.saveUserPincodeSF("");
    await LocalStorage.saveUserPPSF("");

    notifyListeners();
    RouteConstat.nextRemoveUntileNamed(context, const ScreenSndOTP());
    showToast(msg: "Logout Successfully", clr: Colors.green);
    notifyListeners();
  }
}
