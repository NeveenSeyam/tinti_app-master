import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/custom_text.dart';

import '../Modules/Home/main/services/details/servies_details.dart';

class WishListCard extends StatefulWidget {
  String image;
  String title;
  String compeny;
  String details;
  String price;
  int id;

  WishListCard({
    super.key,
    required this.image,
    required this.title,
    required this.compeny,
    required this.details,
    required this.price,
    required this.id,
  });

  @override
  State<WishListCard> createState() => _WishListCardState();
}

class _WishListCardState extends State<WishListCard> {
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
                      id: widget.id,
                      row_id: widget.id,
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
                      child: Image.network(
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
                            Container(
                              width: 100.w,
                              child: CustomText(
                                widget.title,
                                fontSize: 13.sp,
                              ),
                            ),
                            Container(
                              width: 80.w,
                              alignment: Alignment.topLeft,
                              child: CustomText(
                                widget.compeny,
                                fontSize: 12.sp,
                                color: AppColors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 200.w,
                        child: CustomText(widget.details,
                            fontSize: 12.sp,
                            color: AppColors.grey,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        width: 200.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                                        ? Icon(
                                            Icons.favorite_border,
                                            color: AppColors.orange,
                                          )
                                        : Icon(
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
                                SizedBox(
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
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
