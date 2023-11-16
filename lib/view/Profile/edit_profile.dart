import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:namma_bike/controller/profile/profile_controller.dart';
import 'package:namma_bike/helper/api/base_constatnt.dart';
import 'package:namma_bike/helper/core/app_constant.dart';
import 'package:namma_bike/helper/core/app_spacing.dart';
import 'package:namma_bike/helper/core/color_constant.dart';
import 'package:namma_bike/helper/core/message.dart';
import 'package:namma_bike/helper/core/routes.dart';
import 'package:namma_bike/utility/utils.dart';
import 'package:namma_bike/view/map/screen_map.dart';
import 'package:namma_bike/widget/app_loader_widget.dart';
import 'package:namma_bike/widget/shimmer_effect.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late ProfileController profileController;
  bool camera = false;
  @override
  void initState() {
    profileController = Provider.of<ProfileController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      profileController.getUserDetails(context);
      profileController.isLoadUpdateUser;
      profileController.enable = false;
      profileController.image = null;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _getActionButtons(),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColoring.kAppColor,
        title: const Text(
          "Profile Details",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                      child: Stack(fit: StackFit.loose, children: <Widget>[
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return SimpleDialog(
                                  insetPadding: const EdgeInsets.symmetric(
                                    horizontal: 100,
                                  ),
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            await profileController
                                                .getImage(ImageSource.gallery);

                                            Navigator.of(context).pop();
                                          },
                                          child: const Column(
                                            children: [
                                              Icon(
                                                Icons.image,
                                                size: 40,
                                              ),
                                              Text('Gallery'),
                                            ],
                                          ),
                                        ),
                                        AppSpacing.ksizedBoxW30,
                                        InkWell(
                                          onTap: () async {
                                            profileController
                                                .getImage(ImageSource.camera);

                                            Navigator.of(context).pop();
                                          },
                                          child: const Column(
                                            children: [
                                              Icon(
                                                Icons.camera_alt,
                                                size: 40,
                                              ),
                                              Text('Camera'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 140,
                            width: double.infinity,
                            color: AppColoring.kAppBlueColor,
                            child: Center(
                              child: Consumer(
                                builder:
                                    (context, ProfileController value, child) {
                                  // profileController.imageTobase64();
                                  return value.image == null
                                      ? value.profilePic.isNotEmpty
                                          ? Stack(
                                              children: [
                                                Container(
                                                  width: 110,
                                                  height: 110,
                                                  decoration: BoxDecoration(
                                                    color: AppColoring
                                                        .kAppWhiteColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80),
                                                    child: CachedNetworkImage(
                                                        errorWidget: (context,
                                                            url, error) {
                                                          return const Icon(
                                                              Icons.error);
                                                        },
                                                        progressIndicatorBuilder:
                                                            (context, url,
                                                                downloadProgress) {
                                                          return const SingleBallnerItemSimmer();
                                                        },
                                                        fit: BoxFit.fill,
                                                        imageUrl: ApiBaseConstant
                                                                .baseMainUrl +
                                                            AppConstant
                                                                .profileImageUrl +
                                                            value.profilePic),
                                                  ),
                                                ),
                                                const Positioned(
                                                  bottom: 15,
                                                  left: 80,
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.black,
                                                    size: 32,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(
                                              height: 130,
                                              width: 140,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        Utils.setPngPath(
                                                            'logo'))),
                                              ),
                                              child: const Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 32,
                                                ),
                                              ),
                                            )
                                      : CircleAvatar(
                                          radius: 60,
                                          backgroundColor: Colors.black,
                                          backgroundImage:
                                              FileImage(value.image!),
                                          child: const Align(
                                            alignment: Alignment.bottomRight,
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.black,
                                              size: 32,
                                            ),
                                          ),
                                        );
                                },
                              ),
                            ),
                          ),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
//                          profile(context),
                      const Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextFormField(
                                  controller: profileController.nameController,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return " Please enter garage name";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(left: 10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: "Enter Your Name",
                                  ),
                                ),
                              ),
                            ],
                          )),
                      const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Email',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextFormField(
                                  controller: profileController.emailController,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return " Please enter the email id";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.only(left: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      hintText: "Enter Email ID"),
                                ),
                              ),
                            ],
                          )),
                      const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Mobile',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextFormField(
                                  readOnly: true,
                                  controller:
                                      profileController.mobileController,
                                  keyboardType: TextInputType.number,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return " Please enter the mobile No";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.only(left: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      hintText: "Enter Mobile Number"),
                                  enabled: false,
                                ),
                              ),
                            ],
                          )),
                      const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'City',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: TextFormField(
                                controller: profileController.cityController,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return " Please enter the city";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(left: 10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: "Enter City"),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Container(
                                  child: const Text(
                                    'Pincode',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  child: const Text(
                                    'State',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: TextFormField(
                                    controller:
                                        profileController.pincodeController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(6)
                                    ],
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return " Please enter the pincode";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.only(left: 10),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        hintText: "Enter Pin Code"),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: TextFormField(
                                  controller: profileController.stateController,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return " Please enter the state";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.only(left: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      hintText: "Enter State"),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text(
                                'Garage Address',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                  onPressed: () {
                                    RouteConstat.nextNamed(
                                      context,
                                      MapScreen(
                                        latitudeController: profileController
                                            .latitudeController,
                                        longitudeController: profileController
                                            .longitudeController,
                                        addressController:
                                            profileController.addressController,
                                        cityController:
                                            profileController.cityController,
                                        pinCodeController:
                                            profileController.pincodeController,
                                        stateController:
                                            profileController.stateController,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.my_location)),
                            ],
                          )),

                      Consumer(builder: (context,
                          ProfileController profileController, child) {
                        return InkWell(
                          onTap: () {
                            if (profileController.addressController.text !=
                                    '' ||
                                profileController
                                    .addressController.text.isNotEmpty) {
                              profileController.enableMap();
                            } else {
                              // RouteConstat.nextNamed(
                              //   context,
                              //   MapScreen(
                              //     latitudeController:
                              //         profileController.latitudeController,
                              //     longitudeController:
                              //         profileController.longitudeController,
                              //     addressController:
                              //         profileController.addressController,
                              //     cityController:
                              //         profileController.cityController,
                              //     pinCodeController:
                              //         profileController.pincodeController,
                              //     stateController:
                              //         profileController.stateController,
                              //   ),
                              // );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              enabled: profileController.enable,
                              maxLines: 5,
                              keyboardType: TextInputType.text,
                              controller: profileController.addressController,
                              validator: (String? value) {
                                if (value == null ||
                                    value.isEmpty && value.length > 10) {
                                  return " Please enter the  address";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(left: 10, top: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: 'Address',
                                labelText: 'Enter the address',
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black54, width: 3.0),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),

                      AppSpacing.ksizedBox50,
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0, bottom: 20),
      child: Consumer(
        builder: (context, ProfileController value, child) {
          return value.isLoadUpdateUser
              ? const LoadreWidget()
              : SizedBox(
                  height: 40,
                  width: 250,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      if (value.mobileController.text.length != 10) {
                        showToast(
                            msg: 'Enter 10 digit number',
                            clr: AppColoring.errorPopUp);
                      } else if (value.nameController.text == '' ||
                          value.nameController.text.isEmpty ||
                          value.emailController.text == '' ||
                          value.emailController.text.isEmpty ||
                          value.cityController.text == '' ||
                          value.cityController.text.isEmpty ||
                          value.stateController.text == '' ||
                          value.stateController.text.isEmpty ||
                          value.pincodeController.text == '' ||
                          value.pincodeController.text.isEmpty ||
                          value.addressController.text == '' ||
                          value.addressController.text.isEmpty) {
                        showToast(
                            msg: 'Fill all the fields correctly',
                            clr: AppColoring.errorPopUp);
                      } else {
                        value.updateUser(context);
                      }
                    },
                  ));
        },
      ),
    );
  }

  Widget submitImage() {
    return InkWell(onTap: () {}, child: const Text("Submit"));
  }
}
