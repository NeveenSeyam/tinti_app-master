import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiesTypeWidget extends StatefulWidget {
  const ServiesTypeWidget({super.key});

  @override
  State<ServiesTypeWidget> createState() => _ServiesTypeWidgetState();
}

class _ServiesTypeWidgetState extends State<ServiesTypeWidget> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              pageIndex = 0;
            });
          },
          child: pageIndex == 0
              ? Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: const Color(0xffF57A38),
                    borderRadius: BorderRadius.circular(10.w),
                    // border: Border.all(color: Colors.grey),
                  ),
                  child: Container(
                    width: 105.w,
                    child: const Center(
                      child: Text(
                        "عن الخدمة ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  width: 105.w,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    // color: Colors.orange[300],
                    borderRadius: BorderRadius.circular(10.w),
                    border: Border.all(
                      color: Color(0xffF57A38),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "عن الخدمة ",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              pageIndex = 1;
            });
          },
          child: pageIndex == 1
              ? Container(
                  width: 105.w,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Color(0xffF57A38),
                    borderRadius: BorderRadius.circular(10.w),
                    // border: Border.all(color: Colors.grey),
                  ),
                  child: const Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "تفاصيل الخدمة ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Container(
                  width: 105.w,
                  // height: 30.h,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    // color: Colors.orange[300],
                    borderRadius: BorderRadius.circular(10.w),
                    border: Border.all(
                      color: const Color(0xffF57A38),
                    ),
                  ),
                  child: Container(
                    child: Text(
                      "تفاصيل الخدمة ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              pageIndex = 2;
            });
          },
          child: pageIndex == 2
              ? Container(
                  width: 105.w,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Color(0xffF57A38),
                    borderRadius: BorderRadius.circular(10.w),
                    // border: Border.all(color: Colors.grey),
                  ),
                  child: const Center(
                    child: Text(
                      "التقييمات ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Container(
                  width: 105.w,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    // color: Colors.orange[300],
                    borderRadius: BorderRadius.circular(10.w),
                    border: Border.all(
                      color: Color(0xffF57A38),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "التقييمات ",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
