import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Modules/Home/main/services/details/reguest_servies.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/custom_appbar.dart';
import 'package:tinti_app/Widgets/custom_text.dart';
import 'package:tinti_app/provider/order_provider.dart';
import 'package:tinti_app/provider/products_provider.dart';
import '../../../../../Helpers/failure.dart';
import '../../../../../Util/constants/constants.dart';
import '../../../../../Widgets/available_size.dart';
import '../../../../../Widgets/custom_text_field.dart';
import '../../../../../Widgets/gradint_button.dart';
import '../../../../../Widgets/loader_widget.dart';
import '../../../../../Widgets/page_view_indicator_Home.dart';
import '../../../../../Widgets/servies_images.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../../../Widgets/text_widget.dart';
import '../../../../../provider/favorites_provider.dart';
import '../service_page.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  dynamic row_id;
  int id;
  int isFavorite;
  OrderDetailsScreen(
      {super.key,
      required this.id,
      required this.row_id,
      required this.isFavorite});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  int pageIndex = 0;
  TextEditingController _comment = TextEditingController();
  // bool isFav = false;
  late PageController _pageController;
  int _currentPage = 0;
  late final _ratingController;
  bool? isShoow;
  double rate = 0.0;
  double? _rating;
  IconData? _selectedIcon;

  Future _getProducDetailsData() async {
    final prov = ref.read(ordersProvider);

    return await prov.getSingleOrderDataRequset(id: widget.id);
  }

  late Future _fetchedProducDetailsRequest;

  @override
  void initState() {
    _fetchedProducDetailsRequest = _getProducDetailsData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'order_details'.tr(),
        isHome: true,
      ),
      body: Consumer(
        builder: (context, ref, child) => FutureBuilder(
          future: _fetchedProducDetailsRequest,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: 70.h,
                child: const Center(
                  child: LoaderWidget(),
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data is Failure) {
                return Center(child: TextWidget(snapshot.data.toString()));
              }
              //
              //  print("snapshot data is ${snapshot.data}");

              var productDetailsModel =
                  ref.watch(ordersProvider).getSingleOrder;
              var addToFavModel = ref.watch(favsProvider);
              // var removeFavModel = ref.watch(favsProvider);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      width: 370.w,
                      height: 200.h,
                      child: SizedBox(
                        child: CarouselSlider.builder(
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) =>
                              ServiesImages(
                            image: productDetailsModel?.order?.image ??
                                'http://sayyarte.com/img/1676279090.jpg',
                          ),
                          options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 01,
                            aspectRatio: 2.0,
                            initialPage: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  productDetailsModel?.order?.name ??
                                      'نانو سيراميك',
                                  color: AppColors.scadryColor,
                                  fontSize: 18.sp,
                                  fontFamily: 'DINNextLTArabic',
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                CustomText(
                                  productDetailsModel?.order?.service ??
                                      'جونسون اند جونسون ',
                                  color: AppColors.orange,
                                  fontSize: 14.sp,
                                  fontFamily: 'DINNextLTArabic',
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),

                            // GestureDetector(
                            //   onTap: () {
                            //     setState(() {
                            //       widget.isFavorite == 0
                            //           ? widget.isFavorite = 1
                            //           : widget.isFavorite = 0;
                            //       var favModel = ref.watch(favsProvider);

                            //       if (widget.isFavorite != 0) {
                            //         favModel.addFavRequset(id: widget.id);
                            //       } else {
                            //         favModel.removeFavRequset(id: widget.id);
                            //       }
                            //     });
                            //   },
                            //   child: Container(
                            //     width: 25.w,
                            //     height: 24.h,
                            //     decoration: BoxDecoration(
                            //       color: Colors.grey[300],
                            //       borderRadius: BorderRadius.circular(3.w),
                            //       // border: Border.all(color: Colors.grey),
                            //     ),
                            //     child: Icon(
                            //       widget.isFavorite == 0
                            //           ? Icons.favorite_border
                            //           : Icons.favorite,
                            //       color: widget.isFavorite == 0
                            //           ? AppColors.grey
                            //           : AppColors.orange,
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        orderCard(
                            'حالة الدفع',
                            productDetailsModel?.order?.paymentFlag ?? 'null',
                            false),
                        SizedBox(
                          height: 10.h,
                        ),
                        orderCard(
                            'الشركة',
                            productDetailsModel?.order?.company ?? 'null',
                            false),
                        SizedBox(
                          height: 10.h,
                        ),
                        orderCard('السيارة',
                            productDetailsModel?.order?.car ?? 'null', false),
                        SizedBox(
                          height: 10.h,
                        ),
                        orderCard(
                            'الموقع',
                            productDetailsModel?.order?.region ?? 'null',
                            false),
                        SizedBox(
                          height: 10.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isShoow == true
                                  ? isShoow = false
                                  : isShoow = true;
                            });
                          },
                          child: orderCard('التعليقات', "", true),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        // Row(
                        //   // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     TextButton(
                        //       onPressed: () {
                        //         setState(() {
                        //           pageIndex = 0;
                        //         });
                        //       },
                        //       child: pageIndex == 0
                        //           ? Container(
                        //               padding: EdgeInsets.all(5.w),
                        //               decoration: BoxDecoration(
                        //                 color: const Color(0xffF57A38),
                        //                 borderRadius:
                        //                     BorderRadius.circular(10.w),
                        //                 // border: Border.all(color: Colors.grey),
                        //               ),
                        //               child: Container(
                        //                 width: 160.w,
                        //                 child: Center(
                        //                   child: Text(
                        //                     "about service".tr(),
                        //                     textAlign: TextAlign.center,
                        //                     style: const TextStyle(
                        //                         color: Colors.white,
                        //                         fontFamily: 'DINNEXTLTARABIC',
                        //                         fontWeight: FontWeight.normal),
                        //                   ),
                        //                 ),
                        //               ),
                        //             )
                        //           : Container(
                        //               width: 160.w,
                        //               padding: EdgeInsets.all(5.w),
                        //               decoration: BoxDecoration(
                        //                 // color: Colors.orange[300],
                        //                 borderRadius:
                        //                     BorderRadius.circular(10.w),
                        //                 border: Border.all(
                        //                   color: Color(0xffF57A38),
                        //                 ),
                        //               ),
                        //               child: Center(
                        //                 child: Text(
                        //                   textAlign: TextAlign.center,
                        //                   "about service".tr(),
                        //                   style: const TextStyle(
                        //                       color: Colors.black,
                        //                       fontFamily: 'DINNEXTLTARABIC',
                        //                       fontWeight: FontWeight.normal),
                        //                 ),
                        //               ),
                        //             ),
                        //     ),
                        //     TextButton(
                        //       onPressed: () {
                        //         setState(() {
                        //           pageIndex = 1;
                        //         });
                        //       },
                        //       child: pageIndex == 1
                        //           ? Container(
                        //               width: 160.w,
                        //               padding: EdgeInsets.all(5.w),
                        //               decoration: BoxDecoration(
                        //                 color: Color(0xffF57A38),
                        //                 borderRadius:
                        //                     BorderRadius.circular(10.w),
                        //                 // border: Border.all(color: Colors.grey),
                        //               ),
                        //               child: Center(
                        //                 child: Text(
                        //                   "Ratting".tr(),
                        //                   style: const TextStyle(
                        //                       color: Colors.white,
                        //                       fontFamily: 'DINNEXTLTARABIC',
                        //                       fontWeight: FontWeight.normal),
                        //                 ),
                        //               ),
                        //             )
                        //           : Container(
                        //               width: 160.w,
                        //               padding: EdgeInsets.all(5.w),
                        //               decoration: BoxDecoration(
                        //                 // color: Colors.orange[300],
                        //                 borderRadius:
                        //                     BorderRadius.circular(10.w),
                        //                 border: Border.all(
                        //                   color: Color(0xffF57A38),
                        //                 ),
                        //               ),
                        //               child: Center(
                        //                 child: Text(
                        //                   "Ratting".tr(),
                        //                   style: const TextStyle(
                        //                       color: Colors.orange,
                        //                       fontFamily: 'DINNEXTLTARABIC',
                        //                       fontWeight: FontWeight.normal),
                        //                 ),
                        //               ),
                        //             ),
                        //     ),
                        //   ],
                        // ),
                        // pageIndex == 0
                        //     ? Padding(
                        //         padding: EdgeInsets.all(5.w),
                        //         child: CustomText(
                        //             fontFamily: 'DINNEXTLTARABIC',
                        //             color: AppColors.scadryColor,
                        //             productDetailsModel?.product?.description ??
                        //                 'تلعب العناية المنتظمة بالسيارة دورا كبيرا في المحافظة على السيارات وهذا هو السبب الذي يجعل بعض السيارات تستمر في العمل بشكل جيد'),
                        //       )
                        //     : Column(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           Padding(
                        //             padding: EdgeInsets.symmetric(
                        //                 vertical: 5.w, horizontal: 12.w),
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 CustomText(
                        //                   productDetailsModel?.product?.rating
                        //                           .toString() ??
                        //                       '4.2',
                        //                   fontFamily: 'DINNEXTLTARABIC',
                        //                   color: AppColors.scadryColor,
                        //                 ),
                        //                 RatingBarIndicator(
                        //                     rating: double.parse(
                        //                         productDetailsModel
                        //                                 ?.product?.rating ??
                        //                             '5'),
                        //                     itemCount: 5,
                        //                     itemSize: 40.0,
                        //                     itemBuilder: (context, _) =>
                        //                         const Icon(
                        //                           Icons.star_rate_rounded,
                        //                           color: Colors.orange,
                        //                         )),
                        //                 CustomText(
                        //                   "${productDetailsModel?.product?.ratingCount.toString()}    ${'people'.tr()}" ??
                        //                       'people'.tr(),
                        //                   fontFamily: 'DINNEXTLTARABIC',
                        //                   color: AppColors.scadryColor,
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //           CustomText(
                        //               fontFamily: 'DINNEXTLTARABIC',
                        //               color: AppColors.scadryColor,
                        //               double.parse(productDetailsModel
                        //                               ?.product?.rating ??
                        //                           '0') >=
                        //                       3
                        //                   ? "rat service".tr()
                        //                   : "bad rat service".tr()),
                        //         ],
                        //       ),
                        if (isShoow ?? false)
                          SizedBox(
                            height: 70.h,
                            width: 350.w,
                            child: CarouselSlider.builder(
                              itemCount: 1,
                              itemBuilder: (BuildContext context, int itemIndex,
                                      int pageViewIndex) =>
                                  Container(
                                width: double.infinity,
                                height: 70.h,
                                color: AppColors.scadryColor.withOpacity(0.2),
                                child: CustomText(
                                  productDetailsModel?.order?.ratingComments ??
                                      'لا يوجد تعليقاتلا يوجد تعليقاتلا يوجد تعليقاتلا يوجد تعليقاتلا يوجد تعليقاتلا يوجد تعليقات',
                                  maxLines: 3,
                                ),
                              ),
                              options: CarouselOptions(
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction: 01,
                                aspectRatio: 2.0,
                                initialPage: 1,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedGradientButton(
                          text: 'ratting'.tr(),
                          color: Constants.isQuest == false
                              ? AppColors.scadryColor
                              : AppColors.grey,
                          width: 200.w,
                          height: 48.h,
                          circular: 10.w,
                          onPressed: Constants.isQuest == false
                              ? () {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        // Future.delayed(
                                        //     Duration(seconds: 1000), () {
                                        //   Navigator.of(context).pop(true);
                                        // });
                                        return AlertDialog(
                                            insetPadding: EdgeInsets.all(8.0),
                                            title: CustomText(
                                              "ratting".tr(),
                                              fontSize: 24.sp,
                                              textAlign: TextAlign.center,
                                              fontFamily: 'DINNEXTLTARABIC',
                                              color: AppColors.scadryColor,
                                            ),
                                            content: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.w)),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    100,
                                                height: 300.h,
                                                child: Column(
                                                  children: [
                                                    CustomText(
                                                      'يمكنك اضافة تعليق الان ',
                                                      textAlign:
                                                          TextAlign.center,
                                                      fontFamily:
                                                          'DINNEXTLTARABIC',
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                    SizedBox(
                                                      height: 22.h,
                                                    ),
                                                    RatingBar.builder(
                                                      initialRating: 3,
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4.0),
                                                      itemBuilder:
                                                          (context, index) {
                                                        switch (index) {
                                                          case 0:
                                                            return Icon(
                                                              Icons
                                                                  .sentiment_very_dissatisfied,
                                                              color: Colors.red,
                                                            );
                                                          case 1:
                                                            return Icon(
                                                              Icons
                                                                  .sentiment_dissatisfied,
                                                              color: Colors
                                                                  .redAccent,
                                                            );
                                                          case 2:
                                                            return Icon(
                                                              Icons
                                                                  .sentiment_neutral,
                                                              color:
                                                                  Colors.amber,
                                                            );
                                                          case 3:
                                                            return Icon(
                                                              Icons
                                                                  .sentiment_satisfied,
                                                              color: Colors
                                                                  .lightGreen,
                                                            );
                                                          case 4:
                                                            return Icon(
                                                              Icons
                                                                  .sentiment_very_satisfied,
                                                              color:
                                                                  Colors.green,
                                                            );
                                                        }
                                                        return Icon(
                                                          Icons
                                                              .sentiment_very_satisfied,
                                                          color: Colors.green,
                                                        );
                                                      },
                                                      onRatingUpdate: (rating) {
                                                        setState(() {
                                                          rate = rating;
                                                        });
                                                        print(rating);
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: 30.h,
                                                    ),
                                                    RoundedInputField(
                                                      hintText: 'comment'.tr(),
                                                      onChanged: (value) {},
                                                      hintColor: AppColors.hint,
                                                      color:
                                                          AppColors.lightgrey,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      maxLingth: 100,
                                                      circuler: 10.w,
                                                      height: 48.h,

                                                      // validator: validateEmail,
                                                      seen: false,
                                                      controller: _comment,
                                                    ),
                                                    SizedBox(
                                                      height: 22.h,
                                                    ),
                                                    RaisedGradientButton(
                                                      text: 'التالي',
                                                      width: 340.w,
                                                      color:
                                                          AppColors.scadryColor,
                                                      height: 48.h,
                                                      circular: 10.w,
                                                      onPressed: () async {
                                                        await ref
                                                            .read(
                                                                ordersProvider)
                                                            .addRateDataRequset(
                                                              id: productDetailsModel
                                                                  ?.order?.id,
                                                              comments:
                                                                  _comment.text,
                                                              star_rating: rate,
                                                            );
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/navegaitor_screen');
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: 16.h,
                                                    ),
                                                  ],
                                                )));
                                      });
                                }
                              : () {},
                        ),
                        Container(
                          width: 150.w,
                          padding: EdgeInsets.all(15.w),
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 47, 47, 47)
                                      .withOpacity(0.05),
                                  spreadRadius: 4,
                                  blurRadius: 10,
                                  offset: const Offset(
                                      0, 5), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10.w)),
                          child: Center(
                            child: CustomText(
                              '${productDetailsModel?.order?.price}   ر.س' ??
                                  'ر.س 100 ',
                              color: AppColors.orange,
                              fontSize: 14.sp,
                              fontFamily: 'DINNextLTArabic',
                              textAlign: TextAlign.start,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  GestureDetector orderCard(title, value, isButton) {
    return GestureDetector(
      // onTap: onPress,
      child: Container(
          width: 350.w,
          height: 48.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.w),
              color: AppColors.orange.withOpacity(0.3)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  title,
                  color: AppColors.scadryColor,
                  fontFamily: 'DINNextLTArabic',
                ),
                isButton
                    ? IconButton(
                        onPressed: null,
                        icon: const Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          color: AppColors.scadryColor,
                        ))
                    : CustomText(
                        value,
                        color: AppColors.scadryColor,
                        fontFamily: 'DINNextLTArabic',
                      ),
              ],
            ),
          )),
    );
  }
}
