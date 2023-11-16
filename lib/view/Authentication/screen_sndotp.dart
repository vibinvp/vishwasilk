import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:namma_bike/controller/Authentication/snd_otp_controller.dart';
import 'package:namma_bike/helper/core/app_constant.dart';
import 'package:namma_bike/helper/core/app_spacing.dart';
import 'package:namma_bike/helper/core/color_constant.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:namma_bike/helper/core/message.dart';
import 'package:namma_bike/helper/core/routes.dart';
import 'package:namma_bike/utility/utils.dart';
import 'package:namma_bike/view/Authentication/screen_loginwithotp.dart';
import 'package:namma_bike/view/Authentication/screen_signup.dart';
import 'package:namma_bike/view/home/screen_home.dart';
import 'package:namma_bike/widget/app_loader_widget.dart';
import 'package:namma_bike/widget/textfeild_widget.dart';
import 'package:provider/provider.dart';

class ScreenSndOTP extends StatefulWidget {
  const ScreenSndOTP({super.key});

  @override
  State<ScreenSndOTP> createState() => _ScreenSndOTPState();
}

class _ScreenSndOTPState extends State<ScreenSndOTP> {
  late SendOTPController sendOTPController;

  @override
  void initState() {
    sendOTPController = Provider.of<SendOTPController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      sendOTPController.mobileController.clear();
      sendOTPController.isLoadSndOtp = false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColoring.kAppBlueColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: SizedBox(
                height: 160,
                child: Image.asset(Utils.setPngPath("logo")),
              ),
            ),
            AppSpacing.ksizedBox50,
            welcomeTextRow(),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: form(),
            ),
            const SizedBox(height: 40),
            termsAndConditions(),
            const SizedBox(height: 30),
            button(),
            AppSpacing.ksizedBox40,
            signUpButton(),
          ],
        ),
      ),
    );
  }

  Widget welcomeTextRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AppSpacing.ksizedBoxW30,
        Text(
          "SIGN IN",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColoring.textDark),
        ),
      ],
    );
  }

  Widget form() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: <Widget>[
          usernameTextFormField(),
          // AppSpacing.ksizedBox15,
          // otpTextFormField(),
        ],
      ),
    );
  }

  Widget otpTextFormField() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppColoring.primeryBorder),
          borderRadius: BorderRadius.circular(10)),
      child: const TextfeildWidget(text: 'Enter OTP'),
    );
  }

  Widget usernameTextFormField() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppColoring.primeryBorder),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: InternationalPhoneNumberInput(
          onInputChanged: (PhoneNumber number) {
            debugPrint(number.phoneNumber);
          },
          onInputValidated: (bool value) {
            debugPrint(value.toString());
          },
          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          ),
          ignoreBlank: false,
          autoValidateMode: AutovalidateMode.disabled,
          selectorTextStyle: const TextStyle(color: AppColoring.textDark),
          textFieldController: sendOTPController.mobileController,
          formatInput: false,
          maxLength: 10,
          initialValue: PhoneNumber(isoCode: 'IN'),
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          cursorColor: AppColoring.kAppColor,
          inputDecoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 15, left: 0),
            border: InputBorder.none,
            hintText: 'Phone Number',
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
          onSaved: (PhoneNumber number) {
            debugPrint('On Saved: $number');
          },
        ),
      ),
    );
  }

  Widget forgetPassTextRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          onTap: () {},
          child: const Text(
            "Forgot password?      ",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColoring.kAppColor,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget termsAndConditions() {
    return SizedBox(
      height: 40,
      child: Consumer(
        builder: (context, SendOTPController sndContr, child) {
          return CheckboxListTile(
            title: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'I agree with',
                    style: TextStyle(fontSize: 14),
                  ),
                  TextSpan(
                    text: ' Terms & Condition',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 14),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                ],
              ),
            ),
            value: sndContr.checkedValue,
            onChanged: (newValue) {
              sndContr.onRememberMeChecked(newValue!);
            },
            controlAffinity: ListTileControlAffinity.leading,
          );
        },
      ),
    );
  }

  Widget button() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Consumer(
        builder: (context, SendOTPController value, child) {
          return value.isLoadSndOtp
              ? const LoadreWidget()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    padding: const EdgeInsets.all(0.0),
                    textStyle: const TextStyle(color: AppColoring.kAppColor),
                  ),
                  onPressed: () {
                    //  RouteConstat.nextNamed(context, const ScreenHome());
                    if (value.mobileController.text.length != 10) {
                      showToast(
                          msg: 'Enter valid mobile number ',
                          clr: AppColoring.errorPopUp);
                    } else if (value.checkedValue == false) {
                      showToast(
                          msg: 'Please accept terms & conditons ',
                          clr: AppColoring.errorPopUp);
                    } else {
                      value.loginSndotp(context);
                    }
                  },
                  child: Container(
                    height: 55,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColoring.kAppColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: const Text(
                      'Send OTP',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColoring.kAppWhiteColor,
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget signUpButton() {
    return RichText(
      text: TextSpan(
        text: "Don't have an account?  ",
        children: [
          TextSpan(
            text: "Sign Up",
            style: const TextStyle(
                color: AppColoring.kAppColor,
                fontSize: 18,
                fontWeight: FontWeight.w500),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                RouteConstat.nextNamed(context, const ScreenSignUp());
              },
          ),
        ],
        style: const TextStyle(color: AppColoring.textDim, fontSize: 18),
      ),
    );
  }
}
