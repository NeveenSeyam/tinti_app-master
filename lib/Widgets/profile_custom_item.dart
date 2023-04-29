import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';

class ProfileCustomItem extends StatelessWidget {
  String text;
  Function() onpressed;
  ProfileCustomItem({
    super.key,
    required this.text,
    required this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onpressed();
      },
      child: Container(
        width: 340.w,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.w)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
          ),
          child: Row(
            children: [
              Text(
                text,
                style: GoogleFonts.cairo(
                  color: AppColors.scadryColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              IconButton(
                  onPressed: onpressed,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.scadryColor,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
