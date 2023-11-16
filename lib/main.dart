import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:namma_bike/helper/core/app_constant.dart';
import 'package:namma_bike/helper/core/color_constant.dart';
import 'package:namma_bike/helper/core/state_controller.dart';
import 'package:namma_bike/utility/push_notification.dart';
import 'package:namma_bike/view/splash/screen_splash.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

int notifId = 0;
@pragma('vm:entry-point')
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(
      FireBasePushNotificationService.firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ProviderStateController.providers,
      child: MaterialApp(
        builder: (context, child) {
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        title: AppConstant.appName,
        theme: ThemeData(
          primarySwatch: AppColoring.primaryApp,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColoring.primaryApp.withOpacity(.1),
            // seedColor: const Color(0xffFFFF00),
          ),
          //  seedColor: const Color.fromARGB(255, 255, 255, 255)),
          useMaterial3: true,
        ),
        home: const ScreenSplash(),
      ),
    );
  }
}
