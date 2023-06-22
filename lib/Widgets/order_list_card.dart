import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/custom_text.dart';

import '../Modules/Home/main/services/details/order_details.dart';
import '../Modules/Home/main/services/details/servies_details.dart';
import 'button_widget.dart';
import 'custom_button.dart';

class OrderListCard extends StatelessWidget {
  String image;
  String title;
  String compeny;
  String details;
  String price;
  int id;
  int? product_id;
  int isFavorite;
  String stats;
  OrderListCard({
    super.key,
    required this.image,
    required this.title,
    required this.compeny,
    required this.details,
    required this.price,
    required this.id,
    required this.stats,
    required this.isFavorite,
    required this.product_id,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderDetailsScreen(
                      id: product_id ?? 0,
                      row_id: id,
                      isFavorite: isFavorite,
                    )),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.w),
              color: AppColors.white),
          child: Column(
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 130.h,
                    width: 128.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.w), //<-- SEE HERE
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.w),
                      child: CachedNetworkImage(
                        width: 130.h,
                        height: 130.h,
                        imageUrl: image ??
                            'https://www.sayyarte.com/img/1678171026.png',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                                colorFilter: ColorFilter.mode(
                                    Colors.red, BlendMode.dst)),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image.network(
                          'https://www.sayyarte.com/img/1678171026.png',
                          width: 130.h,
                          height: 130.h,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 210.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 100.w,
                              child: CustomText(
                                title,
                                fontSize: 13.sp,
                              ),
                            ),
                            Container(
                              width: 110.w,
                              alignment: Alignment.topLeft,
                              child: CustomText(
                                compeny,
                                maxLines: 1,
                                fontSize: 11.sp,
                                color: AppColors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 200.w,
                        child: CustomText(details,
                            fontSize: 12.sp,
                            color: AppColors.grey,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      SizedBox(
                        width: 200.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  '${price} ',
                                  fontSize: 13.sp,
                                ),
                                CustomText(
                                  '${"RS".tr()} ',
                                  color: AppColors.orange,
                                  fontSize: 13.sp,
                                ),
                              ],
                            ),
                            Container(
                              height: 34.h,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                  color: stats != 'finished'.tr()
                                      ? AppColors.orange
                                      : AppColors.scadryColor.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10.w)),
                              child: Center(
                                child: TextButton(
                                    onPressed: () {},
                                    child: CustomText(
                                      stats ?? 'on progress'.tr(),
                                      textAlign: TextAlign.center,
                                      color: stats != 'finished'.tr()
                                          ? AppColors.white
                                          : AppColors.white,
                                      fontFamily: 'DINNextLTArabic',
                                      fontSize: 12.sp,
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
