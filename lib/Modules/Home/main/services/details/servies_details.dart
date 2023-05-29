import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Modules/Home/main/services/details/reguest_servies.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/custom_appbar.dart';
import 'package:tinti_app/Widgets/custom_text.dart';
import 'package:tinti_app/provider/products_provider.dart';
import '../../../../../Helpers/failure.dart';
import '../../../../../Util/constants/constants.dart';
import '../../../../../Widgets/available_size.dart';
import '../../../../../Widgets/gradint_button.dart';
import '../../../../../Widgets/loader_widget.dart';
import '../../../../../Widgets/page_view_indicator_Home.dart';
import '../../../../../Widgets/servies_images.dart';

import '../../../../../Widgets/text_widget.dart';
import '../../../../../provider/favorites_provider.dart';
import '../service_page.dart';

class ServiceDetailsScreen extends ConsumerStatefulWidget {
  dynamic row_id;
  int id;
  int isFavorite;
  ServiceDetailsScreen(
      {super.key,
      required this.id,
      required this.row_id,
      required this.isFavorite});

  @override
  _ServiceDetailsScreenState createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends ConsumerState<ServiceDetailsScreen> {
  int pageIndex = 0;
  // bool isFav = false;
  late PageController _pageController;
  int _currentPage = 0;
  late final _ratingController;

  double? _rating;
  IconData? _selectedIcon;

  Future _getProducDetailsData() async {
    final prov = ref.read(productsProvider);

    return await prov.getSingleProductDataRequset(id: widget.id);
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
        'تفاصيل الخدمة',
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
                  ref.watch(productsProvider).getSingleProduct;
              var addToFavModel = ref.watch(favsProvider);
              // var removeFavModel = ref.watch(favsProvider);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          // width: 350.w,
                          height: 200.h,
                          child: SizedBox(
                            height: 250.h,
                            child:
                                //    PageView.builder(
                                //     padEnds: false,
                                //     controller: _pageController,
                                //     itemBuilder: (context, index) {
                                //       return Opacity(
                                //         opacity: 1,
                                //         child: ServiesImages(
                                //           image: productDetailsModel?.product
                                //                   ?.productImages?[index] ??
                                //               'sa2',
                                //         ),
                                //       );
                                //     },
                                //     itemCount: productDetailsModel
                                //             ?.product?.productImages?.length ??
                                //         0,
                                //   ),
                                // ),

                                PageView(
                              scrollDirection: Axis.horizontal,
                              // controller: _pageController,
                              physics: const BouncingScrollPhysics(),
                              onPageChanged: (int currentPage) {
                                setState(() => _currentPage = currentPage);
                              },
                              children: [
                                ServiesImages(
                                  image: productDetailsModel?.product?.image ??
                                      'http://sayyarte.com/img/1676279090.jpg',
                                ),
                                ServiesImages(
                                  image: productDetailsModel
                                          ?.product?.productImages?[1] ??
                                      'http://sayyarte.com/img/1676279090.jpg',
                                ),
                                ServiesImages(
                                  image: productDetailsModel
                                          ?.product?.productImages?[2] ??
                                      'http://sayyarte.com/img/1676279090.jpg',
                                ),
                                ServiesImages(
                                  image: productDetailsModel
                                          ?.product?.productImages?[3] ??
                                      'http://sayyarte.com/img/1676279090.jpg',
                                ),
                                ServiesImages(
                                  image: productDetailsModel
                                          ?.product?.productImages?[4] ??
                                      'http://sayyarte.com/img/1676279090.jpg',
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: _currentPage < 5,
                                maintainSize: true,
                                maintainState: true,
                                maintainAnimation: true,
                                child: Row(
                                  children: [
                                    PageViewIndicatorCustomHome(
                                      isCurrentPage: _currentPage == 0,
                                      // marginEnd: 1.w,
                                    ),
                                    PageViewIndicatorCustomHome(
                                      isCurrentPage: _currentPage == 1,
                                      // marginEnd: 1.w,
                                    ),
                                    PageViewIndicatorCustomHome(
                                      // marginEnd: 1.w,
                                      isCurrentPage: _currentPage == 2,
                                    ),
                                    PageViewIndicatorCustomHome(
                                      // marginEnd: 1.w,
                                      isCurrentPage: _currentPage == 3,
                                    ),
                                    PageViewIndicatorCustomHome(
                                      // marginEnd: 1.w,
                                      isCurrentPage: _currentPage == 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  productDetailsModel?.product?.name ??
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
                                  productDetailsModel?.product?.service ??
                                      'جونسون اند جونسون ',
                                  color: AppColors.orange,
                                  fontSize: 14.sp,
                                  fontFamily: 'DINNextLTArabic',
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.isFavorite == 0
                                      ? widget.isFavorite = 1
                                      : widget.isFavorite = 0;
                                  var favModel = ref.watch(favsProvider);

                                  if (widget.isFavorite != 0) {
                                    favModel.addFavRequset(id: widget.id);
                                  } else {
                                    favModel.removeFavRequset(id: widget.id);
                                  }
                                });
                              },
                              child: Container(
                                width: 25.w,
                                height: 24.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(3.w),
                                  // border: Border.all(color: Colors.grey),
                                ),
                                child: Icon(
                                  widget.isFavorite == 0
                                      ? Icons.favorite_border
                                      : Icons.favorite,
                                  color: widget.isFavorite == 0
                                      ? AppColors.grey
                                      : AppColors.orange,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  pageIndex = 0;
                                });
                              },
                              child: pageIndex == 0
                                  ? Container(
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF57A38),
                                        borderRadius:
                                            BorderRadius.circular(10.w),
                                        // border: Border.all(color: Colors.grey),
                                      ),
                                      child: Container(
                                        width: 165.w,
                                        child: const Center(
                                          child: Text(
                                            "عن الخدمة ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 165.w,
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                        // color: Colors.orange[300],
                                        borderRadius:
                                            BorderRadius.circular(10.w),
                                        border: Border.all(
                                          color: Color(0xffF57A38),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          "عن الخدمة ",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  pageIndex = 1;
                                });
                              },
                              child: pageIndex == 1
                                  ? Container(
                                      width: 165.w,
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                        color: Color(0xffF57A38),
                                        borderRadius:
                                            BorderRadius.circular(10.w),
                                        // border: Border.all(color: Colors.grey),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "التقييمات ",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 165.w,
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                        // color: Colors.orange[300],
                                        borderRadius:
                                            BorderRadius.circular(10.w),
                                        border: Border.all(
                                          color: Color(0xffF57A38),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "التقييمات ",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                        pageIndex == 0
                            ? Padding(
                                padding: EdgeInsets.all(5.w),
                                child: CustomText(
                                    fontFamily: 'DINNEXTLTARABIC',
                                    color: AppColors.scadryColor,
                                    productDetailsModel?.product?.description ??
                                        'تلعب العناية المنتظمة بالسيارة دورا كبيرا في المحافظة على السيارات وهذا هو السبب الذي يجعل بعض السيارات تستمر في العمل بشكل جيد'),
                              )
                            : Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5.w, horizontal: 12.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          productDetailsModel?.product?.rating
                                                  .toString() ??
                                              '4.2',
                                          fontFamily: 'DINNEXTLTARABIC',
                                          color: AppColors.scadryColor,
                                        ),
                                        RatingBarIndicator(
                                            rating: double.parse(
                                                productDetailsModel
                                                        ?.product?.rating ??
                                                    '5'),
                                            itemCount: 5,
                                            itemSize: 40.0,
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                                  Icons.star_rate_rounded,
                                                  color: Colors.orange,
                                                )),
                                        CustomText(
                                          "${productDetailsModel?.product?.ratingCount.toString()}  اشخاص" ??
                                              ' اشخاص',
                                          fontFamily: 'DINNEXTLTARABIC',
                                          color: AppColors.scadryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  CustomText(
                                      fontFamily: 'DINNEXTLTARABIC',
                                      color: AppColors.scadryColor,
                                      double.parse(productDetailsModel
                                                      ?.product?.rating ??
                                                  '0') >=
                                              3
                                          ? 'تم تقييم الخدمة من قبل مشترين وزوار للموقع وكانت من ضمن الأعلى تقييما في الموقع'
                                          : 'تم تقييم الخدمة من قبل مشترين وزوار للموقع وكانت من ضمن الأقلل تقييما في الموقع'),
                                ],
                              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedGradientButton(
                          text: '  طلب الخدمة',
                          color: Constants.isQuest == false
                              ? AppColors.scadryColor
                              : AppColors.grey,
                          width: 280.w,
                          height: 48.h,
                          circular: 10.w,
                          onPressed: Constants.isQuest == false
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RequestServieses()),
                                  );
                                }
                              : () {},
                        ),
                        Container(
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
                          child: CustomText(
                            '\$ ${productDetailsModel?.product?.price}' ??
                                '\$ 100 ',
                            color: AppColors.orange,
                            fontSize: 14.sp,
                            fontFamily: 'DINNextLTArabic',
                            textAlign: TextAlign.start,
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
}
