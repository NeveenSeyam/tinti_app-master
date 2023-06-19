import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/custom_text.dart';
import 'package:tinti_app/provider/products_provider.dart';

import '../../../Helpers/failure.dart';
import '../../../Widgets/custom_appbar.dart';
import '../../../Widgets/loader_widget.dart';
import '../../../Widgets/text_widget.dart';
import '../../../provider/company_provider.dart';

class CompanyProfile extends ConsumerStatefulWidget {
  int id;
  String about;
  String name;
  String img;
  CompanyProfile({
    super.key,
    required this.id,
    required this.about,
    required this.name,
    required this.img,
  });

  @override
  _CompanyProfileState createState() => _CompanyProfileState();
}

class _CompanyProfileState extends ConsumerState<CompanyProfile> {
  Future _getContentData(page) async {
    final prov = ref.read(productsProvider);

    return await prov.getProductDataByCompanyRequsett(
        id: widget.id, page: page);
  }

  late Future _fetchedMyRequest;

  @override
  void initState() {
    _fetchedMyRequest = _getContentData(0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        "company-profile".tr(),
        //${widget.id.toString()
        isProfile: false,
        isNotification: false,
        isHome: true,
      ),
      body: Column(children: [
        Stack(
          children: [
            Center(
              child: Container(
                width: 360.w,
                height: 170.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.w),
                  color: AppColors.black.withOpacity(0.2),
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.bottomCenter,
                      width: 355.w,
                      height: 190.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.w),
                        child: Image.network(
                          widget.img,
                          width: 80.w,
                          height: 80.h,
                          fit: BoxFit.fill,
                        ),
                      )),
                  CustomText(
                    widget.name,
                    textAlign: TextAlign.start,
                    fontSize: 18.sp,
                    fontFamily: 'DINNEXTLTARABIC',
                    fontWeight: FontWeight.w400,
                    color: AppColors.scadryColor,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  profCard('about-company'.tr(), () {
                    showBottomSheet(
                        context,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsetsDirectional.only(
                                  start: 18.w,
                                  bottom: 12.h,
                                  top: 20.h,
                                  end: 18.w),
                              child: CustomText(
                                'about-company'.tr(),
                                color: AppColors.scadryColor,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'DINNextLTArabic',
                                fontSize: 18.sp,
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                children: [
                                  Container(
                                    padding: EdgeInsetsDirectional.only(
                                        start: 18.w,
                                        bottom: 12.h,
                                        top: 20.h,
                                        end: 18.w),
                                    child: CustomText(
                                      widget.about,
                                      color: AppColors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'DINNextLTArabic',
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ));
                  }),
                  SizedBox(
                    height: 12.h,
                  ),
                  profCard('company-services'.tr(), () {
                    showBottomSheet(
                        context,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsetsDirectional.only(
                                  start: 12.w,
                                  bottom: 12.h,
                                  top: 20.h,
                                  end: 12.w),
                              child: CustomText(
                                'company-services'.tr(),
                                color: AppColors.scadryColor,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'DINNextLTArabic',
                                fontSize: 18.sp,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(16.w),
                                child: Consumer(
                                  builder: (context, ref, child) =>
                                      FutureBuilder(
                                    future: _fetchedMyRequest,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SizedBox(
                                          height: 70.h,
                                          child: const Center(
                                            child: LoaderWidget(),
                                          ),
                                        );
                                      }
                                      if (snapshot.hasError) {
                                        return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'),
                                        );
                                      }
                                      print('Error: ${snapshot.error}');
                                      if (snapshot.hasData) {
                                        if (snapshot.data is Failure) {
                                          return Center(
                                              child: TextWidget(
                                                  snapshot.data.toString()));
                                        }

                                        var productModel =
                                            ref.watch(productsProvider);
                                        // print('linght ${productModel}');
                                        return GridView.builder(
                                            physics:
                                                const ClampingScrollPhysics(),
                                            gridDelegate:
                                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 240,
                                              childAspectRatio: 2 / 2.3,
                                              // crossAxisSpacing: 0,
                                              // mainAxisSpacing: 0
                                            ),
                                            itemCount: productModel
                                                    .getProductsCompanyDataList
                                                    ?.success
                                                    ?.items
                                                    ?.length ??
                                                0,
                                            itemBuilder:
                                                (BuildContext ctx, index) {
                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10.w,
                                                    horizontal: 10.h),
                                                child: Container(
                                                  height: 100.h,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: AppColors.grey
                                                              .withOpacity(
                                                                  0.2)),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Colors.white,
                                                          blurRadius: 1.0,
                                                          spreadRadius: 1.0,
                                                          offset: Offset(
                                                            5.0,
                                                            1.0,
                                                          ),
                                                        )
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        10.w,
                                                      )),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.w),
                                                          child: Image.network(
                                                            productModel
                                                                    .getProductsCompanyDataList
                                                                    ?.success
                                                                    ?.items?[
                                                                        index]
                                                                    .image ??
                                                                'assets/images/sa1.jpeg',
                                                            height: 100.h,
                                                            width:
                                                                double.infinity,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  5.w),
                                                          child: CustomText(
                                                            productModel
                                                                    .getProductsCompanyDataList
                                                                    ?.success
                                                                    ?.items?[
                                                                        index]
                                                                    .name ??
                                                                'تظليل',
                                                            color: AppColors
                                                                .scadryColor,
                                                            fontSize: 12.sp,
                                                            fontFamily:
                                                                'DINNextLTArabic',
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  5.w),
                                                          child: CustomText(
                                                            productModel
                                                                    .getProductsCompanyDataList
                                                                    ?.success
                                                                    ?.items?[
                                                                        index]
                                                                    .description ??
                                                                'تلعب العناية المنتظمة بالسيارة دورا كبيرا في المحافظة على ',
                                                            color: AppColors
                                                                .scadryColor,
                                                            fontSize: 9.sp,
                                                            fontFamily:
                                                                'DINNextLTArabic',
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                        )
                                                      ]),
                                                ),
                                              );
                                            });
                                      }
                                      return Container();
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ));
                  }),
                ],
              ),
            ),
          ],
        )
      ]),
    );
  }
}

GestureDetector profCard(title, onPress) {
  return GestureDetector(
    onTap: onPress,
    child: Container(
        width: 350.w,
        height: 52.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w), color: AppColors.white),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                title,
                color: AppColors.scadryColor,
                fontFamily: 'DINNextLTArabic',
              ),
              IconButton(
                  onPressed: onPress,
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.scadryColor,
                  )),
            ],
          ),
        )),
  );
}

Future<void> showBottomSheet(BuildContext context, child) {
  return showModalBottomSheet<void>(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.w)),
    ),
    builder: (BuildContext context) {
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.w),
                topRight: Radius.circular(10.w)),
          ),
          height: 500.h,
          child: child);
    },
  );
}
