import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvailableSizes extends StatefulWidget {
  const AvailableSizes({super.key});

  @override
  State<AvailableSizes> createState() => _AvailableSizesState();
}

class _AvailableSizesState extends State<AvailableSizes> {
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
                    width: 50.w,
                    child: const Center(
                      child: Text(
                        "S",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  width: 50.w,
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
                      "S",
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
                  width: 50.w,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Color(0xffF57A38),
                    borderRadius: BorderRadius.circular(10.w),
                    // border: Border.all(color: Colors.grey),
                  ),
                  child: const Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "M ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Container(
                  width: 50.w,
                  // width: 60.w,
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
                      "M ",
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
                  width: 50.w,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Color(0xffF57A38),
                    borderRadius: BorderRadius.circular(10.w),
                    // border: Border.all(color: Colors.grey),
                  ),
                  child: const Center(
                    child: Text(
                      " L",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Container(
                  width: 50.w,
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
                      " L",
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
              pageIndex = 3;
            });
          },
          child: pageIndex == 3
              ? Container(
                  width: 70.w,
                  padding:
                      EdgeInsets.symmetric(vertical: 3.w, horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xffF57A38),
                    borderRadius: BorderRadius.circular(10.w),
                    // border: Border.all(color: Colors.grey),
                  ),
                  child: const Center(
                    child: Text(
                      "M-SUV",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Container(
                  width: 70.w,
                  padding:
                      EdgeInsets.symmetric(vertical: 3.w, horizontal: 12.w),
                  decoration: BoxDecoration(
                    // color: Colors.orange[300],
                    borderRadius: BorderRadius.circular(10.w),
                    border: Border.all(
                      color: Color(0xffF57A38),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "M-SUV",
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
              pageIndex = 4;
            });
          },
          child: pageIndex == 4
              ? Container(
                  width: 60.w,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: const Color(0xffF57A38),
                    borderRadius: BorderRadius.circular(10.w),
                    // border: Border.all(color: Colors.grey),
                  ),
                  child: const Center(
                    child: Text(
                      "L-SUV",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Container(
                  width: 60.w,
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
                      "L-SUV",
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
