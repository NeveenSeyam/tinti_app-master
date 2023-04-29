import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Modules/Home/notification/notification_page.dart';
import 'package:tinti_app/Modules/Home/profile/profile_page.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  bool? isHome;
  bool? isNotification;
  bool? isProfile;
  final String title;

  CustomAppBar(
    this.title, {
    this.isHome,
    this.isProfile,
    this.isNotification,
    Key? key,
  })  : preferredSize = Size.fromHeight(100.h),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(bottom: 30.w),
        child: AppBar(
          leading: GestureDetector(
            onTap: () {
              isHome == true
                  ? Navigator.of(context).pop()
                  : isProfile == false
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage()),
                        )
                      : Container();
            },
            child: SizedBox(
                width: 50.w,
                height: 50.h,
                child: isHome == true
                    ? const Icon(
                        Icons.arrow_back_ios_rounded,
                        textDirection: TextDirection.rtl,
                      )
                    : Image.asset("assets/images/prof_photo.png")),
          ),
          actions: [
            isNotification == false
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationScreen()),
                      );
                    },
                    child: Image.asset(
                      'assets/images/notification.png', width: 50.w,
                      // fit: BoxFit.fill,
                    ),
                  )
                : Container(),
          ],
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 100.h,
          title: Text(
            title,
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
      ),
    );
  }
}
