import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Widgets/custom_text.dart';
import 'package:tinti_app/provider/favorites_provider.dart';

import '../Util/theme/app_colors.dart';
import '../provider/products_provider.dart';

class latestOffersCard extends ConsumerStatefulWidget {
  String id;
  String image;
  String title;
  String details;
  String price;
  String lastPrice;
  String img2;
  int is_favorite;
  latestOffersCard(this.image, this.title, this.details, this.price, this.img2,
      this.lastPrice, this.is_favorite, this.id,
      {super.key});

  @override
  _latestOffersCardState createState() => _latestOffersCardState();
}

class _latestOffersCardState extends ConsumerState<latestOffersCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170.w,
      child: Card(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.img2 != ''
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 9.h),
                    child: Center(
                      child: Image.asset(
                        widget.img2,
                        fit: BoxFit.fill,
                        width: 57.95.w,
                        height: 14.97.h,
                      ),
                    ),
                  )
                : Container(),
            widget.img2 != ''
                ? Center(
                    child: CachedNetworkImage(
                      width: 148.w,
                      height: 106.h,
                      imageUrl: widget.image ??
                          'https://www.sayyarte.com/img/1678171026.png',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                              colorFilter: ColorFilter.mode(
                                  Colors.white, BlendMode.dst)),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image.network(
                        'https://www.sayyarte.com/img/1678171026.png',
                        width: 148.w,
                        height: 106.h,
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                : Center(
                    child: Image.asset(
                      widget.image,
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: 106.h,
                    ),
                  ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 10.w),
              child: CustomText(
                widget.title,
                maxLines: 1,
                // fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                fontFamily: 'DINNextLTArabic',
              ),
            ),
            widget.details != ''
                ? Padding(
                    padding: EdgeInsetsDirectional.only(start: 10.w),
                    child: CustomText(
                      widget.details,
                      fontSize: 12.sp,
                      color: Colors.orange[500],
                      fontFamily: 'DINNextLTArabic',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsetsDirectional.only(top: 5.h, start: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    widget.lastPrice!,
                    style: TextStyle(
                      color: Colors.orange,
                      // fontWeight: FontWeight.bold,
                      decoration: TextDecoration.lineThrough,

                      fontSize: 12.sp,
                      fontFamily: 'DINNextLTArabic',
                    ),
                  ),
                  Text(
                    '${widget.price} ${"RS".tr()}',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                      fontFamily: 'DINNextLTArabic',
                    ),
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
                      //   color: Colors.grey[100],
                      //   borderRadius: BorderRadius.circular(3.w),
                      //   // border: Border.all(color: Colors.grey),
                      // ),
                      child: Center(
                        child: Icon(
                          widget.is_favorite == 0
                              ? Icons.favorite
                              : Icons.favorite,
                          color: widget.is_favorite == 0
                              ? AppColors.grey.withOpacity(0.5)
                              : AppColors.orange,
                          size: 23.w,
                        ),
                      ),
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
