import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:tinti_app/provider/app_data_provider.dart';
import 'package:tinti_app/provider/contact_data_provider.dart';
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

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: WebviewScaffold(
  //       url: 'https://sayyarte.com/web/contactUs',
  //       // javascriptChannels: jsChannels,
  //       mediaPlaybackRequiresUserGesture: false,
  //       appBar: CustomAppBar(
  //         'تواصل معنا',
  //         isHome: true,
  //       ),
  //       withZoom: true,
  //       withLocalStorage: true,
  //       hidden: true,
  //       initialChild: Container(
  //         color: Colors.white,
  //         child: const Center(
  //           child: Text('.... جاري تحميل البيانات.'),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
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
                              ' تواصل معنا ',
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                            return Center(
                                child: TextWidget(snapshot.data.toString()));
                          }
                          //
                          //  print("snapshot data is ${snapshot.data}");

                          var appContactDataModel =
                              ref.watch(contactDataProvider).getContactDataList;

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
                                    Center(
                                        child: Image.asset(
                                            'assets/images/logol.png')),
                                    Container(
                                      width: double.infinity,
                                      height: 600.h,
                                      child: Column(
                                        children: [
                                          profCard(
                                              'العنوان',
                                              appContactDataModel
                                                      ?.info?.first.address ??
                                                  '',
                                              () {}),
                                          profCard(
                                              'البريد الالكتروني',
                                              appContactDataModel
                                                      ?.info?.first.email ??
                                                  '', () {
                                            _launchURL(appContactDataModel
                                                ?.info?.first.email);
                                          }),
                                          profCard(
                                              'رقم الهاتف',
                                              appContactDataModel
                                                      ?.info?.first.mobile ??
                                                  '', () {
                                            _launchURL(appContactDataModel
                                                ?.info?.first.mobile);
                                          }),
                                          profCard(
                                              'فسبوك',
                                              appContactDataModel
                                                      ?.info?.first.facebook ??
                                                  '', () {
                                            _launchURL(appContactDataModel
                                                ?.info?.first.facebook);
                                          }),
                                          profCard(
                                              'instagram',
                                              appContactDataModel
                                                      ?.info?.first.instagram ??
                                                  '', () {
                                            _launchURL(appContactDataModel
                                                ?.info?.first.instagram);
                                          }),
                                          profCard(
                                              'تويتر',
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
                                                height: 150.h,
                                                child: Column(
                                                  children: [
                                                    const CustomText(
                                                      ' يمكنك التواصل معنا عبر اي وسيلة تواصل لتفعيل حسابك او اجراء تعديلات على الحساب \n شكرا لتعاملك معنا \nفريق سيارتي',
                                                      color: AppColors
                                                          .lightPrimaryColor,
                                                      textAlign:
                                                          TextAlign.center,
                                                      fontFamily:
                                                          'DINNEXTLTARABIC',
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        showBottomSheet(
                                                            context,
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      20.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  CustomText(
                                                                    'ادخل بيانات المراسلة',
                                                                    color: AppColors
                                                                        .lightPrimaryColor,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    fontFamily:
                                                                        'DINNEXTLTARABIC',
                                                                    fontSize:
                                                                        18.sp,
                                                                  ),
                                                                  RoundedInputField(
                                                                    hintText:
                                                                        'البريد الالكتروني',
                                                                    onChanged:
                                                                        (value) {},
                                                                    hintColor:
                                                                        AppColors
                                                                            .hint,
                                                                    color: AppColors
                                                                        .lightgrey,
                                                                    circuler:
                                                                        10.w,
                                                                    height:
                                                                        48.h,
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .email,
                                                                      color: AppColors
                                                                          .hint,
                                                                    ),
                                                                    seen: false,
                                                                    controller:
                                                                        _emailController,
                                                                  ),
                                                                  RoundedInputField(
                                                                    hintText:
                                                                        'الاسم',
                                                                    onChanged:
                                                                        (value) {},
                                                                    hintColor:
                                                                        AppColors
                                                                            .hint,
                                                                    color: AppColors
                                                                        .lightgrey,
                                                                    circuler:
                                                                        10.w,
                                                                    height:
                                                                        48.h,
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .email,
                                                                      color: AppColors
                                                                          .hint,
                                                                    ),
                                                                    seen: false,
                                                                    controller:
                                                                        _addriesController,
                                                                  ),
                                                                  RoundedInputField(
                                                                    hintText:
                                                                        'العنوان',
                                                                    onChanged:
                                                                        (value) {},
                                                                    hintColor:
                                                                        AppColors
                                                                            .hint,
                                                                    color: AppColors
                                                                        .lightgrey,
                                                                    circuler:
                                                                        10.w,
                                                                    height:
                                                                        48.h,
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .email,
                                                                      color: AppColors
                                                                          .hint,
                                                                    ),
                                                                    seen: false,
                                                                    controller:
                                                                        _addriesController,
                                                                  ),
                                                                  RoundedInputField(
                                                                    linght: 8,
                                                                    hintText:
                                                                        'نص الرسالة',
                                                                    onChanged:
                                                                        (value) {},
                                                                    hintColor:
                                                                        AppColors
                                                                            .hint,
                                                                    color: AppColors
                                                                        .lightgrey,
                                                                    circuler:
                                                                        10.w,
                                                                    height:
                                                                        48.h,
                                                                    seen: false,
                                                                    controller:
                                                                        _textEditingController,
                                                                  ),
                                                                  ButtonWidget(
                                                                    backgroundColor:
                                                                        AppColors
                                                                            .scadryColor,
                                                                    onPressed:
                                                                        () {},
                                                                    title:
                                                                        'ارسال',
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
                                                        height: 46.h,
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .scadryColor
                                                                .withOpacity(
                                                                    0.8),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.w)),
                                                        child: Center(
                                                          child: CustomText(
                                                            'تواصل معنا',
                                                            color:
                                                                AppColors.white,
                                                            textAlign: TextAlign
                                                                .center,
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
      )),
    );
  }

  GestureDetector profCard(title, data, onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            width: 380.w,
            height: 40.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.w),
                color: AppColors.scadryColor.withOpacity(0.7)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 150.w,
                    child: CustomText(
                      title,
                      color: AppColors.white,
                      fontFamily: 'DINNextLTArabic',
                    ),
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
