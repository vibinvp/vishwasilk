import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:namma_bike/controller/Authentication/login_controller.dart';
import 'package:namma_bike/controller/Authentication/snd_otp_controller.dart';
import 'package:namma_bike/helper/core/app_spacing.dart';
import 'package:namma_bike/helper/core/color_constant.dart';
import 'package:namma_bike/helper/core/message.dart';
import 'package:namma_bike/helper/core/routes.dart';
import 'package:namma_bike/utility/utils.dart';
import 'package:namma_bike/view/home/screen_home.dart';
import 'package:namma_bike/widget/app_loader_widget.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:otp_text_field/otp_text_field.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({
    super.key,
    required this.mobile,
  });
  final String mobile;

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  late LoginController loginController;

  @override
  void initState() {
    loginController = Provider.of<LoginController>(context, listen: false);
    loginController.changeTimer();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loginController.setTimer();
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
            otpText(),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: form(),
            ),
            const SizedBox(height: 40),
            const SizedBox(height: 30),
            button(),
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
          "Verification",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: AppColoring.textDark),
        ),
      ],
    );
  }

  otpText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Add verification code sent on your number',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: AppColoring.textDark.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: <Widget>[
          otpTextFormField(),
        ],
      ),
    );
  }

  Widget otpTextFormField() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 5, top: 20),
      child: Consumer(
        builder: (context, LoginController value, child) {
          return Column(
            children: [
              OTPTextField(
                  controller: loginController.otpController,
                  length: 5,
                  width: MediaQuery.of(context).size.width,
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldWidth: 45,
                  keyboardType: TextInputType.number,
                  obscureText: value.isShowPIN,
                  fieldStyle: FieldStyle.box,
                  outlineBorderRadius: 8,
                  style: const TextStyle(fontSize: 17),
                  onChanged: (pin) {
                    log('PIN Changed: $pin');
                    value.setPinFromPayment(pin);
                  },
                  onCompleted: (pin) {
                    if (kDebugMode) {
                      print('Completed: $pin');
                    }
                  }),
              AppSpacing.ksizedBox10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  timeCountWidget(),
                  value.isShowPIN
                      ? TextButton.icon(
                          onPressed: () {
                            value.showPin();
                          },
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: AppColoring.kAppColor.withOpacity(.8),
                          ),
                          label: Text(
                            'Show',
                            style: TextStyle(
                              color: AppColoring.kAppColor.withOpacity(.8),
                            ),
                          ),
                        )
                      : TextButton.icon(
                          onPressed: () {
                            value.showPin();
                          },
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: AppColoring.kAppColor.withOpacity(.8),
                          ),
                          label: Text(
                            'Less',
                            style: TextStyle(
                              color: AppColoring.kAppColor.withOpacity(.8),
                            ),
                          ),
                        ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Widget timeCountWidget() {
    return Consumer<LoginController>(
      builder: (BuildContext context, value, Widget? child) {
        return Row(
          children: [
            AppSpacing.ksizedBoxW15,
            value.timeRemaining != 0
                ? Text(
                    '00:${value.timeRemaining}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  )
                : InkWell(
                    onTap: () async {
                      value.setTimer();
                    },
                    child: Text(
                      'RESEND',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  )
          ],
        );
      },
    );
  }

  Widget button() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Consumer(
        builder: (context, LoginController value, child) {
          return value.isLoadLogin
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
                    if (value.enteirdOTPController.text.length != 5) {
                      showToast(
                          msg: 'Enter valid OTP', clr: AppColoring.errorPopUp);
                    } else {
                      value.loginUser(widget.mobile, context);
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
                      'Sign In',
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
}
