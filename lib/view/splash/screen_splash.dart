//
// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:namma_bike/controller/home/home_controller.dart';
import 'package:namma_bike/helper/core/routes.dart';
import 'package:namma_bike/helper/storage/local_storage.dart';
import 'package:namma_bike/utility/local_notification_service.dart';
import 'package:namma_bike/utility/push_notification.dart';
import 'package:namma_bike/utility/utils.dart';
import 'package:namma_bike/view/Authentication/screen_sndotp.dart';
import 'package:namma_bike/view/home/screen_home.dart';
import 'package:provider/provider.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<ScreenSplash>
    with SingleTickerProviderStateMixin {
  var _visible = true;
  void checkLogin() async {
    final user = await LocalStorage.getUserLoggedInStatus();
    log(user.toString());
    if (user == 'true') {
      RouteConstat.nextRemoveUntileNamed(context, const ScreenHome());
    } else {
      RouteConstat.nextRemoveUntileNamed(context, const ScreenSndOTP());
    }
  }

  AnimationController? animationController;
  Animation<double>? animation;
  startTime() async {
    await Geolocator.requestPermission();
    var duration = const Duration(seconds: 2);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    checkLogin();
  }

  @override
  dispose() {
    animationController!.dispose(); // you need this
    super.dispose();
  }
 late HomeController homeController;
  @override
  void initState() {
        homeController = Provider.of<HomeController>(context, listen: false);
    //notofication----------------

    FireBasePushNotificationService.notificationControll(context);
    LocalNotificationService.initnotification();

    //notofication----------------
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    animation =
        CurvedAnimation(parent: animationController!, curve: Curves.easeOut);

    animation!.addListener(() => setState(() {}));
    animationController!.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();

     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      homeController.getBanners(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                Utils.setPngPath("logo"),
                width: animation!.value * 250,
                height: animation!.value * 250,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
