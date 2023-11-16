import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:namma_bike/controller/home/home_controller.dart';
import 'package:namma_bike/helper/api/base_constatnt.dart';
import 'package:namma_bike/helper/core/app_constant.dart';
import 'package:namma_bike/helper/core/app_spacing.dart';
import 'package:namma_bike/helper/core/color_constant.dart';
import 'package:namma_bike/model/order/order_list_model.dart';
import 'package:namma_bike/utility/utils.dart';
import 'package:namma_bike/widget/app_loader_widget.dart';
import 'package:namma_bike/widget/row_two_item.dart';
import 'package:namma_bike/widget/shimmer_effect.dart';
import 'package:provider/provider.dart';

class ScreenOrderDetails extends StatefulWidget {
  const ScreenOrderDetails({super.key, required this.orderData});
  final OrderList orderData;

  @override
  State<ScreenOrderDetails> createState() => _ScreenOrderDetailsState();
}

late HomeController homeController;

class _ScreenOrderDetailsState extends State<ScreenOrderDetails> {
  @override
  void initState() {
    homeController = Provider.of<HomeController>(context, listen: false);
    homeController.isDownloadInvoice = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColoring.lightBg,
              blurRadius: 5,
            )
          ],
        ),
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              RowTwoItemWidget(
                text1: 'Total Amount:',
                text2: '₹${widget.orderData.totalPrice}',
                fontWeight1: FontWeight.bold,
                fontWeight2: FontWeight.bold,
                fontSize1: 16,
                fontSize2: 18,
                color2: AppColoring.successPopup,
              ),
              const Divider(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 55,
                child: Consumer(
                  builder: (context, HomeController value, child) {
                    return value.isDownloadInvoice
                        ? const LoadreWidget()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColoring.kAppColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {
                              value.generateAndDownloadPDF(
                                  widget.orderData.orderId ?? '', context);
                            },
                            child: const Text(
                              'Print Invoice',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                  },
                ),
              )
            ])),
      ),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColoring.kAppColor,
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Consumer(
          builder: (context, HomeController value, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RowTwoItemWidget(
                    text1: 'Order Id:${widget.orderData.orderId}',
                    text2: '🕐 ${widget.orderData.orderDate}',
                    fontSize1: 16,
                    fontSize2: 14,
                  ),
                  const Divider(thickness: .8),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                    child: Text(
                      'Pick Up Boy Details',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    color: AppColoring.lightBg,
                    height: 80,
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.orderData.userName ?? '',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "Mob.${widget.orderData.mobile}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            // subtitle: Text(
                            //   orderData.vendorAddress ?? '',
                            //   maxLines: 2,
                            //   overflow: TextOverflow.ellipsis,
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                    child: Text(
                      'Ordered Product',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: SizedBox(
                            height: 100,
                            width: 80,
                            child: widget.orderData.prodImg == null
                                ? Image.asset(
                                    Utils.setPngPath("logo"),
                                    fit: BoxFit.fill,
                                  )
                                : CachedNetworkImage(
                                    errorWidget: (context, url, error) {
                                      return const Icon(Icons.error);
                                    },
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) {
                                      return const SingleBallnerItemSimmer();
                                    },
                                    fit: BoxFit.fill,
                                    imageUrl: ApiBaseConstant.baseMainUrl +
                                        AppConstant.servicesImageUrl +
                                        widget.orderData.prodImg.toString()),
                          ),
                          title: Text(
                            widget.orderData.prodName ?? '',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                            '${widget.orderData.weight}Kg',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.orderData.prodDescription ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColoring.textDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.ksizedBox10,
                  const Divider(),
                  Text(
                    'Note:\n${widget.orderData.note}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColoring.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.ksizedBox80,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StepChip extends StatelessWidget {
  final String label;
  final bool isActive;

  const _StepChip({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListTile(
        title: FittedBox(
          child: Text(
            label,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10),
          ),
        ),
        leading: isActive
            ? const CircleAvatar(
                backgroundColor: AppColoring.successPopup,
                radius: 12,
                child: Center(
                  child: Icon(
                    Icons.check,
                    color: AppColoring.kAppWhiteColor,
                    size: 20,
                  ),
                ),
              )
            : const CircleAvatar(
                backgroundColor: AppColoring.errorPopUp,
                radius: 12,
                child: Center(
                  child: Icon(
                    Icons.close,
                    color: AppColoring.kAppWhiteColor,
                    size: 20,
                  ),
                ),
              ),
      ),
    );
  }
}
