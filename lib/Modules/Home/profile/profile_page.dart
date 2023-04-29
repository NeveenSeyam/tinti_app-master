import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pinput.dart';
import 'package:tinti_app/Models/auth/profile_model.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/button_widget.dart';
import 'package:tinti_app/Widgets/custom_text.dart';
import 'package:tinti_app/provider/account_provider.dart';

import '../../../Helpers/failure.dart';
import '../../../Widgets/custom_appbar.dart';
import '../../../Widgets/custom_text_field.dart';
import '../../../Widgets/gradint_button.dart';
import '../../../Widgets/loader_widget.dart';
import '../../../Widgets/text_widget.dart';
import '../../../provider/car_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

enum Language {
  Arabic,
  English,
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  int pageIndex = 0;
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  late PageController _pageController;
  File? img;
  File? _image2;
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image2 = File(pickedFile!.path);
    });
  }

  Future _getImageData() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    img = File(pickedFile!.path);
  }

  Future _getContentData() async {
    final prov = ref.read(accountProvider);

    return await prov.getUserProfileRequset();
  }

  late Future _fetchedMyRequest;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    _fetchedMyRequest = _getContentData();

    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _value = 'العربية';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: RefreshIndicator(
        onRefresh: () {
          setState(() {
            _fetchedMyRequest = _getContentData();
          });
          return _fetchedMyRequest;
        },
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: CustomAppBar(
            "حسابي",
            isNotification: false,
            isProfile: true,
            isHome: false,
          ),
          body: Consumer(
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
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (snapshot.hasData) {
                  if (snapshot.data is Failure) {
                    return Center(child: TextWidget(snapshot.data.toString()));
                  }
                  //
                  //  print("snapshot data is ${snapshot.data}");
                  var serviceModel =
                      ref.watch(accountProvider).getProfileModel ??
                          ProfileModel();
                  var profileModel = ref.watch(accountProvider);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.w)),
                          padding: EdgeInsets.all(10.w),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 350.w,
                                height: 150.h,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 85.w,
                                      height: 85.h,
                                      child: Image.network(
                                        '${serviceModel.user?.img}',
                                        fit: BoxFit.fill,
                                        width: 85.w,
                                        height: 85.w,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(3.h),
                                      child: CustomText(
                                        '  ${serviceModel.user?.fname} ${serviceModel.user?.lname} ' ??
                                            'ناجي البلتاجي',
                                        fontFamily: 'DINNextLTArabic',
                                        color: AppColors.scadryColor,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20.sp,
                                      ),
                                    ),
                                    CustomText(
                                      serviceModel.user?.email ??
                                          'naji@gmail.com',
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'DINNextLTArabic',
                                      color: AppColors.scadryColor,
                                      fontSize: 10.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 10.h),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.w)),
                          padding: EdgeInsets.all(10.w),
                          child: Column(
                            children: [
                              profCard('البيانات الشخصية', () {
                                showBottomSheet(
                                  context,
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsetsDirectional.only(
                                              end: 16.w,
                                              bottom: 12.h,
                                              top: 20.h),
                                          child: CustomText(
                                            'البيانات الشخصية',
                                            color: AppColors.scadryColor,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'DINNextLTArabic',
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            dataContainer(
                                                170.w,
                                                serviceModel.user?.lname ??
                                                    'البلتاجي'),
                                            SizedBox(
                                              width: 15.w,
                                            ),
                                            dataContainer(
                                                170.w,
                                                serviceModel.user?.fname ??
                                                    'ناجي'),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        Center(
                                          child: dataContainer(
                                              355.w,
                                              serviceModel.user?.email ??
                                                  'Naji@gmail.com'),
                                        ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        Center(
                                          child: dataContainer(
                                              355.w,
                                              serviceModel.user?.mobile ??
                                                  '+972597031739'),
                                        ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        Center(
                                          child: dataContainer(
                                              355.w,
                                              serviceModel.user?.address ??
                                                  'جدة'),
                                        ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.h),
                                          child: ButtonWidget(
                                            onPressed: () {
                                              showBottomSheet(
                                                context,
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .only(
                                                                    end: 20.w,
                                                                    bottom:
                                                                        12.h,
                                                                    top: 20.h),
                                                        child: CustomText(
                                                          'تعديل البيانات الشخصية',
                                                          color: AppColors
                                                              .scadryColor,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontFamily:
                                                              'DINNextLTArabic',
                                                          fontSize: 18.sp,
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          _getImageData();
                                                          // print('img $img');
                                                        },
                                                        child: Center(
                                                          child: Container(
                                                            width: 350.w,
                                                            height: 150.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.w),
                                                              color: AppColors
                                                                  .scadryColor
                                                                  .withOpacity(
                                                                      0.3),
                                                            ),
                                                            child: Icon(
                                                              Icons
                                                                  .add_to_photos_rounded,
                                                              color: AppColors
                                                                  .orange,
                                                              size: 40.w,
                                                            ),
                                                          ),
                                                        )),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        editDataContainer(
                                                            170.w,
                                                            serviceModel.user
                                                                    ?.lname ??
                                                                'البلتاجي',
                                                            _lnameController),
                                                        SizedBox(
                                                          width: 15.w,
                                                        ),
                                                        editDataContainer(
                                                            170.w,
                                                            serviceModel.user
                                                                    ?.fname ??
                                                                'ناجي',
                                                            _fnameController),
                                                      ],
                                                    ),
                                                    Center(
                                                      child: editDataContainer(
                                                          355.w,
                                                          serviceModel.user
                                                                  ?.email ??
                                                              'Naji@gmail.com',
                                                          _emailController),
                                                    ),
                                                    Center(
                                                      child: editDataContainer(
                                                          355.w,
                                                          serviceModel.user
                                                                  ?.mobile ??
                                                              '+972597031739',
                                                          _numberController),
                                                    ),
                                                    Center(
                                                      child: editDataContainer(
                                                          355.w,
                                                          serviceModel.user
                                                                  ?.address ??
                                                              'جدة',
                                                          _addressController),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 16.h),
                                                      child: ButtonWidget(
                                                        onPressed: () async {
                                                          await profileModel
                                                              .editUserRequset(
                                                                  data: {
                                                                "fname":
                                                                    _fnameController
                                                                        .text,
                                                                "lname":
                                                                    _lnameController
                                                                        .text,
                                                                "email":
                                                                    _emailController
                                                                        .text,
                                                                "phoneNumber":
                                                                    _numberController
                                                                        .text,
                                                                "address":
                                                                    _addressController
                                                                        .text
                                                              },
                                                                  file: img);
                                                          setState(() {
                                                            _fetchedMyRequest =
                                                                _getContentData();
                                                          });

                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        title: 'حفظ',
                                                        backgroundColor:
                                                            AppColors
                                                                .scadryColor,
                                                        textColor:
                                                            AppColors.white,
                                                        height: 45.h,
                                                        verticalTextPadding: 0,
                                                        horizontalTextPadding:
                                                            0,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                            title: 'تعديل البيانات ',
                                            backgroundColor:
                                                AppColors.scadryColor,
                                            textColor: AppColors.white,
                                            height: 45.h,
                                            verticalTextPadding: 0,
                                            horizontalTextPadding: 0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              SizedBox(
                                height: 10.h,
                              ),
                              profCard('إعادة تعيين كلمة المرور ', () {
                                showBottomSheet(
                                    context,
                                    Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerRight,
                                            padding: EdgeInsetsDirectional.only(
                                                start: 20.w,
                                                bottom: 12.h,
                                                top: 20.h),
                                            child: CustomText(
                                              'إعادة تعيين كلمة المرور ',
                                              color: AppColors.scadryColor,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'DINNextLTArabic',
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                          Center(
                                            child: RoundedInputField(
                                              color: AppColors.grey
                                                  .withOpacity(0.1),
                                              hintText: 'كلمة المرور القديمة',
                                              width: 355.w,
                                              height: 48.h,
                                              onChanged: (value) {},
                                              seen: true,
                                              icon: Icon(Icons.key),
                                              hintColor: AppColors.grey
                                                  .withOpacity(0.7),
                                            ),
                                          ),
                                          Center(
                                            child: RoundedInputField(
                                              color: AppColors.grey
                                                  .withOpacity(0.1),
                                              hintText: 'كلمة المرور الجديدة',
                                              width: 355.w,
                                              height: 48.h,
                                              onChanged: (value) {},
                                              seen: true,
                                              icon: Icon(Icons.key),
                                              hintColor: AppColors.grey
                                                  .withOpacity(0.7),
                                            ),
                                          ),
                                          Center(
                                            child: RoundedInputField(
                                              color: AppColors.grey
                                                  .withOpacity(0.1),
                                              hintText:
                                                  'تأكيد كلمة المرور الجديدة',
                                              width: 355.w,
                                              height: 48.h,
                                              onChanged: (value) {},
                                              seen: true,
                                              icon: Icon(Icons.key),
                                              hintColor: AppColors.grey
                                                  .withOpacity(0.7),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 26.w),
                                            child: CustomText(
                                              'نسيت كلمة المرور؟',
                                              color: AppColors.orange,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'DINNextLTArabic',
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.h,
                                                vertical: 12.h),
                                            child: ButtonWidget(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              title: 'حفظ',
                                              backgroundColor:
                                                  AppColors.scadryColor,
                                              textColor: AppColors.white,
                                              height: 45.h,
                                              verticalTextPadding: 0,
                                              horizontalTextPadding: 0,
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                              }),
                              SizedBox(
                                height: 10.h,
                              ),
                              profCard('اللغة ', () {
                                showBottomSheet(
                                    context,
                                    Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerRight,
                                            padding: EdgeInsetsDirectional.only(
                                                start: 18.w,
                                                bottom: 12.h,
                                                top: 20.h),
                                            child: CustomText(
                                              'حدد اللغة التي تريدها',
                                              color: AppColors.scadryColor,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'DINNextLTArabic',
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.w,
                                                horizontal: 16.h),
                                            child: Container(
                                              height: 48.h,
                                              alignment: Alignment.centerRight,
                                              decoration: BoxDecoration(
                                                color: AppColors.grey
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(10.w),
                                                border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(.3)),
                                              ),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                      activeColor:
                                                          AppColors.orange,
                                                      value: "العربية",
                                                      groupValue: _value,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _value = value!;
                                                        }); //selected value
                                                      }),
                                                  CustomText(
                                                    'العربية',
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily:
                                                        'DINNextLTArabic',
                                                    fontSize: 16.sp,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.w,
                                                horizontal: 16.h),
                                            child: Container(
                                              height: 48.h,
                                              decoration: BoxDecoration(
                                                color: AppColors.grey
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(10.w),
                                                border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.3)),
                                              ),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                      activeColor:
                                                          AppColors.orange,
                                                      value: "الإنجليزية",
                                                      groupValue: _value,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _value = value!;
                                                        }); //selected value
                                                      }),
                                                  CustomText(
                                                    'الإنجليزية',
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily:
                                                        'DINNextLTArabic',
                                                    fontSize: 16.sp,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.h,
                                                vertical: 12.h),
                                            child: ButtonWidget(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              title: 'حفظ',
                                              backgroundColor:
                                                  AppColors.scadryColor,
                                              textColor: AppColors.white,
                                              height: 45.h,
                                              verticalTextPadding: 0,
                                              horizontalTextPadding: 0,
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                              }),
                              SizedBox(
                                height: 150.h,
                              ),
                              RaisedGradientButton(
                                text: ' تسجيل خروج',
                                color: AppColors.scadryColor,
                                width: 340.w,
                                height: 48.h,
                                circular: 10.w,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showBottomSheet(BuildContext context, child) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.w)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.w),
                      topRight: Radius.circular(10.w)),
                ),
                height: 500.h,
                child: child),
          );
        });
      },
    );
  }

  Container dataContainer(width, data) {
    return Container(
      alignment: Alignment.centerRight,
      width: width,
      height: 48.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.w),
          color: AppColors.scadryColor.withOpacity(0.2)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: CustomText(
          data,
          textAlign: TextAlign.end,
          fontSize: 15.sp,
        ),
      ),
    );
  }

  RoundedInputField editDataContainer(width, data, controller) {
    return RoundedInputField(
      controller: controller,
      color: AppColors.grey.withOpacity(0.1),
      hintText: data,
      width: width,
      height: 48.h,
      onChanged: (value) {},
      seen: false,
      hintColor: AppColors.grey.withOpacity(0.7),
    );
  }

  GestureDetector profCard(title, onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
          width: 350.w,
          height: 48.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.w),
              color: AppColors.white),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  title,
                  color: AppColors.scadryColor,
                  fontFamily: 'DINNextLTArabic',
                ),
                IconButton(
                    onPressed: onPress,
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.scadryColor,
                    )),
              ],
            ),
          )),
    );
  }
}
