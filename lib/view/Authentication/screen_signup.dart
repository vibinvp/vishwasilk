import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:namma_bike/controller/Authentication/sign_up_controller.dart';
import 'package:namma_bike/helper/core/app_spacing.dart';
import 'package:namma_bike/helper/core/color_constant.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:namma_bike/helper/core/message.dart';
import 'package:namma_bike/helper/core/routes.dart';
import 'package:namma_bike/view/Authentication/screen_sndotp.dart';
import 'package:namma_bike/view/map/screen_map.dart';
import 'package:namma_bike/widget/app_loader_widget.dart';
import 'package:namma_bike/widget/textfeild_widget.dart';
import 'package:provider/provider.dart';

class ScreenSignUp extends StatefulWidget {
  const ScreenSignUp({super.key});

  @override
  State<ScreenSignUp> createState() => _ScreenSignUpState();
}

class _ScreenSignUpState extends State<ScreenSignUp> {
  late SignUpController signUpController;

  @override
  void initState() {
    signUpController = Provider.of<SignUpController>(context, listen: false);
    signUpController.mobileController.clear();
    signUpController.nameController.clear();
    signUpController.cityController.clear();
    signUpController.emailController.clear();
    signUpController.stateController.clear();
    signUpController.pincodeController.clear();
    signUpController.getCurrentLocation();
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
            welcomeTextRow(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: form(),
            ),
            const SizedBox(height: 40),
            termsAndConditions(),
            const SizedBox(height: 30),
            button(),
            AppSpacing.ksizedBox40,
            signInButton(),
          ],
        ),
      ),
    );
  }

  Widget buttonMap(String text, void Function()? onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 35,
              color: AppColoring.kAppColor,
            ),
            Text(text)
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
          "SIGN UP",
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
          numberTextFormField(),
          AppSpacing.ksizedBox15,
          textFormFieldWidget(
              'Name', signUpController.nameController, TextInputType.name),
          AppSpacing.ksizedBox15,
          textFormFieldWidget('E-mail', signUpController.emailController,
              TextInputType.emailAddress),
          AppSpacing.ksizedBox15,
          AppSpacing.ksizedBox15,
          Row(
            children: [
              Expanded(
                child: textFormFieldAddressWidget(
                    'Address', signUpController.addressController),
              ),
              buttonMap('From Map', () {
                RouteConstat.nextNamed(
                  context,
                  MapScreen(
                    latitudeController: signUpController.latitudeController,
                    longitudeController: signUpController.longitudeController,
                    addressController: signUpController.addressController,
                    cityController: signUpController.cityController,
                    pinCodeController: signUpController.pincodeController,
                    stateController: signUpController.stateController,
                  ),
                );
              }),
            ],
          ),
          AppSpacing.ksizedBox15,
          textFormFieldWidget(
              'City', signUpController.cityController, TextInputType.name),
          AppSpacing.ksizedBox15,
          textFormFieldWidget(
              'State', signUpController.stateController, TextInputType.name),
          AppSpacing.ksizedBox15,
          textFormFieldWidget('Pincode', signUpController.pincodeController,
              TextInputType.number),
        ],
      ),
    );
  }

  Widget textFormFieldWidget(String text, TextEditingController? controller,
      TextInputType? keyboardType) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppColoring.primeryBorder),
          borderRadius: BorderRadius.circular(10)),
      child: TextfeildWidget(
        text: text,
        controller: controller,
        keyboardType: keyboardType,
      ),
    );
  }

  Widget textFormFieldAddressWidget(
      String text, TextEditingController? controller) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: AppColoring.primeryBorder),
            borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: AppColoring.primeryBorder),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              maxLength: 1000,
              maxLines: 3,
              readOnly: false,
              //autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.text,

              controller: controller,
              decoration: InputDecoration(
                counterText: "",
                border: InputBorder.none,
                hintText: text,
                hintStyle: const TextStyle(fontSize: 14),
                // suffixIcon: suffixIcon,
                // prefixIcon: prefixIcon,
                // border: border,
              ),
            ),
          ),
        ));
  }

  Widget numberTextFormField() {
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
          textFieldController: signUpController.mobileController,
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
        builder: (context, SignUpController signup, child) {
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
            value: signup.checkedValue,
            onChanged: (newValue) {
              signup.onRememberMeChecked(newValue!);
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
        builder: (context, SignUpController value, child) {
          return value.isLoadRegister
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
                    if (value.mobileController.text.length != 10) {
                      showToast(
                          msg: 'Enter valid mobile number ',
                          clr: AppColoring.errorPopUp);
                    } else if (!isValidEmail(value.emailController.text)) {
                      showToast(
                        msg: 'Enter a valid email address',
                        clr: AppColoring.errorPopUp,
                      );
                    } else if (value.nameController.text == '' ||
                        value.nameController.text.isEmpty ||
                        value.emailController.text == '' ||
                        value.emailController.text.isEmpty ||
                        value.cityController.text == '' ||
                        value.cityController.text.isEmpty ||
                        value.stateController.text == '' ||
                        value.stateController.text.isEmpty ||
                        value.pincodeController.text == '' ||
                        value.pincodeController.text.isEmpty) {
                      showToast(
                          msg: 'Enter the all fields correctly',
                          clr: AppColoring.errorPopUp);
                    } else if (value.checkedValue == false) {
                      showToast(
                          msg: 'Please accept terms & conditons ',
                          clr: AppColoring.errorPopUp);
                    } else {
                      value.registerUser(context);
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
                      'Sign Up',
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

  bool isValidEmail(String email) {
    // Regular expression for basic email validation
    String emailRegex = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }

  Widget signInButton() {
    return RichText(
      text: TextSpan(
        text: "Already have an account?  ",
        children: [
          TextSpan(
            text: "Sign In",
            style: const TextStyle(
                color: AppColoring.kAppColor,
                fontSize: 18,
                fontWeight: FontWeight.w500),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                RouteConstat.nextRemoveUntileNamed(
                    context, const ScreenSndOTP());
              },
          ),
        ],
        style: const TextStyle(color: AppColoring.textDim, fontSize: 18),
      ),
    );
  }
}
