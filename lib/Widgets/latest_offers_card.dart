import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class latestOffersCard extends StatelessWidget {
  String image;
  String title;
  String details;
  String price;
  String lastPrice;
  String img2;
  latestOffersCard(this.image, this.title, this.details, this.price, this.img2,
      this.lastPrice,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170.w,
      child: Card(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            img2 != ''
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 9.h),
                    child: Center(
                      child: Image.asset(
                        img2,
                        fit: BoxFit.fill,
                        width: 57.95.w,
                        height: 14.97.h,
                      ),
                    ),
                  )
                : Container(),
            img2 != ''
                ? Center(
                    child: Image.network(
                      image,
                      fit: BoxFit.fill,
                      width: 148.w,
                      height: 106.h,
                    ),
                  )
                : Center(
                    child: Image.asset(
                      image,
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: 106.h,
                    ),
                  ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 10.w),
              child: Text(
                title,
                style: const TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'DINNextLTArabic',
                ),
              ),
            ),
            details != ''
                ? Padding(
                    padding: EdgeInsetsDirectional.only(start: 10.w),
                    child: Text(
                      details,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange[500],
                        fontFamily: 'DINNextLTArabic',
                      ),
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsetsDirectional.only(top: 5.h, start: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    lastPrice!,
                    style: TextStyle(
                      color: Colors.orange,
                      // fontWeight: FontWeight.bold,
                      decoration: TextDecoration.lineThrough,

                      fontSize: 12.sp,
                      fontFamily: 'DINNextLTArabic',
                    ),
                  ),
                  Text(
                    '$price\$',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                      fontFamily: 'DINNextLTArabic',
                    ),
                  ),
                  // SizedBox(
                  //   width: 8.w,
                  // ),

                  Container(
                    width: 25.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(3.w),
                      // border: Border.all(color: Colors.grey),
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.orange,
                    ),
                  )
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
