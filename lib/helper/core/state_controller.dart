import 'package:namma_bike/controller/Authentication/login_controller.dart';
import 'package:namma_bike/controller/Authentication/sign_up_controller.dart';
import 'package:namma_bike/controller/Authentication/snd_otp_controller.dart';
import 'package:namma_bike/controller/Settings/settind_controller.dart';
import 'package:namma_bike/controller/home/home_controller.dart';
import 'package:namma_bike/controller/profile/docoment_upload_controller.dart';
import 'package:namma_bike/controller/profile/profile_controller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProviderStateController {
  static List<SingleChildWidget> providers = [

    ChangeNotifierProvider(
      create: (context) => SendOTPController(),
    ),
    ChangeNotifierProvider(
      create: (context) => LoginController(),
    ),
    ChangeNotifierProvider(
      create: (context) => SignUpController(),
    ),
    ChangeNotifierProvider(
      create: (context) => SettingController(),
    ),
    ChangeNotifierProvider(
      create: (context) => ProfileController(),
    ),
    ChangeNotifierProvider(
      create: (context) => HomeController(),
    ),
 
    ChangeNotifierProvider(
      create: (context) => DocumentuploadController(),
    ),

  ];
}
