import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/button_widget.dart';
import 'package:tinti_app/Widgets/custom_appbar.dart';
import 'package:tinti_app/Widgets/custom_text_field.dart';
import 'package:tinti_app/Widgets/loader_widget.dart';

import '../../../../Helpers/failure.dart';
import '../../../../Models/user car/car_model.dart';
import '../../../../Widgets/custom_text.dart';
import '../../../../Widgets/gradint_button.dart';
import '../../../../Widgets/text_widget.dart';
import '../../../../provider/car_provider.dart';

class MyCarsScreen extends ConsumerStatefulWidget {
  const MyCarsScreen({super.key});

  @override
  _MyCarsScreenState createState() => _MyCarsScreenState();
}

class _MyCarsScreenState extends ConsumerState<MyCarsScreen> {
  // var AuthProvider = ref.read(accountProvider);

  Future _getContentData() async {
    final prov = ref.read(carProvider);

    return await prov.getCarDataRequset();
  }

  late Future _fetchedMyRequest;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _fetchedMyRequest = _getContentData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(
          'سياراتي',
          isHome: true,
          isNotification: false,
        ),
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {
              _fetchedMyRequest = _getContentData();
            });
            return _fetchedMyRequest;
          },
          child: SafeArea(
            child: Container(
              width: double.infinity,
              child: Consumer(
                builder: (context, ref, child) => FutureBuilder(
                  future: _fetchedMyRequest,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 70.h,
                        child: const Center(
                          child: LoaderWidget(),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Container(
                            padding: EdgeInsets.all(20.w),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0, 7),
                                    blurRadius: 10,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(20.w),
                                color: AppColors.white.withOpacity(0.9)),
                            width: 320.w,
                            height: 500.h,
                            child: Column(
                              children: [
                                Image.asset('assets/images/nullstate.png'),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Container(
                                  width: 300.w,
                                  child: CustomText(
                                    '  حسابك غير فعال يمكنك التواصل مع الدعم لتفعيل حسابك',
                                    color: AppColors.orange,
                                    // fontWeight: FontWeight.bold,
                                    fontFamily: 'DINNEXTLTARABIC',

                                    textAlign: TextAlign.center,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 60.h,
                                ),
                                RaisedGradientButton(
                                  text: 'تواصل معنا',
                                  color: AppColors.scadryColor,
                                  height: 48.h,
                                  width: 320.w,
                                  circular: 10.w,
                                  onPressed: () {},
                                ),
                              ],
                            )),
                      );
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data is Failure) {
                        return Center(
                            child: TextWidget(snapshot.data.toString()));
                      }
                      //
                      //  print("snapshot data is ${snapshot.data}");
                      var serviceModel =
                          ref.watch(carProvider).getDataList ?? CarModel();
                      print('lingth ${serviceModel.carModles?.length}');
                      return serviceModel.carModles?.length != 0
                          ? ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: serviceModel.carModles?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) =>
                                  Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 10.h),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.w)),
                                      width: 370.w,
                                      height: 160.h,
                                      padding: EdgeInsets.all(10.w),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  CustomText(
                                                    fontFamily:
                                                        'DINNEXTLTARABIC',
                                                    color:
                                                        AppColors.scadryColor,
                                                    serviceModel
                                                            ?.carModles?[index]
                                                            .carModelName ??
                                                        ' أودي  ',
                                                    fontSize: 14.sp,
                                                  ),
                                                ],
                                              ),
                                              CustomText(
                                                fontFamily: 'DINNEXTLTARABIC',
                                                color: AppColors.orange,
                                                serviceModel?.carModles?[index]
                                                        .carNumber ??
                                                    ' 2020  ',
                                                fontSize: 14.sp,
                                              ),
                                              CustomText(
                                                fontFamily: 'DINNEXTLTARABIC',
                                                color: AppColors.scadryColor,
                                                serviceModel?.carModles?[index]
                                                        .color ??
                                                    ' أحمر  ',
                                                fontSize: 14.sp,
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showBottomSheet(
                                                  context,
                                                  'تعديل بيانات السيارة ',
                                                  serviceModel
                                                          ?.carModles?[index]
                                                          .name ??
                                                      '',
                                                  serviceModel
                                                          ?.carModles?[index]
                                                          .carModelName ??
                                                      '',
                                                  serviceModel
                                                          ?.carModles?[index]
                                                          .carSizeName ??
                                                      '',
                                                  serviceModel
                                                          ?.carModles?[index]
                                                          .color ??
                                                      '',
                                                  serviceModel
                                                          ?.carModles?[index]
                                                          .carNumber ??
                                                      '');
                                            },
                                            child: Container(
                                              alignment: Alignment.bottomLeft,
                                              child: Image.asset(
                                                  'assets/images/update_car.png'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 370.w,
                                      height: 180.h,
                                      alignment: Alignment.bottomRight,
                                      child: Image.network(
                                        serviceModel.carModles?[index].image ??
                                            '',
                                        width: 300.w,
                                        height: 100.h,
                                        fit: BoxFit.fill,
                                        alignment: Alignment.bottomRight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.all(20.w),
                              child: Container(
                                  padding: EdgeInsets.all(20.w),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.w),
                                      color: AppColors.lightPrimaryColor
                                          .withOpacity(0.2)),
                                  width: 320.w,
                                  height: 500.h,
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/nullstate.png'),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Container(
                                        width: 300.w,
                                        child: CustomText(
                                          'لم تقم باضافة اي سيارات  يمكنك اضافة واحده الان',
                                          color: AppColors.orange,
                                          // fontWeight: FontWeight.bold,
                                          textAlign: TextAlign.center,
                                          fontFamily: 'DINNEXTLTARABIC',

                                          fontSize: 18.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 60.h,
                                      ),
                                      RaisedGradientButton(
                                        text: 'تصفح المنتجات',
                                        color: AppColors.scadryColor,
                                        height: 48.h,
                                        width: 320.w,
                                        circular: 10.w,
                                        onPressed: () {},
                                      ),
                                    ],
                                  )),
                            );
                      ;
                    }
                    return Container();
                  },
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: Container(
          width: 50.w,
          height: 50.h,
          child: FloatingActionButton(
            onPressed: () {
              showBottomSheet(context, 'اضافة بيانات السيارة ', 'الاسم',
                  'الموديل', 'الحجم', 'اللون', 'الرقم');
            },
            backgroundColor: AppColors.scadryColor,
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

Future<void> showBottomSheet(
    BuildContext context, text, name, model, size, color, number) {
  return showModalBottomSheet<void>(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.w)),
    ),
    builder: (BuildContext context) {
      return Container(
        height: 800.h,
        child: Column(children: [
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsetsDirectional.only(
                start: 18.w, bottom: 12.h, top: 20.h, end: 18.w),
            child: CustomText(
              text,
              color: AppColors.scadryColor,
              fontWeight: FontWeight.w400,
              fontFamily: 'DINNextLTArabic',
              fontSize: 18.sp,
            ),
          ),
          Container(
            width: 340.w,
            height: 150.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.w),
              color: AppColors.scadryColor.withOpacity(0.3),
            ),
            child: Icon(
              Icons.add_to_photos_rounded,
              color: AppColors.orange,
              size: 40.w,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedInputField(
                hintText: name,
                width: 160.w,
                seen: false,
                hintColor: AppColors.grey.withOpacity(0.4),
                onChanged: (val) {},
              ),
              SizedBox(
                width: 15.w,
              ),
              RoundedInputField(
                hintText: model,
                width: 160.w,
                seen: false,
                hintColor: AppColors.grey.withOpacity(0.4),
                onChanged: (val) {},
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedInputField(
                hintText: color,
                hintColor: AppColors.grey.withOpacity(0.4),
                seen: false,
                width: 160.w,
                onChanged: (val) {},
              ),
              SizedBox(
                width: 15.h,
              ),
              RoundedInputField(
                  hintText: size,
                  seen: false,
                  onChanged: (val) {},
                  hintColor: AppColors.grey.withOpacity(0.4),
                  width: 160.w),
            ],
          ),
          RoundedInputField(
            hintText: number,
            seen: false,
            hintColor: AppColors.grey.withOpacity(0.4),
            onChanged: (val) {},
          ),
          SizedBox(
            height: 5.h,
          ),
          RaisedGradientButton(
            text: 'حفظ ',
            color: AppColors.scadryColor,
            height: 48.h,
            width: 340.w,
            circular: 10.w,
            onPressed: () {
              Navigator.popAndPushNamed(context, '/navegaitor_screen');
            },
          ),
        ]),
      );
    },
  );
}
