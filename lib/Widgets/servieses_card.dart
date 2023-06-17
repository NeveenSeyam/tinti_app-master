import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/custom_text.dart';
import 'package:tinti_app/provider/services_provider.dart';

import '../provider/favorites_provider.dart';

class ServicesCard extends ConsumerStatefulWidget {
  String image;
  String title;
  String details;
  String price;
  String lastPrice;
  String img2;
  int is_favorite;
  int id;
  ServicesCard(this.image, this.title, this.details, this.price, this.img2,
      this.lastPrice, this.is_favorite, this.id,
      {super.key});

  @override
  _ServicesCardState createState() => _ServicesCardState();
}

class _ServicesCardState extends ConsumerState<ServicesCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170.w,
      child: Card(
        child: Center(
            child: Column(
          children: [
            widget.img2 != ''
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 9.h),
                    child: Center(
                      child: Image.asset(
                        widget.img2,
                        fit: BoxFit.fill,
                        width: 57.95.w,
                        height: 13.97.h,
                      ),
                    ),
                  )
                : Container(),
            widget.img2 != ''
                ? Center(
                    child: Image.asset(
                      widget.image,
                      fit: BoxFit.fill,
                      width: 148.w,
                      height: 106.h,
                    ),
                  )
                : Center(
                    child: Image.network(
                      widget.image,
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: 106.h,
                    ),
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 10.w),
                  child: Text(
                    widget.title,
                    maxLines: 1,
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      fontFamily: 'DINNextLTArabic',
                    ),
                  ),
                ),
                widget.details != ''
                    ? Padding(
                        padding: EdgeInsetsDirectional.only(start: 10.w),
                        child: Text(
                          widget.details,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.orange[500],
                            fontFamily: 'DINNextLTArabic',
                          ),
                        ),
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                      top: 5.h, start: 10.w, end: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        '${widget.price} ر.س',

                        // fontWeight: FontWeight.bold,
                        fontSize: 13.sp, overflow: TextOverflow.ellipsis,
                        fontFamily: 'DINNextLTArabic', maxLines: 1,
                      ),
                      // SizedBox(
                      //   width: 8.w,
                      // ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.is_favorite = widget.is_favorite == 0
                                ? widget.is_favorite = 1
                                : widget.is_favorite = 0;
                            var favModel = ref.watch(favsProvider);

                            if (widget.is_favorite != 0) {
                              favModel.addFavRequset(id: widget.id);
                            } else {
                              favModel.removeFavRequset(id: widget.id);
                            }
                          });
                        },
                        child: Container(
                          width: 25.w,
                          height: 24.h,
                          // decoration: BoxDecoration(
                          //   color: Colors.grey[300],
                          //   borderRadius: BorderRadius.circular(3.w),
                          //   // border: Border.all(color: Colors.grey),
                          // ),
                          child: Icon(
                            widget.is_favorite == 0
                                ? Icons.favorite_border
                                : Icons.favorite,
                            color: widget.is_favorite == 0
                                ? AppColors.grey
                                : AppColors.orange,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
