import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:namma_bike/controller/profile/profile_controller.dart';
import 'package:namma_bike/helper/api/base_constatnt.dart';
import 'package:namma_bike/helper/core/app_constant.dart';
import 'package:namma_bike/helper/core/app_spacing.dart';
import 'package:namma_bike/helper/core/color_constant.dart';
import 'package:namma_bike/helper/core/routes.dart';
import 'package:namma_bike/utility/utils.dart';
import 'package:namma_bike/view/Account/document_upload.dart';
import 'package:namma_bike/view/Authentication/screen_sndotp.dart';
import 'package:namma_bike/view/HTML_Page/tems_contact_pages.dart';
import 'package:namma_bike/view/Profile/edit_profile.dart';
import 'package:namma_bike/view/Webview/webview.dart';
import 'package:namma_bike/widget/shimmer_effect.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late ProfileController profileController;
  @override
  void initState() {
    profileController = Provider.of<ProfileController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      profileController.getUserDetails(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColoring.kAppColor,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Column(
            children: [
              AppSpacing.ksizedBox15,
              profileData(context),
              AppSpacing.ksizedBox80,
              //  _getDrawerItem('My Bookings', Icons.shopping_bag, 1, context),
              _getDrawerItem('My Profile', Icons.person_2_outlined, 2, context),
              _getDrawerItem('Documents', Icons.file_download, 3, context),
              _getDrawerItem('Privacy Policy', Icons.policy, 4, context),
              _getDrawerItem(
                  'Agreement Policy', Icons.gavel, 9, context),
              _getDrawerItem('Faqs', Icons.chat, 5, context),
              _getDrawerItem('Terms & Conditions', Icons.lock, 6, context),
              _getDrawerItem('Contact Us', Icons.call, 7, context),
              _getDrawerItem('Logout', Icons.logout, 8, context),
            ],
          ),
        )),
      ),
    );
  }

  _getDrawerItem(
      String title, IconData? icon, int index, BuildContext context) {
    return ListTile(
      trailing: const Icon(
        Icons.navigate_next,
        color: AppColoring.kAppColor,
      ),
      leading: Icon(icon),
      dense: true,
      title: Text(
        title == 'Faqs' ? 'FAQs' : title,
        style: const TextStyle(
          color: AppColoring.textDark,
          fontSize: 15,
        ),
      ),
      onTap: () {
        if (index == 1) {
          //  RouteConstat.nextNamed(context, const MyOrders());
        } else if (index == 2) {
          RouteConstat.nextNamed(context, const EditProfileScreen());
        } else if (index == 3) {
          RouteConstat.nextNamed(context, const ScreenUploadDocuments());
        } else if (index == 4) {
          RouteConstat.nextNamed(
              context,
              TermsAndConditionsHtmlView(
                title: title,
                code: title[0],
              ));
          // RouteConstat.nextNamed(
          //     context, WebviewScreen(title, 'https://www.youtube.com/'));
        } else if (index == 5) {
          RouteConstat.nextNamed(
              context,
              TermsAndConditionsHtmlView(
                title: title,
                code: title[0],
              ));
        } else if (index == 6) {
          RouteConstat.nextNamed(
              context,
              TermsAndConditionsHtmlView(
                title: title,
                code: title[0],
              ));
        } else if (index == 7) {
          RouteConstat.nextNamed(
              context,
              TermsAndConditionsHtmlView(
                title: title,
                code: title[0],
              ));
        } else if (index == 8) {
          logoutPOPUP(context);
        } else if (index == 9) {
           RouteConstat.nextNamed(
              context,
              TermsAndConditionsHtmlView(
                title: title,
                code: title[0],
              ));
        }
      },
    );
  }

  Widget profileData(context) {
    return InkWell(
      onTap: () {
        RouteConstat.nextNamed(context, const EditProfileScreen());
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Consumer(
                builder: (context, ProfileController value, child) {
                  return value.userDetailsModel == null
                      ? const SingleItemSimmer()
                      : Row(
                          children: [
                            value.profilePic.isNotEmpty
                                ? Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(80),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(80),
                                      child: CachedNetworkImage(
                                          errorWidget: (context, url, error) {
                                            return const Icon(Icons.error);
                                          },
                                          progressIndicatorBuilder:
                                              (context, url, downloadProgress) {
                                            return const SingleBallnerItemSimmer();
                                          },
                                          fit: BoxFit.fill,
                                          imageUrl:
                                              ApiBaseConstant.baseMainUrl +
                                                  AppConstant.profileImageUrl +
                                                  value.profilePic),
                                    ),
                                  )
                                : Container(
                                    height: 130,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              Utils.setPngPath('logo'))),
                                    ),
                                  ),
                            AppSpacing.ksizedBoxW20,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(value.userDetailsModel!.data!.isEmpty
                                    ? ''
                                    : value.userDetailsModel!.data![0]
                                            .vendorName ??
                                        ''),
                                AppSpacing.ksizedBox5,
                                Text(value.userDetailsModel!.data!.isEmpty
                                    ? ''
                                    : value.userDetailsModel!.data![0]
                                            .vendorEmail ??
                                        ''),
                              ],
                            )
                          ],
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  logoutPOPUP(
    BuildContext context,
  ) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: SizedBox(
        height: 130.0,
        width: 200.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppSpacing.ksizedBox20,
            const Text(
              'Do you want to Logout ?',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                AppSpacing.ksizedBoxW20,
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'NO',
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
                    )),
                TextButton(
                  onPressed: () {
                    context.read<ProfileController>().appLogOut(context);
                  },
                  child: const Text(
                    'YES',
                    style: TextStyle(
                        color: AppColoring.successPopup, fontSize: 16.0),
                  ),
                ),
                AppSpacing.ksizedBoxW20,
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) => errorDialog,
    );
  }
}
