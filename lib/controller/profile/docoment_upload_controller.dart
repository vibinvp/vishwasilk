import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:namma_bike/helper/api/api_headers.dart';
import 'package:namma_bike/helper/api/api_post_request.dart';
import 'package:namma_bike/helper/api/base_constatnt.dart';
import 'package:namma_bike/helper/api/endpoint_constant.dart';
import 'package:namma_bike/helper/core/app_constant.dart';
import 'package:namma_bike/helper/core/color_constant.dart';
import 'package:namma_bike/helper/core/message.dart';
import 'package:namma_bike/helper/core/string_constant.dart';
import 'package:namma_bike/helper/storage/local_storage.dart';
import 'package:namma_bike/model/Authentication/message_response_model.dart';
import 'package:namma_bike/model/profile/user_details_model.dart';
import 'package:namma_bike/utility/dio_exception.dart';

class DocumentuploadController with ChangeNotifier {
  UserDetailsModel? userDetailsModel;
  MessageModel? updatemodel;
  File? adharimage;
  String adharGetImage = '';
  Future<void> getImage(ImageSource source, String type) async {
    final pikImage = await ImagePicker().pickImage(
      source: source,
    );
    if (pikImage == null) {
      return;
    } else {
      final imageTemp = File(pikImage.path);
      if (type == 'adhar') {
        adharimage = imageTemp;
        print("adharimage image picked  $adharimage ");
      }

      notifyListeners();
    }
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
            adharGetImage = userDetailsModel!.data![0].vendorAdhar ?? '';

            log('${ApiBaseConstant.baseMainUrl}${AppConstant.profileImageUrl}     ');
            notifyListeners();

            isLoadFetchUser = false;
            notifyListeners();
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
      String adharImagePath = adharimage?.path ?? '';

      log('$adharImagePath----------------');

      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        USERID: userId,
        ADHARIMAGE: adharImagePath.isEmpty
            ? ''
            : await MultipartFile.fromFile(
                adharImagePath,
                filename: adharImagePath
                    .split('/')
                    .last, // Use the last part of the path as filename
              ),
      });

      log(formData.fields.toString());

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
}
