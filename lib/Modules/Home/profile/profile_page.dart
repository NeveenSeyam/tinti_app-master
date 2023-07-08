import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinti_app/Models/auth/profile_model.dart';
import 'package:tinti_app/Modules/Home/more%20home%20screens/contact_us.dart';
import 'package:tinti_app/Modules/auth/first_forget_screen.dart';
import 'package:tinti_app/Util/constants/constants.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/button_widget.dart';
import 'package:tinti_app/Widgets/custom_text.dart';
import 'package:tinti_app/provider/account_provider.dart';

import '../../../Helpers/failure.dart';
import '../../../Widgets/custom_appbar.dart';
import '../../../Widgets/custom_text_field.dart';
import '../../../Widgets/gradint_button.dart';
import '../../../Widgets/loader_widget.dart';
import '../../../Widgets/loading_dialog.dart';
import '../../../helpers/ui_helper.dart';
import '../../auth/login_screen.dart';

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

  TextEditingController _oldPassController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPassController = TextEditingController();

  File? img;

  final _appBartitle = StateProvider.autoDispose<String>(
      (ref) => Constants.lang == 'en' ? "Profile" : "حسابي");
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _fetchedMyRequest = _getContentData();

    super.initState();
    _pageController = PageController();
  }

  RegExp pass_valid = RegExp(r"(?=.*[a-z])(?=.*[A-Z])");

  bool validatePassword(String pass) {
    String _password = pass.trim();
    if (pass_valid.hasMatch(_password) && pass.length > 6) {
      return true;
    } else {
      return false;
    }
  }

  bool validateConfirmPassword(String pass) {
    String _password = pass.trim();
    if (_confirmNewPassController.text == _newPasswordController.text) {
      return true;
    } else {
      return false;
    }
  }

  final _Key = GlobalKey<FormState>();

  Future<void> saveLang() async {
    SharedPreferences? _prefs = await SharedPreferences.getInstance();
    _prefs.setString("lang", Constants.lang!);
    ref.watch(_appBartitle.state).state =
        Constants.lang == 'en' ? "Profile" : "حسابي";
    setState() {}
    ;
  }

  @override
  Widget build(BuildContext context) {
    String _value = Constants.lang == 'en' ? 'english'.tr() : 'arabic'.tr();
    String pageName = 'Profile'.tr();
    return Scaffold(
      appBar: CustomAppBar(
        isProfile: true,
        ref.watch(_appBartitle.state).state,
        isHome: false,
        isNotification: false,
      ),
      body: Container(
        width: double.infinity,
        child: Constants.isQuest == false
            ? Consumer(
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
                            // width: 320.w,
                            height: 500.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/nullstate.png'),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Container(
                                  width: 300.w,
                                  child: CustomText(
                                    '${snapshot.error}' ==
                                            'No Internet connection'
                                        ? Constants.lang == 'ar'
                                            ? 'انت غير متصل بالانترنت حاول مرة اخرى'
                                            : 'You don\'t connect with internet try again'
                                        : 'contact support'.tr(),
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
                                  text: Constants.lang == 'ar'
                                      ? ' حاول مرة اخرى'
                                      : ' try again',
                                  color: AppColors.scadryColor,
                                  height: 48.h,
                                  width: 320.w,
                                  circular: 10.w,
                                  onPressed: () {
                                    setState(() {
                                      _fetchedMyRequest = _getContentData();
                                    });
                                  },
                                ),
                              ],
                            )),
                      );
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data is Failure) {
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
                              // width: 320.w,
                              height: 500.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/nullstate.png'),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Container(
                                    width: 300.w,
                                    child: CustomText(
                                      '${snapshot.error}' ==
                                              'No Internet connection'
                                          ? Constants.lang == 'ar'
                                              ? 'انت غير متصل بالانترنت حاول مرة اخرى'
                                              : 'You don\'t connect with internet try again'
                                          : 'contact support'.tr(),
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
                                    text: Constants.lang == 'ar'
                                        ? ' حاول مرة اخرى'
                                        : ' try again',
                                    color: AppColors.scadryColor,
                                    height: 48.h,
                                    width: 320.w,
                                    circular: 10.w,
                                    onPressed: () {
                                      setState(() {
                                        _fetchedMyRequest = _getContentData();
                                      });
                                    },
                                  ),
                                ],
                              )),
                        );

                        // Center(
                        //   // child: Text('Error: ${snapshot.error}'),

                        // );
                      }

                      var serviceModel =
                          ref.watch(accountProvider).getProfileModel ??
                              ProfileModel();
                      _addressController.text =
                          serviceModel.user?.address ?? '';
                      _lnameController.text = serviceModel.user?.lname ?? '';
                      _fnameController.text = serviceModel.user?.fname ?? '';
                      _emailController.text = serviceModel.user?.email ?? '';
                      _numberController.text = serviceModel.user?.mobile ?? '';

                      var profileModel = ref.watch(accountProvider);
                      var changPassModel = ref.watch(accountProvider);
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
                                        GestureDetector(
                                          onTap: () async {
                                            showModalBottomSheet<void>(
                                              context: context,
                                              isScrollControlled: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            25.w)),
                                              ),
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(builder:
                                                    (BuildContext context,
                                                        StateSetter
                                                            setState /*You can rename this!*/) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10.w),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10.w)),
                                                      ),
                                                      height: 500.h,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          GestureDetector(
                                                            onTap: () async {
                                                              await _getImageData();
                                                              setState(() {});
                                                              // final picker = ImagePicker();
                                                              // final pickedFile =
                                                              //     await picker.getImage(
                                                              //         source: ImageSource
                                                              //             .gallery);

                                                              // setState() {
                                                              //   img =
                                                              //       File(pickedFile!.path);
                                                              // }
                                                            },
                                                            child: img == null
                                                                ? Padding(
                                                                    padding: EdgeInsets
                                                                        .all(20
                                                                            .w),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Container(
                                                                        color: AppColors
                                                                            .grey
                                                                            .withOpacity(0.3),
                                                                        width:
                                                                            350.w,
                                                                        height:
                                                                            250.h,
                                                                        child: Icon(
                                                                            Icons.add_a_photo_outlined),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Center(
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets
                                                                          .all(20
                                                                              .w),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            250.h,
                                                                        width:
                                                                            350.w,
                                                                        child: Image
                                                                            .file(
                                                                          img ??
                                                                              File('path'),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        16.h),
                                                            child: ButtonWidget(
                                                              onPressed:
                                                                  () async {
                                                                loadingDialog(
                                                                    context);

                                                                await profileModel
                                                                    .editUserImageRequset(
                                                                        data: {},
                                                                        file:
                                                                            img).onError(
                                                                        (error,
                                                                            stackTrace) {
                                                                  Navigator.of(
                                                                          context,
                                                                          rootNavigator:
                                                                              true)
                                                                      .pop();
                                                                });
                                                                await _getContentData();
                                                                this.setState(
                                                                    () {
                                                                  pageName =
                                                                      'Profile'
                                                                          .tr();
                                                                });
                                                                Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .pop();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              title:
                                                                  'save'.tr(),
                                                              backgroundColor:
                                                                  AppColors
                                                                      .scadryColor,
                                                              textColor:
                                                                  AppColors
                                                                      .white,
                                                              height: 45.h,
                                                              verticalTextPadding:
                                                                  0,
                                                              horizontalTextPadding:
                                                                  0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                              },
                                            );
                                          },
                                          child: SizedBox(
                                            width: 85.w,
                                            height: 85.h,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.w),
                                              child: CachedNetworkImage(
                                                width: 85.w,
                                                height: 85.w,
                                                imageUrl: serviceModel
                                                        .user?.img ??
                                                    'https://www.sayyarte.com/img/1678171026.png',
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Image.network(
                                                  'https://www.sayyarte.com/img/1678171026.png',
                                                  width: 85.w,
                                                  height: 85.w,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),

                                              //  Image.network(
                                              //   '${serviceModel.user?.img ?? 'https://www.sayyarte.com/img/1678171026.png'}',
                                              //   fit: BoxFit.cover,
                                              //   width: 85.w,
                                              //   height: 85.w,
                                              // ),
                                            ),
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
                                  profCard('my-data'.tr(), () {
                                    showBottomSheet(
                                      context,
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.w),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    EdgeInsetsDirectional.only(
                                                        start: 20.w,
                                                        bottom: 12.h,
                                                        top: 20.h),
                                                child: CustomText(
                                                  'my-data'.tr(),
                                                  color: AppColors.scadryColor,
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily: 'DINNextLTArabic',
                                                  fontSize: 18.sp,
                                                ),
                                              ),
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    dataContainer(
                                                        170.w,
                                                        serviceModel
                                                                .user?.fname ??
                                                            ''),
                                                    SizedBox(
                                                      width: 15.w,
                                                    ),
                                                    dataContainer(
                                                        170.w,
                                                        serviceModel
                                                                .user?.lname ??
                                                            ''),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 12.h,
                                              ),
                                              Center(
                                                child: dataContainer(
                                                    355.w,
                                                    serviceModel.user?.email ??
                                                        ''),
                                              ),
                                              SizedBox(
                                                height: 12.h,
                                              ),
                                              Center(
                                                child: dataContainer(
                                                    355.w,
                                                    serviceModel.user?.mobile ??
                                                        ''),
                                              ),
                                              SizedBox(
                                                height: 12.h,
                                              ),
                                              Center(
                                                child: dataContainer(
                                                    355.w,
                                                    serviceModel
                                                            .user?.address ??
                                                        'enter contry'.tr()),
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
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.w),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          10.w),
                                                              child: Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .only(
                                                                        end: 20
                                                                            .w,
                                                                        top: 20
                                                                            .h),
                                                                child:
                                                                    CustomText(
                                                                  'my-data-update'
                                                                      .tr(),
                                                                  color: AppColors
                                                                      .scadryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontFamily:
                                                                      'DINNextLTArabic',
                                                                  fontSize:
                                                                      18.sp,
                                                                ),
                                                              ),
                                                            ),
                                                            Center(
                                                              child: Container(
                                                                width: 350.w,
                                                                height: 45.h,
                                                                decoration: BoxDecoration(
                                                                    color: AppColors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.1),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.w)),
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(10
                                                                              .w),
                                                                  child:
                                                                      CustomText(
                                                                    serviceModel
                                                                            .user
                                                                            ?.email ??
                                                                        'example@example.com',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                            Center(
                                                              child: Container(
                                                                width: 350.w,
                                                                height: 45.h,
                                                                decoration: BoxDecoration(
                                                                    color: AppColors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.1),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.w)),
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(10
                                                                              .w),
                                                                  child:
                                                                      CustomText(
                                                                    serviceModel
                                                                            .user
                                                                            ?.mobile ??
                                                                        '',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                editDataContainer(
                                                                    170.w,
                                                                    serviceModel
                                                                            .user
                                                                            ?.fname ??
                                                                        '',
                                                                    _fnameController),
                                                                SizedBox(
                                                                  width: 15.w,
                                                                ),
                                                                editDataContainer(
                                                                    170.w,
                                                                    serviceModel
                                                                            .user
                                                                            ?.lname ??
                                                                        '',
                                                                    _lnameController),
                                                              ],
                                                            ),
                                                            Center(
                                                              child: editDataContainer(
                                                                  355.w,
                                                                  serviceModel
                                                                          .user
                                                                          ?.address ??
                                                                      'enter contry'
                                                                          .tr(),
                                                                  _addressController),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          16.h),
                                                              child:
                                                                  ButtonWidget(
                                                                onPressed:
                                                                    () async {
                                                                  await changPassModel
                                                                      .editUserRequset(
                                                                    data: {
                                                                      "fname":
                                                                          _fnameController
                                                                              .text,
                                                                      "lname":
                                                                          _lnameController
                                                                              .text,
                                                                      // "email":
                                                                      //     _emailController
                                                                      //         .text,
                                                                      // "phoneNumber":
                                                                      //     _numberController
                                                                      //         .text,
                                                                      "address":
                                                                          _addressController
                                                                              .text
                                                                    },
                                                                  );
                                                                  setState(() {
                                                                    _fetchedMyRequest =
                                                                        _getContentData();

                                                                    _addressController
                                                                        .text = '';
                                                                    _emailController
                                                                        .text = '';
                                                                    _fnameController
                                                                        .text = '';
                                                                    _lnameController
                                                                        .text = '';
                                                                    // _image2 = null;
                                                                    _numberController
                                                                        .text = '';
                                                                  });

                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                title:
                                                                    'save'.tr(),
                                                                backgroundColor:
                                                                    AppColors
                                                                        .scadryColor,
                                                                textColor:
                                                                    AppColors
                                                                        .white,
                                                                height: 45.h,
                                                                verticalTextPadding:
                                                                    0,
                                                                horizontalTextPadding:
                                                                    0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  title: 'my-data-update'.tr(),
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
                                      ),
                                    );
                                  }),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  profCard('change-password'.tr(), () {
                                    showBottomSheet(
                                        context,
                                        Form(
                                          key: _Key,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    EdgeInsetsDirectional.only(
                                                        start: 20.w,
                                                        bottom: 12.h,
                                                        top: 20.h),
                                                child: CustomText(
                                                  'change-password'.tr(),
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
                                                  hintText: 'old-pass'.tr(),
                                                  width: 355.w,
                                                  height: 48.h,
                                                  onChanged: (value) {},
                                                  seen: true,
                                                  icon: Icon(Icons.key),
                                                  hintColor: AppColors.grey
                                                      .withOpacity(0.7),
                                                  controller:
                                                      _oldPassController,
                                                ),
                                              ),
                                              Center(
                                                child: RoundedInputField(
                                                  color: AppColors.grey
                                                      .withOpacity(0.1),
                                                  hintText: 'new-pass'.tr(),
                                                  width: 355.w,
                                                  height: 48.h,
                                                  onChanged: (value) {},
                                                  seen: true,
                                                  icon: Icon(Icons.key),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "null verfication"
                                                          .tr();
                                                    } else {
                                                      //call function to check password
                                                      bool result =
                                                          validatePassword(
                                                              value);
                                                      if (result) {
                                                        // create account event
                                                        return null;
                                                      } else {
                                                        return "password verfication"
                                                            .tr();
                                                      }
                                                    }
                                                  },
                                                  hintColor: AppColors.grey
                                                      .withOpacity(0.7),
                                                  controller:
                                                      _newPasswordController,
                                                ),
                                              ),
                                              Center(
                                                child: RoundedInputField(
                                                  color: AppColors.grey
                                                      .withOpacity(0.1),
                                                  hintText:
                                                      'confirm-new-pass'.tr(),
                                                  width: 355.w,
                                                  height: 48.h,
                                                  onChanged: (value) {},
                                                  seen: true,
                                                  icon: Icon(Icons.key),
                                                  controller:
                                                      _confirmNewPassController,
                                                  hintColor: AppColors.grey
                                                      .withOpacity(0.7),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "null verfication"
                                                          .tr();
                                                    } else {
                                                      //call function to check password
                                                      bool result =
                                                          validatePassword(
                                                              value);
                                                      if (result) {
                                                        // create account event
                                                        return null;
                                                      } else {
                                                        return "confirm password verfication"
                                                            .tr();
                                                      }
                                                    }
                                                  },
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FirstForgetScreen()),
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 26.w),
                                                  child: CustomText(
                                                    'forget-pass'.tr(),
                                                    color: AppColors.orange,
                                                    textAlign: TextAlign.start,
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily:
                                                        'DINNextLTArabic',
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.h,
                                                    vertical: 12.h),
                                                child: ButtonWidget(
                                                  onPressed: () async {
                                                    if (_Key.currentState!
                                                        .validate()) {
                                                      _Key.currentState!.save();
                                                      await profileModel
                                                          .editProfilePasswordRequset(
                                                        data: {
                                                          "password":
                                                              _newPasswordController
                                                                  .text,
                                                          "c_password":
                                                              _confirmNewPassController
                                                                  .text,
                                                          "old_password":
                                                              _oldPassController
                                                                  .text,
                                                        },
                                                      );
                                                      setState(() {
                                                        _fetchedMyRequest =
                                                            _getContentData();
                                                      });

                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  title: 'save'.tr(),
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
                                  profCard('langouage'.tr(), () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(25.w)),
                                      ),
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter
                                                    setState /*You can rename this!*/) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10.w),
                                                          topRight:
                                                              Radius.circular(
                                                                  10.w)),
                                                ),
                                                height: 500.h,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .only(
                                                                  start: 18.w,
                                                                  bottom: 12.h,
                                                                  top: 20.h),
                                                      child: CustomText(
                                                        'select lang'.tr(),
                                                        color: AppColors
                                                            .scadryColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily:
                                                            'DINNextLTArabic',
                                                        fontSize: 18.sp,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10.w,
                                                              horizontal: 16.h),
                                                      child: Container(
                                                        height: 48.h,
                                                        alignment: Alignment
                                                            .centerRight,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors.grey
                                                              .withOpacity(0.2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.w),
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      .3)),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Radio(
                                                                activeColor:
                                                                    AppColors
                                                                        .orange,
                                                                value: 'arabic'
                                                                    .tr(),
                                                                groupValue:
                                                                    _value,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    _value =
                                                                        value!;
                                                                    Constants
                                                                            .lang =
                                                                        'ar';
                                                                  }); //selected value
                                                                }),
                                                            CustomText(
                                                              'arabic'.tr(),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              fontFamily:
                                                                  'DINNextLTArabic',
                                                              fontSize: 16.sp,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10.w,
                                                              horizontal: 16.h),
                                                      child: Container(
                                                        height: 48.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors.grey
                                                              .withOpacity(0.2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.w),
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.3)),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Radio(
                                                                activeColor:
                                                                    AppColors
                                                                        .orange,
                                                                value: 'english'
                                                                    .tr(),
                                                                groupValue:
                                                                    _value,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    _value =
                                                                        value!;
                                                                    Constants
                                                                            .lang =
                                                                        'en';
                                                                  }); //selected value
                                                                }),
                                                            CustomText(
                                                              'english'.tr(),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              fontFamily:
                                                                  'DINNextLTArabic',
                                                              fontSize: 16.sp,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 16.h,
                                                              vertical: 12.h),
                                                      child: ButtonWidget(
                                                        onPressed: () async {
                                                          _value = Constants
                                                                      .lang ==
                                                                  'en'
                                                              ? 'english'.tr()
                                                              : 'arabic'.tr();
                                                          await saveLang();
                                                          Constants.lang == 'en'
                                                              ? context
                                                                  .setLocale(
                                                                      Locale(
                                                                          'en',
                                                                          'US'))
                                                              : context
                                                                  .setLocale(
                                                                      Locale(
                                                                          'ar',
                                                                          'DZ'));
                                                          if (Constants.lang ==
                                                              'ar') {
                                                            Constants.logo =
                                                                "assets/images/logol2.png";
                                                            Constants
                                                                    .blackLogo =
                                                                "assets/images/blacklogo.png";
                                                          } else {
                                                            Constants.logo =
                                                                "assets/images/logol.png";
                                                            Constants
                                                                    .blackLogo =
                                                                "assets/images/bllo.png";
                                                          }

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        title: 'save'.tr(),
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
                                                )),
                                          );
                                        });
                                      },
                                    );
                                  }),
                                  SizedBox(
                                    height: 150.h,
                                  ),
                                  RaisedGradientButton(
                                    text: 'logout'.tr(),
                                    color: AppColors.scadryColor,
                                    width: 340.w,
                                    height: 48.h,
                                    circular: 10.w,
                                    onPressed: () async {
                                      Constants.token = null;
                                      Constants.isQuest = true;
                                      SharedPreferences? _prefs =
                                          await SharedPreferences.getInstance();
                                      _prefs.clear();
                                      Navigator.popAndPushNamed(
                                          context, '/login_screen');
                                    },
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
              )
            : Container(
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
                        'need login'.tr(),
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
                      text: 'login'.tr(),
                      color: AppColors.scadryColor,
                      height: 48.h,
                      width: 320.w,
                      circular: 10.w,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                    ),
                  ],
                )),
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
