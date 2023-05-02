import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/custom_text.dart';
import 'package:tinti_app/Widgets/servies_details_type.dart';

import '../Modules/Home/main/services/details/servies_details.dart';

class SaelsScreenCardCard extends StatefulWidget {
  String image;
  String title;
  String compeny;
  String details;
  String price;
  String lastPrice;
  SaelsScreenCardCard(
      {super.key,
      required this.image,
      required this.title,
      required this.compeny,
      required this.details,
      required this.price,
      required this.lastPrice});

  @override
  State<SaelsScreenCardCard> createState() => _SaelsScreenCardCardState();
}

class _SaelsScreenCardCardState extends State<SaelsScreenCardCard> {
  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ServiceDetailsScreen(
                      id: 0,
                      row_id: 0,
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
                    height: 145.h,
                    width: 130.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.w), //<-- SEE HERE
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.w),
                      child: Image.asset(
                        widget.image,
                        fit: BoxFit.fill,
                        width: 148.w,
                        height: 150.h,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              widget.title,
                              fontSize: 13.sp,
                            ),
                            CustomText(
                              widget.compeny,
                              fontSize: 12.sp,
                              color: AppColors.orange,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 200.w,
                        child: CustomText(
                          widget.details,
                          fontSize: 12.sp,
                          color: AppColors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 200.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.lastPrice,
                              style: TextStyle(
                                color: Colors.orange,
                                // fontWeight: FontWeight.bold,
                                decoration: TextDecoration.lineThrough,

                                fontSize: 12.sp,
                                fontFamily: 'DINNextLTArabic',
                              ),
                            ),
                            CustomText(
                              widget.price,
                              fontSize: 13.sp,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.grey.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(5.w)),
                                    padding: EdgeInsets.all(4.w),
                                    child: isFav == true
                                        ? const Icon(
                                            Icons.favorite_border,
                                            color: AppColors.orange,
                                          )
                                        : const Icon(
                                            Icons.favorite_border,
                                            color: AppColors.orange,
                                          ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      isFav == true
                                          ? isFav = false
                                          : isFav = true;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(5.w)),
                                  padding: EdgeInsets.all(4.w),
                                  child: Image.asset(
                                    'assets/images/aaddd.png',
                                    fit: BoxFit.fill,
                                    width: 20.w,
                                    color: AppColors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
