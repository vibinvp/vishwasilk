import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spreadsheet_ui/flutter_spreadsheet_ui.dart';
import 'package:namma_bike/controller/Settings/settind_controller.dart';
import 'package:namma_bike/controller/home/home_controller.dart';
import 'package:namma_bike/helper/api/base_constatnt.dart';
import 'package:namma_bike/helper/core/app_constant.dart';
import 'package:namma_bike/helper/core/app_spacing.dart';
import 'package:namma_bike/helper/core/color_constant.dart';
import 'package:namma_bike/helper/core/routes.dart';
import 'package:namma_bike/model/Product/product_model.dart';
import 'package:namma_bike/model/order/order_list_model.dart';
import 'package:namma_bike/model/order/orderd_venders_model.dart';
import 'package:namma_bike/utility/utils.dart';
import 'package:namma_bike/view/Account/account_screen.dart';
import 'package:namma_bike/widget/shimmer_effect.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  late HomeController homeController;
  late SettingController settingController;
  final ScrollController _scrollController = ScrollController();
  int countval = 0;

  @override
  void initState() {
    homeController = Provider.of<HomeController>(context, listen: false);
    settingController = Provider.of<SettingController>(context, listen: false);
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    homeController.fromDate =
        Utils.convertToReadableDate(firstDayOfMonth.toString());
    homeController.toDate =
        Utils.convertToReadableDate(lastDayOfMonth.toString());

    homeController.selectedProductId = '';
    settingController.getCurrentLocation();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      homeController.getproductList(context);
      if (countval == 0) {
        homeController.getOrders(context, '0');
      }
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        countval = countval + int.parse(AppConstant.perPage);
        homeController.getOrders(context, countval.toString());
      }
    });
    super.initState();
  }

  Future<void> reffresh() async {
    setState(() {
      countval = 0;
    });
    // homeController.fromDate = 'Select From Date';
    // homeController.toDate = 'Select To Date';
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    homeController.fromDate =
        Utils.convertToReadableDate(firstDayOfMonth.toString());
    homeController.toDate =
        Utils.convertToReadableDate(lastDayOfMonth.toString());
    homeController.getBanners(context);
    homeController.getproductList(context);
    homeController.getOrders(context, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColoring.kAppWhiteColor,
        title: Consumer(
          builder: (context, SettingController value, child) {
            return GestureDetector(
              onTap: () {
                value.getCurrentLocation();
              },
              child: Column(
                children: [
                  Text(
                    value.currentAddresss == ''
                        ? '📍Current Location........'
                        : '📍${value.currentAddresss}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          InkWell(
            onTap: () {
              RouteConstat.nextNamed(context, const AccountScreen());
            },
            child: Container(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              width: 40,
              height: 40,
              child: const CircleAvatar(
                  backgroundColor: AppColoring.primeryBorder,
                  radius: 20,
                  child:
                      Icon(Icons.person, color: AppColoring.black, size: 28)),
            ),
          ),
          AppSpacing.ksizedBoxW15
        ],
        // bottom: PreferredSize(
        //     preferredSize: const Size.fromHeight(70.0),
        //     child: dateWiseFilterWidget(context)),
      ),
      body: RefreshIndicator(
        onRefresh: reffresh,
        child: ListView(
          children: [
            slider1Widget(),
            AppSpacing.ksizedBox15,
            dateWiseFilterWidget(context),
            orderList(context),
          ],
        ),
      ),
    );
  }

  Widget productListWidget() {
    return Consumer(
      builder: (context, HomeController service, child) {
        return service.isLoadproductList
            ? ShimmerEffectListHorizontal()
            : service.productList.isNotEmpty || service.productModel == null
                ? SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        InkWell(
                          onTap: () {
                            service.setForm('');
                            service.getOrders(context, '0');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: service.selectedProductId == ''
                                    ? AppColoring.kAppColor
                                    : AppColoring.primeryBorder,
                                width: service.selectedProductId == '' ? 2 : .8,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0.0, vertical: 0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          Utils.setPngPath("logo"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  AppSpacing.ksizedBoxW5,
                                  const Text(
                                    'All',
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: service.productList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return gridViewItem1(service.productList[index]);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox();
      },
    );
  }

  Widget gridViewItem1(
    ProductList value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Consumer(
        builder: (context, HomeController home, child) {
          return InkWell(
            onTap: () {
              home.setForm(value.product ?? '');
              home.getOrders(context, '0');
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: home.selectedProductId == value.product
                          ? AppColoring.kAppColor
                          : AppColoring.primeryBorder,
                      width: home.selectedProductId == value.product ? 2 : .8),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: value.prodImg == null
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
                                      AppConstant.productImageUrl +
                                      value.prodImg.toString()),
                        ),
                      ),
                    ),
                    AppSpacing.ksizedBoxW5,
                    Text(
                      value.prodName ?? '',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget orderList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
      child: Consumer(
        builder: (context, HomeController order, child) {
          if (order.isLoadgetOrders || order.ordersModel == null) {
            return const ShimmerEffect();
          } else {
            return order.orderList.isEmpty
                ? const SizedBox(
                    height: 300,
                    child: Center(
                      child: Text('No Orders Found!'),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: FlutterSpreadsheetUI(
          config: const FlutterSpreadsheetUIConfig(
            enableColumnWidthDrag: true,
            enableRowHeightDrag: true,
            firstColumnWidth: 150,
            freezeFirstColumn: true,
            freezeFirstRow: true,
          ),
          // columnWidthResizeCallback: (int columnIndex, double updatedWidth) {
          //   log("Column: $columnIndex's updated width: $updatedWidth");
          // },
          // rowHeightResizeCallback: (int rowIndex, double updatedHeight) {
          //   log("Row: $rowIndex's updated height: $updatedHeight");
          // },
          columns: [
            FlutterSpreadsheetUIColumn(
              contentAlignment: Alignment.center,
              cellBuilder: (context, cellId) => const Text("Date"),
            ),
           
            // FlutterSpreadsheetUIColumn(
            //   width: 110,
            //   cellBuilder: (context, cellId) => const Text("Permissions"),
            // ),

            //List Products names
            ...List.generate(
              5,
              (index) => FlutterSpreadsheetUIColumn(
              contentAlignment: Alignment.center,
              cellBuilder: (context, cellId) => Text("Product $index")),
            // amount paid
            ),
              FlutterSpreadsheetUIColumn(
              contentAlignment: Alignment.center,
              cellBuilder: (context, cellId) => const Text("TotalAmount"),
            ),
           
          ],
          rows: List.generate(
            31,
            (rowIndex) => FlutterSpreadsheetUIRow(
              cells: [
                // list dates from API
                FlutterSpreadsheetUICell(
                  cellBuilder: (context, cellId) =>
                      Text('${rowIndex+1}/05/2023'),
                ),

           
                //  FlutterSpreadsheetUICell(
                //   cellBuilder: (context, cellId) =>
                //       Text('Task ${rowIndex + 1}'),
                // ),
                // FlutterSpreadsheetUICell(
                //   cellBuilder: (context, cellId) => Text(
                //     DateTime.now().toString(),
                //   ),
                // ),
                // FlutterSpreadsheetUICell(
                //   cellBuilder: (context, cellId) => const Text(
                //     'None',
                //   ),
                // ),

               // List Products price 
                ...List.generate(
                  5,
                  (colIndex) => 
                  FlutterSpreadsheetUICell(
                  cellBuilder: (context, cellId) {
                    return Container(
                      child: Text("$colIndex".toString()),
                    );
                  }
                  
                  //  Text(
                  //   DateTime.now().toString(),
                  // ),
                ),
                ),
                // total Amount
                 FlutterSpreadsheetUICell(
                  cellBuilder: (context, cellId) =>
                      Text('Task ${rowIndex + 1}'),
                ),

              ],
            ),
          ),
        ),
      ),

                    // child: Column(
                    //   children: [
                    //     ListView.separated(
                    //       shrinkWrap: true,
                    //       physics: const NeverScrollableScrollPhysics(),
                    //       itemCount: order.productQuantities.length,
                    //       itemBuilder: (context, index) {
                    //         final productId =
                    //             order.productQuantities.keys.elementAt(index);
                    //         final quantity =
                    //             order.productQuantities[productId];
                    //         final amount = order.productAmounts[productId];
                    //         final productName = order.productNames[productId];

                    //         return ListTile(
                    //           title: Text(
                    //             'Product Name: $productName',
                    //             style: const TextStyle(
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.bold),
                    //           ),
                    //           subtitle: Text(
                    //             'Total Qty: $quantity Kg',
                    //             style: const TextStyle(
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.bold),
                    //           ),
                    //           trailing: Column(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             crossAxisAlignment: CrossAxisAlignment.end,
                    //             children: [
                    //               const Text(
                    //                 'Total Amount',
                    //                 style: TextStyle(
                    //                     fontSize: 14,
                    //                     fontWeight: FontWeight.bold),
                    //               ),
                    //               Text(
                    //                 '₹$amount',
                    //                 style: const TextStyle(
                    //                     fontSize: 14,
                    //                     fontWeight: FontWeight.bold),
                    //               ),
                    //             ],
                    //           ),
                    //         );
                    //       },
                    //       separatorBuilder: (context, index) {
                    //         return const Divider();
                    //       },
                    //     ),
                    //     const Divider(),
                    //     Table(
                    //       border: TableBorder.all(color: Colors.black),
                    //       children: [
                    //         TableRow(children: [
                    //           const Padding(
                    //             padding: EdgeInsets.all(8.0),
                    //             child: Text(
                    //               'Total Net Amount(₹)',
                    //               style: TextStyle(fontSize: 16),
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Text(
                    //               '₹${order.totalAmount}',
                    //               style: const TextStyle(
                    //                   fontSize: 16,
                    //                   fontWeight: FontWeight.bold),
                    //             ),
                    //           ),
                    //         ]),
                    //         TableRow(children: [
                    //           const Padding(
                    //             padding: EdgeInsets.all(8.0),
                    //             child: Text(
                    //               'Amount Paid(₹)',
                    //               style: TextStyle(fontSize: 16),
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Text(
                    //               '₹${order.totalPaid}',
                    //               style: const TextStyle(
                    //                   fontSize: 16,
                    //                   fontWeight: FontWeight.w500),
                    //             ),
                    //           ),
                    //         ]),
                    //         TableRow(children: [
                    //           const Padding(
                    //             padding: EdgeInsets.all(8.0),
                    //             child: Text(
                    //               'Total Balance(₹)',
                    //               style: TextStyle(fontSize: 16),
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Text(
                    //               '₹${order.totalBalance}',
                    //               style: const TextStyle(
                    //                   fontSize: 16,
                    //                   fontWeight: FontWeight.w500),
                    //             ),
                    //           ),
                    //         ]),
                    //       ],
                    //     ),
                    //     AppSpacing.ksizedBox10,
                    //     const Divider(),
                    //     AppSpacing.ksizedBox10,
                    //     ListView(
                    //       shrinkWrap: true,
                    //       physics: const NeverScrollableScrollPhysics(),
                    //       children: order.groupedData.entries.map((entry) {
                    //         String orderDate = entry.key;
                    //         List<OrderList> orders = entry.value;

                    //         return Column(
                    //           crossAxisAlignment: CrossAxisAlignment.stretch,
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.symmetric(
                    //                   horizontal: 8.0),
                    //               child: Text(
                    //                 orderDate,
                    //                 style: const TextStyle(
                    //                     fontSize: 14,
                    //                     fontWeight: FontWeight.bold),
                    //               ),
                    //             ),
                    //             FittedBox(
                    //               child: DataTable(
                    //                 border: TableBorder.all(),
                    //                 columns: const [
                    //                   DataColumn(
                    //                       label: Text(
                    //                     'Product Name',
                    //                     style: TextStyle(
                    //                         fontSize: 14,
                    //                         fontWeight: FontWeight.bold),
                    //                   )),
                    //                   DataColumn(
                    //                       label: Text(
                    //                     'Weight(Kg)',
                    //                     style: TextStyle(
                    //                         fontSize: 14,
                    //                         fontWeight: FontWeight.bold),
                    //                   )),
                    //                   DataColumn(
                    //                       label: Text(
                    //                     'Amount Paid(₹)',
                    //                     style: TextStyle(
                    //                         fontSize: 14,
                    //                         fontWeight: FontWeight.bold),
                    //                   )),
                    //                 ],
                    //                 rows: orders.map<DataRow>((order) {
                    //                   return DataRow(cells: [
                    //                     DataCell(Text(
                    //                       order.prodName ?? '',
                    //                       style: const TextStyle(
                    //                           fontSize: 14,
                    //                           fontWeight: FontWeight.bold),
                    //                     )), // Replace with actual field names
                    //                     DataCell(Text(
                    //                       order.weight ?? '',
                    //                       style: const TextStyle(
                    //                           fontSize: 14,
                    //                           fontWeight: FontWeight.bold),
                    //                     )),
                    //                     DataCell(Text(
                    //                       order.paidAmount ?? '',
                    //                       style: const TextStyle(
                    //                           fontSize: 14,
                    //                           fontWeight: FontWeight.bold),
                    //                     )), // Replace with actual field names
                    //                   ]);
                    //                 }).toList(),
                    //               ),
                    //             ),
                    //             const SizedBox(height: 10),
                    //           ],
                    //         );
                    //       }).toList(),

                    //       //  ListView.separated(
                    //       //     separatorBuilder: (context, index) => const SizedBox(
                    //       //       height: 5,
                    //       //     ),
                    //       //     physics: const NeverScrollableScrollPhysics(),
                    //       //     shrinkWrap: true,
                    //       //     itemCount: order.orderList.length,
                    //       //     itemBuilder: (context, index) {
                    //       //       final data = order.orderList[index];
                    //       //       return DataTable(columns: [
                    //       //         DataColumn(label: Text('Product Name')),
                    //       //         DataColumn(label: Text('Weight')),
                    //       //         DataColumn(label: Text('Order Date')),
                    //       //       ], rows: [
                    //       //         DataRow(cells: [
                    //       //           DataCell(Text(data.prodName ?? '')),
                    //       //           DataCell(Text(data.weight ?? '')),
                    //       //           DataCell(Text(data.orderDate ?? '')),
                    //       //         ]),
                    //       //       ]);
                    //       //  Column(
                    //       //   children: [

                    //       //   ],
                    //       // );

                    //       //     Card(
                    //       //   elevation: 2,
                    //       //   color: AppColoring.kAppWhiteColor,
                    //       //   shape: RoundedRectangleBorder(
                    //       //       borderRadius: BorderRadius.circular(5)),
                    //       //   child: InkWell(
                    //       //     onTap: () {
                    //       //       RouteConstat.nextNamed(
                    //       //           context, ScreenOrderDetails(orderData: data));
                    //       //     },
                    //       //     child: Padding(
                    //       //       padding: const EdgeInsets.all(10.0),
                    //       //       child: Column(
                    //       //         crossAxisAlignment: CrossAxisAlignment.start,
                    //       //         children: [
                    //       //           Row(
                    //       //             mainAxisAlignment:
                    //       //                 MainAxisAlignment.spaceBetween,
                    //       //             children: [
                    //       //               Text(
                    //       //                 'Order ID:${data.orderId}',
                    //       //                 style: const TextStyle(
                    //       //                     fontSize: 14,
                    //       //                     fontWeight: FontWeight.w600),
                    //       //               ),
                    //       //               Text(
                    //       //                 '🕐 ${data.orderDate.toString()}',
                    //       //                 style: const TextStyle(
                    //       //                     fontSize: 11,
                    //       //                     fontWeight: FontWeight.w600),
                    //       //               )
                    //       //             ],
                    //       //           ),
                    //       //           AppSpacing.ksizedBox5,
                    //       //           Row(
                    //       //             mainAxisAlignment:
                    //       //                 MainAxisAlignment.spaceBetween,
                    //       //             children: [
                    //       //               Expanded(
                    //       //                 child: Text(
                    //       //                   'Product Name: ${data.prodName}',
                    //       //                   style: const TextStyle(
                    //       //                       fontSize: 12,
                    //       //                       fontWeight: FontWeight.w600),
                    //       //                 ),
                    //       //               ),
                    //       //               AppSpacing.ksizedBoxW5,
                    //       //               Text(
                    //       //                 'Total: ₹${data.totalPrice}',
                    //       //                 style: const TextStyle(
                    //       //                     fontSize: 12,
                    //       //                     color: AppColoring.black,
                    //       //                     fontWeight: FontWeight.w500),
                    //       //               ),
                    //       //             ],
                    //       //           ),
                    //       //           AppSpacing.ksizedBox3,
                    //       //           Row(
                    //       //             mainAxisAlignment:
                    //       //                 MainAxisAlignment.spaceBetween,
                    //       //             children: [
                    //       //               Text(
                    //       //                 'Name: ${data.userName}',
                    //       //                 style: const TextStyle(
                    //       //                     fontSize: 12,
                    //       //                     fontWeight: FontWeight.w600),
                    //       //               ),
                    //       //               Text(
                    //       //                 'Weight :${data.weight.toString()}Kg',
                    //       //                 style: const TextStyle(
                    //       //                     fontSize: 12,
                    //       //                     fontWeight: FontWeight.w600),
                    //       //               )
                    //       //             ],
                    //       //           ),
                    //       //           AppSpacing.ksizedBox10,
                    //       //         ],
                    //       //       ),
                    //       //     ),
                    //       //   ),
                    //       // );
                    //       //   },
                    //     ),
                    //   ],
                    // ),
                  );
          }
        },
      ),
    );
  }

  Widget dateWiseFilterWidget(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Consumer(
        builder: (context, HomeController controller, child) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColoring.primeryBorder, width: .8),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          controller.fromDate,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.ksizedBoxW20,
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColoring.primeryBorder, width: .8),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          controller.toDate,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.ksizedBoxW20,
                  controller.fromDate != 'Select From Date'
                      ? InkWell(
                          onTap: () async {
                            controller.setToDateDefault();
                            controller.getOrders(context, '0');
                          },
                          child: const Icon(Icons.close),
                        )
                      : InkWell(
                          onTap: () async {
                            await showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime.now()
                                        .subtract(const Duration(days: 10000)),
                                    lastDate: DateTime.now())
                                .then((value) {
                              if (value != null) {
                                controller.setFromDate(
                                    Utils.convertToReadableDate(
                                        value.start.toString().toString()));
                                controller.setToDate(
                                    Utils.convertToReadableDate(
                                        value.end.toString().toString()));

                                controller.getOrders(context, '0');
                              }
                            });
                          },
                          child: const Icon(Icons.date_range),
                        )
                ],
              ),
              AppSpacing.ksizedBox10,
              //  productListWidget()
              // textFormFieldVenderWidget()
            ],
          );
        },
      ),
    );
  }

  Widget textFormFieldVenderWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Consumer(
        builder: (context, HomeController order, child) {
          return order.isLoadgetVendor
              ? const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  ),
                )
              : order.orderdVendorList.isNotEmpty
                  ? const SizedBox()
                  : SizedBox(
                      height: 40,
                      child: Center(
                        child: DropdownButtonFormField(
                            items: order.orderdVendorList
                                .map((OrderdVendorList category) {
                              return DropdownMenuItem(
                                  value: category.vendorId,
                                  child: Row(
                                    children: <Widget>[
                                      Text(category.vendorName ?? ''),
                                    ],
                                  ));
                            }).toList(),
                            onChanged: (newValue) {
                              order.selectVendor(newValue.toString());
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                fillColor: Colors.transparent,
                                filled: true,
                                hintText: 'Select Vondor',
                                hintStyle: const TextStyle(fontSize: 12))),
                      ),
                    );
        },
      ),
    );
  }

  slider1Widget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Consumer(
        builder: (context, HomeController value, child) {
          return value.isLoadBannner
              ? const SingleBallnerItemSimmer()
              : value.banner.isEmpty
                  ? const Row()
                  : Column(
                      children: [
                        CarouselSlider.builder(
                          itemCount: value.banner.length,
                          options: CarouselOptions(
                            onPageChanged: (index, reason) {
                              value.changeSliderIndex(index);
                            },
                            height: 180,
                            viewportFraction: 1,
                            padEnds: false,
                            autoPlay: true,
                            initialPage: 0,
                            enlargeCenterPage: true,
                          ),
                          itemBuilder: (ctx, index, realIdx) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: value.banner.isEmpty
                                      ? Image.asset(
                                          Utils.setPngPath("logo"),
                                          fit: BoxFit.fill,
                                        )
                                      : CachedNetworkImage(
                                          errorWidget: (context, url, error) {
                                            return Image.asset(
                                              Utils.setPngPath("logo"),
                                              fit: BoxFit.fill,
                                            );
                                          },
                                          progressIndicatorBuilder:
                                              (context, url, downloadProgress) {
                                            return const SingleBallnerItemSimmer();
                                          },
                                          fit: BoxFit.fill,
                                          imageUrl: value.banner[index].image
                                              .toString()),
                                ),
                              ),
                            );
                          },
                        ),
                        AppSpacing.ksizedBox10,
                        AnimatedSmoothIndicator(
                          activeIndex: value.selectedSliderIndex,
                          count: value.banner.length,
                          effect: const ExpandingDotsEffect(
                            dotWidth: 10,
                            dotHeight: 10,
                            activeDotColor: AppColoring.kAppColor,
                            dotColor: AppColoring.textDim,
                          ),
                        ),
                      ],
                    );
        },
      ),
    );
  }
}



// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_spreadsheet_ui/flutter_spreadsheet_ui.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(6.0),
//         child: FlutterSpreadsheetUI(
//           config: const FlutterSpreadsheetUIConfig(
//             enableColumnWidthDrag: true,
//             enableRowHeightDrag: true,
//             firstColumnWidth: 150,
//             freezeFirstColumn: true,
//             freezeFirstRow: true,
//           ),
//           columnWidthResizeCallback: (int columnIndex, double updatedWidth) {
//             log("Column: $columnIndex's updated width: $updatedWidth");
//           },
//           rowHeightResizeCallback: (int rowIndex, double updatedHeight) {
//             log("Row: $rowIndex's updated height: $updatedHeight");
//           },
//           columns: [
//             // FlutterSpreadsheetUIColumn(
//             //   contentAlignment: Alignment.center,
//             //   cellBuilder: (context, cellId) => const Text("Task"),
//             // ),
//             // FlutterSpreadsheetUIColumn(
//             //   width: 200,
//             //   contentAlignment: Alignment.center,
//             //   cellBuilder: (context, cellId) => const Text("Assigned Date"),
//             // ),
//             // FlutterSpreadsheetUIColumn(
//             //   width: 110,
//             //   cellBuilder: (context, cellId) => const Text("Permissions"),
//             // ),
//             ...List.generate(
//               10,
//               (index) => FlutterSpreadsheetUIColumn(
//                 width: 110,
//                 cellBuilder: (context, cellId) => Text(cellId),
//               ),
//             ),
//           ],
//           rows: List.generate(
//             20,
//             (rowIndex) => FlutterSpreadsheetUIRow(
//               cells: [
//                 // FlutterSpreadsheetUICell(
//                 //   cellBuilder: (context, cellId) =>
//                 //       Text('Task ${rowIndex + 1}'),
//                 // ),
//                 // FlutterSpreadsheetUICell(
//                 //   cellBuilder: (context, cellId) => Text(
//                 //     DateTime.now().toString(),
//                 //   ),
//                 // ),
//                 // FlutterSpreadsheetUICell(
//                 //   cellBuilder: (context, cellId) => const Text(
//                 //     'None',
//                 //   ),
//                 // ),
//                 ...List.generate(
//                   10,
//                   (colIndex) => FlutterSpreadsheetUICell(
//                     cellBuilder: (context, cellId) => Text(
//                       cellId,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List<List<String>> _data = [
//     ['Date', 'Product Name', 'Amount'],
//     ['2023-01-01', 'Product A', '100.00'],
//     ['2023-01-02', 'Product B', '150.00'],
//     ['2023-01-03', 'Product C', '200.00'],
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Excel Sheet Example'),
//       ),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Column(
//           children: [
//             DataTable(
//               columns: _data[0].map((String column) {
//                 return DataColumn(
//                   label: Text(column),
//                 );
//               }).toList(),
//               rows: _data.sublist(1).map((List<String> row) {
//                 return DataRow(
//                   cells: row.map((String cell) {
//                     return DataCell(
//                       Text(cell),
//                     );
//                   }).toList(),
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 20.0), // Adjust the spacing as needed
//             Text(
//               'ListView Below Header',
//               style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: 10, // Replace with the actual item count
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text('Item $index'),
//                     // Add more content or customize as needed
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
