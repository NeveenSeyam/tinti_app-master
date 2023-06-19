import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinti_app/Util/constants/constants.dart';
import 'package:tinti_app/Widgets/on_boarding_content_custom.dart';
import 'package:tinti_app/Widgets/page_view_indicator.dart';
import 'package:tinti_app/provider/intro_provider%20copy.dart';
import '../../Helpers/failure.dart';
import '../../Util/constants/keys.dart';
import '../../Util/theme/app_colors.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/custom_text.dart';
import '../../Widgets/gradint_button.dart';
import '../../Widgets/loader_widget.dart';
import '../../Widgets/text_widget.dart';

class OnBoardingScreens extends ConsumerStatefulWidget {
  const OnBoardingScreens({super.key});

  @override
  _OnBoardingScreensState createState() => _OnBoardingScreensState();
}

class _OnBoardingScreensState extends ConsumerState<OnBoardingScreens> {
  Future _getIntrosData() async {
    final prov = ref.read(introProvider);

    return await prov.getIntroDataRequset();
  }

  late Future _fetchedIntroRequest;

  late PageController _pageController;
  int _currentPage = 0;
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    super.initState();
    _pageController = PageController();
    _fetchedIntroRequest = _getIntrosData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer(
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
                  child: Padding(
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
                                '${snapshot.error}' == 'No Internet connection'
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
                                  _pageController = PageController();
                                  _fetchedIntroRequest = _getIntrosData();
                                });
                              },
                            ),
                          ],
                        )),
                  ),
                );
              }
              if (snapshot.hasData) {
                if (snapshot.data is Failure) {
                  return Center(child: TextWidget(snapshot.data.toString()));
                }
                //
                //  print("snapshot data is ${snapshot.data}");

                var introsModel = ref.watch(introProvider).getDataList;

                return Column(
                  children: [
                    Expanded(
                        child: PageView(
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (int currentPage) {
                        setState(() => _currentPage = currentPage);
                      },
                      children: [
                        OnBoardingContentCustom(
                          image: introsModel?.intros?[3].image ?? 'num4',
                          title: introsModel?.intros?[3].name ?? 'num1',
                          description:
                              introsModel?.intros?[3].description ?? 'num1',
                        ),
                        OnBoardingContentCustom(
                          image: introsModel?.intros?[2].image ?? 'num3',
                          title: introsModel?.intros?[2].name ?? 'num1',
                          description:
                              introsModel?.intros?[2].description ?? 'num1',
                        ),
                        OnBoardingContentCustom(
                          image: introsModel?.intros?[1].image ?? 'num2',
                          title: introsModel?.intros?[1].name ?? 'num1',
                          description:
                              introsModel?.intros?[1].description ?? 'num1',
                        ),
                        OnBoardingContentCustom(
                          image: introsModel?.intros?[0].image ?? 'num1',
                          title: introsModel?.intros?[0].name ?? 'num1',
                          description:
                              introsModel?.intros?[0].description ?? 'num1',
                        ),
                      ],
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: _currentPage < 3,
                          maintainSize: true,
                          maintainState: true,
                          maintainAnimation: true,
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              start: 20.w,
                            ),
                            child: Row(
                              children: [
                                PageViewIndicatorCustom(
                                  isCurrentPage: _currentPage == 0,
                                  marginEnd: 4.w,
                                ),
                                PageViewIndicatorCustom(
                                  isCurrentPage: _currentPage == 1,
                                  marginEnd: 4.w,
                                ),
                                PageViewIndicatorCustom(
                                  isCurrentPage: _currentPage == 2,
                                ),
                                PageViewIndicatorCustom(
                                  isCurrentPage: _currentPage == 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        Visibility(
                          visible: _currentPage < 3,
                          maintainSize: true,
                          maintainState: true,
                          maintainAnimation: true,
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              end: 20.w,
                            ),
                            child: CustomButton(
                                width: 42,
                                height: 42,
                                backgroundColor: const Color(0xffFF7A18),
                                childWidget: const Icon(Icons.arrow_forward),
                                shape: const CircleBorder(),
                                onpressed: () {
                                  _pageController.nextPage(
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeInOutBack,
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _currentPage == 3,
                      maintainSize: true,
                      maintainState: true,
                      maintainAnimation: true,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 79.5.w),
                        child: ElevatedButton(
                          onPressed: () async {
                            SharedPreferences? _prefs =
                                await SharedPreferences.getInstance();

                            if (_prefs.getString(Keys.hasSaveUserData) ==
                                null) {
                              Constants.isQuest = true;
                            } else {
                              Constants.isQuest = false;
                            }

                            Navigator.pushReplacementNamed(
                                context, '/navegaitor_screen');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffF57A38),
                            minimumSize: Size(
                              216.w,
                              42.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Spacer(),
                              Text(
                                'Start'.tr(),
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontFamily: 'DINNEXTLTARABIC',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.arrow_forward),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 96.h,
                    )
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
