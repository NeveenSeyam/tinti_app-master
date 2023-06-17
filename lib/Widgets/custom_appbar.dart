import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinti_app/Modules/Home/notification/notification_page.dart';
import 'package:tinti_app/Modules/Home/profile/profile_page.dart';
import 'package:tinti_app/Util/constants/constants.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';

import '../Modules/auth/login_screen.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  bool? isHome;
  bool? isNotification;
  bool? isProfile;
  bool? isQuest;
  final String title;

  CustomAppBar(
    this.title, {
    this.isHome,
    this.isProfile,
    this.isNotification,
    this.isQuest,
    Key? key,
  })  : preferredSize = Size.fromHeight(100.h),
        super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30.w),
      child: AppBar(
        leading: Container(
          width: 50.w,
          child: GestureDetector(
            onTap: () {
              widget.isHome == true
                  ? Navigator.of(context).pop()
                  : widget.isProfile == false
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()),
                        )
                      : Container();
            },
            child: SizedBox(
                width: 50.w,
                height: 50.h,
                child: widget.isHome == true
                    ? Constants.lang == 'ar'
                        ? const Icon(
                            Icons.arrow_back_ios_rounded,
                            textDirection: TextDirection.rtl,
                          )
                        : const Icon(Icons.arrow_back_ios_rounded,
                            textDirection: TextDirection.ltr)
                    : null
                // Image.asset("assets/images/prof_photo.png")
                ),
          ),
        ),
        actions: [
          Constants.isQuest == false
              ? widget.isNotification == false
                  ? Padding(
                      padding:
                          EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationScreen()),
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/images/notii.svg', width: 18.w,
                          // fit: BoxFit.fill,
                        ),
                      ),
                    )
                  : Container()
              : GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Image.asset(
                    'assets/images/login-.png', width: 50.w,
                    // fit: BoxFit.fill,
                  ),
                ),
        ],
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 100.h,
        title: Text(
          widget.title,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontFamily: 'DINNEXTLTARABIC',
              fontSize: 22.sp),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          height: 100.h,
          decoration: BoxDecoration(
            color: AppColors.scadryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.w),
              bottomRight: Radius.circular(20.w),
            ),
          ),
        ),
      ),
    );
  }
}
