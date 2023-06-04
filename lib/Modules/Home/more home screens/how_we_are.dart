import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:tinti_app/Widgets/custom_appbar.dart';
import 'package:tinti_app/provider/app_data_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../Helpers/failure.dart';
import '../../../Util/constants/constants.dart';
import '../../../Util/theme/app_colors.dart';
import '../../../Widgets/custom_text.dart';
import '../../../Widgets/custom_text_field.dart';
import '../../../Widgets/gradint_button.dart';
import '../../../Widgets/loader_widget.dart';
import '../../../Widgets/text_widget.dart';

class HowWeAreScreen extends ConsumerStatefulWidget {
  const HowWeAreScreen({super.key});

  @override
  _HowWeAreScreenScreenState createState() => _HowWeAreScreenScreenState();
}

final GlobalKey<FormState> _key = GlobalKey<FormState>();

class _HowWeAreScreenScreenState extends ConsumerState<HowWeAreScreen> {
  final TextEditingController _emailController = TextEditingController();
  Future _getIntrosData() async {
    final prov = ref.read(appDataProvider);

    return await prov.getAppDataRequset();
  }

  late Future _fetchedIntroRequest;

  @override
  void initState() {
    super.initState();
    _fetchedIntroRequest = _getIntrosData();
  }

  var logo = Constants.blackLogo;

  @override
  Widget build(BuildContext context) {
    return
        //   MaterialApp(
        //     debugShowCheckedModeBanner: false,
        //     home: WebviewScaffold(
        //       url: 'https://sayyarte.com/web/page/who%20we%20are',
        //       // javascriptChannels: jsChannels,
        //       mediaPlaybackRequiresUserGesture: false,
        //       appBar: CustomAppBar(
        //         'من نحن',
        //         isHome: false,
        //         isNotification: false,
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

        Scaffold(
      backgroundColor: AppColors.scadryColor,
      body: Container(
        width: double.infinity,
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
                          'aboutus'.tr(),
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
                  future: _fetchedIntroRequest,
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
                        return Center(
                            child: TextWidget(snapshot.data.toString()));
                      }
                      //
                      //  print("snapshot data is ${snapshot.data}");

                      var appDataModel = ref.watch(appDataProvider).getDataList;

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
                          height: 730.h,
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
                                  logo!,
                                  width: 200.w,
                                  height: 100.h,
                                )),
                                Container(
                                  width: double.infinity,
                                  height: 550.h,
                                  child: ListView(
                                    children: [
                                      CustomText(
                                        appDataModel?.intros?[1].description ??
                                            'aboutus'.tr(),
                                        textAlign: TextAlign.center,
                                        fontFamily: 'DINNEXTLTARABIC',
                                        color: AppColors.grey,
                                      ),
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
    );
  }
}
