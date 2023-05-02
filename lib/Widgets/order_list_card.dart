import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/custom_text.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: () {
          stats == 'منتهي'
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ServiceDetailsScreen(
                            id: id,
                            row_id: id,
                          )),
                )
              : null;
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
                      child: Image.network(
                        image,
                        fit: BoxFit.fill,
                        width: 148.w,
                        height: 106.h,
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
                        width: 190.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              title,
                              fontSize: 13.sp,
                            ),
                            CustomText(
                              compeny,
                              fontSize: 12.sp,
                              color: AppColors.orange,
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
                            CustomText(
                              '\$ ${price}  ',
                              fontSize: 13.sp,
                            ),
                            Container(
                              height: 34.h,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                  color: stats != 'منتهي'
                                      ? AppColors.orange
                                      : AppColors.grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10.w)),
                              child: Center(
                                child: TextButton(
                                    onPressed: () {},
                                    child: CustomText(
                                      stats ?? 'قيد التنفيذ',
                                      textAlign: TextAlign.center,
                                      color: stats != 'منتهي'
                                          ? AppColors.white
                                          : AppColors.black,
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
