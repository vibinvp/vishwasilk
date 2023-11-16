import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:namma_bike/controller/profile/docoment_upload_controller.dart';
import 'package:namma_bike/helper/api/base_constatnt.dart';
import 'package:namma_bike/helper/core/app_constant.dart';
import 'package:namma_bike/helper/core/app_spacing.dart';
import 'package:namma_bike/helper/core/color_constant.dart';
import 'package:namma_bike/helper/core/message.dart';
import 'package:namma_bike/utility/utils.dart';
import 'package:namma_bike/widget/app_loader_widget.dart';
import 'package:namma_bike/widget/shimmer_effect.dart';
import 'package:namma_bike/widget/textfeild_widget.dart';
import 'package:provider/provider.dart';

class ScreenUploadDocuments extends StatefulWidget {
  const ScreenUploadDocuments({super.key});

  @override
  State<ScreenUploadDocuments> createState() => _ScreenUploadDocumentsState();
}

class _ScreenUploadDocumentsState extends State<ScreenUploadDocuments> {
  late DocumentuploadController documentuploadController;

  bool camera = false;
  @override
  void initState() {
    documentuploadController =
        Provider.of<DocumentuploadController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      documentuploadController.getUserDetails(context);
    });
    documentuploadController.adharimage = null;
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
          "Documents",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            uploadImageWidget(),
            AppSpacing.ksizedBox80,
          ],
        ),
      ),
    );
  }

  Widget headingTextRow(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColoring.textDark),
        ),
      ],
    );
  }

  Widget uploadImageWidget() {
    return Consumer(
      builder:
          (context, DocumentuploadController documentuploadController, child) {
        return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                documentuploadController.isLoadFetchUser
                    ? const SingleBallnerItemSimmer()
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              headingTextRow('Adhar Card'),
                              IconButton(
                                icon: const Icon(Icons.file_download),
                                onPressed: () {
                                  uploadPopUp('adhar');
                                },
                              ),
                            ],
                          ),
                          documentuploadController.adharimage == null
                              ? documentuploadController
                                          .adharGetImage.isNotEmpty ||
                                      documentuploadController.adharGetImage !=
                                          ''
                                  ? Container(
                                      height: 200,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: documentuploadController
                                                .adharGetImage.isEmpty
                                            ? Image.asset(
                                                Utils.setPngPath("logo"),
                                                fit: BoxFit.fill,
                                              )
                                            : CachedNetworkImage(
                                                errorWidget:
                                                    (context, url, error) {
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
                                                    documentuploadController
                                                        .adharGetImage
                                                        .toString()),
                                      ),
                                    )
                                  : Container(
                                      width: MediaQuery.of(context).size.width,
                                      color: AppColoring.dimLight,
                                      height: 200,
                                      child: InkWell(
                                        onTap: () {
                                          uploadPopUp('adhar');
                                        },
                                        child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons
                                                  .image_not_supported_outlined,
                                              size: 50,
                                            ),
                                            Text(
                                              "Not uploaded click here! ",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(
                                              documentuploadController
                                                  .adharimage!),
                                          fit: BoxFit.fill)),
                                ),
                        ],
                      ),
                const Divider(
                  thickness: 2,
                ),
              ],
            ));
      },
    );
  }

  uploadPopUp(type) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 100,
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    await documentuploadController.getImage(
                        ImageSource.gallery, type);
                    // ignore: use_build_context_synchronously
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
                    documentuploadController.getImage(ImageSource.camera, type);

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

  Widget _getActionButtons() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0, bottom: 20),
      child: Consumer(
        builder: (context, DocumentuploadController value, child) {
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
                      value.updateUser(context);
                    },
                  ));
        },
      ),
    );
  }
}
