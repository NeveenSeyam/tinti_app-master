import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_button.dart';

class ServiesImages extends StatelessWidget {
  final String image;

  const ServiesImages({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Center(
                        child: CachedNetworkImage(
                          width: 360.w,
                          height: 180.h,
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
                            width: 360.w,
                            height: 180.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
