import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Util/theme/app_colors.dart';

class CustomDropDown extends StatefulWidget {
  final String hintText;
  final String title;
  final String? value;
  final List<String>? list;
  final void Function(String?)? onChange;

  const CustomDropDown(
      {Key? key,
      required this.hintText,
      required this.title,
      this.value,
      this.onChange,
      required this.list})
      : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
// Initial Selected Value
  var textController = TextEditingController();
  // List of items in our dropdown menu
  List<String> items = [];
  @override
  void initState() {
    items = widget.list ?? [];

    textController.text = widget.value ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TextWidget(
          //   widget.title,
          //   color: AppColors.superLlightGray2,
          // ),
          // SizedBox(
          //   height: 1.h,
          // ),
          GestureDetector(
            onTap: () {
              showCupertinoModalPopup<void>(
                // barrierColor: Colors.transparent,

                context: context,
                builder: (BuildContext context) => Container(
                  //   height: 50.h,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: CupertinoActionSheet(
                    //  title: const Text('Title'),

                    message: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        // shrinkWrap: true,
                        // padding: EdgeInsets.zero,
                        // physics: const ClampingScrollPhysics(),
                        children: items.map((String item) {
                          return Material(
                            color: Colors.white,
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  if (item != '-')
                                    ListTile(
                                      //   tileColor: Colors.transparent,
                                      title: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w),
                                        child: Text(item),
                                      ),
                                      onTap: () {
                                        print(item);
                                        Navigator.pop(context);
                                        textController.text = item;
                                        return widget.onChange!(item);
                                      },
                                    ),
                                  if (item != '-') const Divider()
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    cancelButton: CupertinoActionSheetAction(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.w),
              child: TextFormField(
                controller: textController,
                obscureText: false,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                minLines: 1,
                enabled: false,
                maxLines: 1,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11.sp,
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.w),
                    borderSide: BorderSide(color: AppColors.lightgrey),
                  ),
                  fillColor: AppColors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.w),
                    borderSide: BorderSide(color: AppColors.lightgrey),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.w),
                    borderSide: const BorderSide(color: AppColors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.w),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                  hintText: widget.hintText,
                  suffixIcon: const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }
}
