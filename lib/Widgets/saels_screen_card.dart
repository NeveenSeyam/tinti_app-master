import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/custom_text.dart';
import 'package:tinti_app/Widgets/servies_details_type.dart';

import '../Modules/Home/main/services/details/servies_details.dart';
import '../provider/favorites_provider.dart';

class SaelsScreenCardCard extends ConsumerStatefulWidget {
  int id;
  String image;
  String title;
  String details;
  String price;
  String lastPrice;
  int isFavorite;
  SaelsScreenCardCard(
      {super.key,
      required this.image,
      required this.title,
      required this.details,
      required this.price,
      required this.lastPrice,
      required this.id,
      required this.isFavorite});

  @override
  _SaelsScreenCardCardState createState() => _SaelsScreenCardCardState();
}

class _SaelsScreenCardCardState extends ConsumerState<SaelsScreenCardCard> {
  int isFav = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w), color: AppColors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
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
                    child: CachedNetworkImage(
                      height: 150.h,
                      imageUrl: widget.image ??
                          'https://www.sayyarte.com/img/1678171026.png',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                              colorFilter:
                                  ColorFilter.mode(Colors.red, BlendMode.dst)),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image.network(
                        'https://www.sayyarte.com/img/1678171026.png',
                        height: 150.h,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  height: 150.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 200.w,
                        child: CustomText(
                          widget.title,
                          fontSize: 13.sp,
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
                              "${widget.lastPrice}${"RS".tr()}",
                              style: TextStyle(
                                color: Colors.orange,
                                // fontWeight: FontWeight.bold,
                                decoration: TextDecoration.lineThrough,

                                fontSize: 12.sp,
                                fontFamily: 'DINNextLTArabic',
                              ),
                            ),
                            CustomText(
                              "${widget.price}${"RS".tr()}",
                              fontSize: 13.sp,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget.isFavorite == 1
                                          ? widget.isFavorite = 0
                                          : widget.isFavorite = 1;

                                      widget.isFavorite == 1
                                          ? isFav = 0
                                          : isFav = 1;
                                      var favModel = ref.watch(favsProvider);

                                      if (widget.isFavorite != 0) {
                                        favModel.addFavRequset(id: widget.id);
                                      } else {
                                        favModel.removeFavRequset(
                                            id: widget.id);
                                        //  _fetchedFvsRequest = _getFavsData();

                                        //   _fetchedFvsRequest;
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 25.w,
                                    height: 24.h,
                                    child: Icon(
                                      widget.isFavorite == 0
                                          ? Icons.favorite
                                          : Icons.favorite,
                                      color: widget.isFavorite == 0
                                          ? AppColors.grey.withOpacity(0.5)
                                          : AppColors.orange,
                                      size: 22.w,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  // decoration: BoxDecoration(
                                  //     color: AppColors.grey.withOpacity(0.2),
                                  //     borderRadius: BorderRadius.circular(5.w)),
                                  padding: EdgeInsets.all(4.w),
                                  child: Icon(
                                    Icons.shopping_bag_outlined,
                                    color: AppColors.orange,
                                    size: 23.w,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
