import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:tinti_app/Util/constants/constants.dart';
import 'package:tinti_app/helpers/ui_helper.dart';
import 'package:tinti_app/provider/app_data_provider.dart';
import 'package:tinti_app/provider/contact_data_provider.dart';
import 'package:tinti_app/provider/contact_us_prov.dart.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Helpers/failure.dart';
import '../../../Util/theme/app_colors.dart';
import '../../../Widgets/button_widget.dart';
import '../../../Widgets/custom_appbar.dart';
import '../../../Widgets/custom_text.dart';
import '../../../Widgets/custom_text_field.dart';
import '../../../Widgets/gradint_button.dart';
import '../../../Widgets/loader_widget.dart';
import '../../../Widgets/text_widget.dart';

class ContactUsScreen extends ConsumerStatefulWidget {
  const ContactUsScreen({super.key});

  @override
  _ContactUsScreenScreenState createState() => _ContactUsScreenScreenState();
}

class _ContactUsScreenScreenState extends ConsumerState<ContactUsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addriesController = TextEditingController();
  final TextEditingController _textEditingController = TextEditingController();

  Future _getContactsData() async {
    final prov = ref.read(contactDataProvider);

    return await prov.getContactDataRequset();
  }

  late Future _fetchedContactRequest;

  void _launchURL(url) async {
    // const url = 'https://www.example.com';
    if (await canLaunch(url)) {
      await launch(url);
      print('تمت');
    } else {
      throw 'Could not launch $url';
      print('فشل');
    }
  }

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
    //     overlays: [SystemUiOverlay.bottom]);
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    // ));
    super.initState();
    _fetchedContactRequest = _getContactsData();
  }

  Future<void> _makePhoneCall(String phoneNumber, scheme) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: scheme,
      path: phoneNumber,
    );
    print("$launchUri");
    await launch(launchUri.toString());
  }

  Future<void> _makePhoneEmailCall(String phoneNumber, scheme) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: scheme,
      path: phoneNumber,
    );
    print("$launchUri");
    await launch(launchUri.toString());
  }

  var logo = Constants.blackLogo;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.scadryColor,
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.h),
                  child: Container(
                    alignment: Alignment.topCenter,
                    width: double.infinity,
                    height: 80.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Center(
                                child: Icon(
                              Icons.arrow_back_ios_rounded,
                              color: AppColors.white,
                            )),
                          ),
                        ),
                        Center(
                          child: CustomText(
                            'contactus'.tr(),
                            textAlign: TextAlign.start,
                            fontSize: 18.sp,
                            fontFamily: 'DINNEXTLTARABIC',
                            fontWeight: FontWeight.w400,
                            color: AppColors.white,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Center(),
                        ),
                      ],
                    ),
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) => FutureBuilder(
                    future: _fetchedContactRequest,
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
                                        _fetchedContactRequest =
                                            _getContactsData();
                                      });
                                    },
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

                        var appContactDataModel =
                            ref.watch(contactDataProvider).getContactDataList;
                        var appContactUsDataModel =
                            ref.watch(contactUsProvider);

                        return Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 47, 47, 47)
                                        .withOpacity(0.5),
                                    spreadRadius: 4,
                                    blurRadius: 10,
                                    offset: const Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ],
                                color: AppColors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(35.w),
                                  topRight: Radius.circular(35.w),
                                )),
                            height: 760.h,
                            width: double.infinity,
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.all(20.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Center(
                                        child: Image.asset(
                                      logo!,
                                      width: 200.w,
                                      height: 100.h,
                                    )),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 600.h,
                                    child: Column(
                                      children: [
                                        profCard(
                                            'title'.tr(),
                                            appContactDataModel
                                                    ?.info?.first.address ??
                                                '',
                                            () {}),
                                        profCard(
                                            'email'.tr(),
                                            appContactDataModel
                                                    ?.info?.first.email ??
                                                '', () {
                                          _makePhoneCall(
                                              appContactDataModel
                                                      ?.info?.first.email ??
                                                  '***********',
                                              'mailto');
                                        }),
                                        profCard(
                                            'mobile'.tr(),
                                            appContactDataModel
                                                    ?.info?.first.mobile ??
                                                '', () {
                                          _makePhoneCall(
                                              appContactDataModel
                                                      ?.info?.first.mobile ??
                                                  '00000',
                                              'tel');
                                        }),
                                        profCard(
                                            'feacbook'.tr(),
                                            appContactDataModel
                                                    ?.info?.first.facebook ??
                                                '', () {
                                          _launchURL(appContactDataModel
                                              ?.info?.first.facebook);
                                        }),
                                        profCard(
                                            'instagram'.tr(),
                                            appContactDataModel
                                                    ?.info?.first.instagram ??
                                                '', () {
                                          _launchURL(appContactDataModel
                                              ?.info?.first.instagram);
                                        }),
                                        profCard(
                                            'twetter'.tr(),
                                            appContactDataModel
                                                    ?.info?.first.twitter ??
                                                '', () {
                                          _launchURL(appContactDataModel
                                              ?.info?.first.twitter);
                                        }),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.orange
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.w)),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w,
                                                vertical: 20.h),
                                            child: Container(
                                              height: 130.h,
                                              child: Column(
                                                children: [
                                                  CustomText(
                                                    'contact-details'.tr(),
                                                    color: AppColors
                                                        .lightPrimaryColor,
                                                    textAlign: TextAlign.center,
                                                    fontFamily:
                                                        'DINNEXTLTARABIC',
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _emailController.text =
                                                          "";
                                                      _addriesController.text =
                                                          "";
                                                      _nameController.text = '';
                                                      _textEditingController
                                                          .text = '';
                                                      showBottomSheet(
                                                          context,
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(20.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CustomText(
                                                                  'email-header'
                                                                      .tr(),
                                                                  color: AppColors
                                                                      .lightPrimaryColor,
                                                                  fontFamily:
                                                                      'DINNEXTLTARABIC',
                                                                  fontSize:
                                                                      18.sp,
                                                                ),
                                                                RoundedInputField(
                                                                  hintText:
                                                                      'email'
                                                                          .tr(),
                                                                  onChanged:
                                                                      (value) {},
                                                                  hintColor:
                                                                      AppColors
                                                                          .hint,
                                                                  color: AppColors
                                                                      .lightgrey,
                                                                  circuler:
                                                                      10.w,
                                                                  height: 48.h,
                                                                  icon:
                                                                      const Icon(
                                                                    Icons.email,
                                                                    color:
                                                                        AppColors
                                                                            .hint,
                                                                  ),
                                                                  seen: false,
                                                                  controller:
                                                                      _emailController,
                                                                ),
                                                                RoundedInputField(
                                                                  hintText:
                                                                      'name'
                                                                          .tr(),
                                                                  onChanged:
                                                                      (value) {},
                                                                  hintColor:
                                                                      AppColors
                                                                          .hint,
                                                                  color: AppColors
                                                                      .lightgrey,
                                                                  circuler:
                                                                      10.w,
                                                                  height: 48.h,
                                                                  icon:
                                                                      const Icon(
                                                                    Icons.email,
                                                                    color:
                                                                        AppColors
                                                                            .hint,
                                                                  ),
                                                                  seen: false,
                                                                  controller:
                                                                      _nameController,
                                                                ),
                                                                RoundedInputField(
                                                                  hintText:
                                                                      'address'
                                                                          .tr(),
                                                                  onChanged:
                                                                      (value) {},
                                                                  hintColor:
                                                                      AppColors
                                                                          .hint,
                                                                  color: AppColors
                                                                      .lightgrey,
                                                                  circuler:
                                                                      10.w,
                                                                  height: 48.h,
                                                                  icon:
                                                                      const Icon(
                                                                    Icons.email,
                                                                    color:
                                                                        AppColors
                                                                            .hint,
                                                                  ),
                                                                  seen: false,
                                                                  controller:
                                                                      _addriesController,
                                                                ),
                                                                RoundedInputField(
                                                                  linght: 5,
                                                                  hintText:
                                                                      'msg'
                                                                          .tr(),
                                                                  onChanged:
                                                                      (value) {},
                                                                  hintColor:
                                                                      AppColors
                                                                          .hint,
                                                                  color: AppColors
                                                                      .lightgrey,
                                                                  circuler:
                                                                      10.w,
                                                                  height: 48.h,
                                                                  seen: false,
                                                                  controller:
                                                                      _textEditingController,
                                                                ),
                                                                SizedBox(
                                                                  height: 10.h,
                                                                ),
                                                                ButtonWidget(
                                                                  backgroundColor:
                                                                      AppColors
                                                                          .scadryColor,
                                                                  onPressed:
                                                                      () async {
                                                                    await appContactUsDataModel.postCountact(
                                                                        email: _emailController
                                                                            .text,
                                                                        name: _nameController
                                                                            .text,
                                                                        address:
                                                                            _addriesController
                                                                                .text,
                                                                        text: _textEditingController
                                                                            .text);
                                                                    UIHelper.showNotification(
                                                                        'send msg'
                                                                            .tr(),
                                                                        backgroundColor:
                                                                            Colors.green);

                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  title: 'send'
                                                                      .tr(),
                                                                  textColor:
                                                                      AppColors
                                                                          .white,
                                                                )
                                                              ],
                                                            ),
                                                          ));
                                                    },
                                                    child: Container(
                                                      width: 280.w,
                                                      height: 40.h,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .scadryColor
                                                              .withOpacity(0.8),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.w)),
                                                      child: Center(
                                                        child: CustomText(
                                                          'contactus'.tr(),
                                                          color:
                                                              AppColors.white,
                                                          textAlign:
                                                              TextAlign.center,
                                                          fontFamily:
                                                              'DINNEXTLTARABIC',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ));
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  GestureDetector profCard(title, data, onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            width: 380.w,
            height: 45.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.w),
                color: AppColors.scadryColor.withOpacity(0.7)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 150.w,
                      child: CustomText(
                        title,
                        color: AppColors.white,
                        fontFamily: 'DINNextLTArabic',
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    // Container(
                    //   width: 180.w,
                    //   child: CustomText(
                    //     data ?? '',
                    //     textAlign: TextAlign.end,
                    //     color: AppColors.white,
                    //     fontSize: 14.sp,
                    //     fontFamily: 'DINNextLTArabic',
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Center(
                        child: SizedBox(
                          width: 5.w,
                          child: IconButton(
                              onPressed: onPress,
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.white,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
}
