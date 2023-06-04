import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/custom_appbar.dart';
import 'package:tinti_app/Widgets/custom_text.dart';
import 'package:tinti_app/provider/notifications_provider.dart';

import '../../../Helpers/failure.dart';
import '../../../Widgets/gradint_button.dart';
import '../../../Widgets/loader_widget.dart';
import '../../../Widgets/text_widget.dart';
import '../more home screens/contact_us.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  Future _getNotificationsData() async {
    final prov = ref.read(notificationProvider);

    return await prov.getNotificationsDataRequset();
  }

  late Future _fetchedNotificationRequest;

  @override
  void initState() {
    _fetchedNotificationRequest = _getNotificationsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isProfile: false,
        'notification'.tr(),
        isHome: true,
        isNotification: true,
      ),
      body: Container(
        width: double.infinity,
        child: Consumer(
          builder: (context, ref, child) => FutureBuilder(
            future: _fetchedNotificationRequest,
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
                              'contact support'.tr(),
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
                            text: 'contactus'.tr(),
                            color: AppColors.scadryColor,
                            height: 48.h,
                            width: 320.w,
                            circular: 10.w,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContactUsScreen()),
                              );
                            },
                          ),
                        ],
                      )),
                );
              }
              if (snapshot.hasData) {
                if (snapshot.data is Failure) {
                  return Center(child: TextWidget(snapshot.data.toString()));
                }
                //
                //  print("snapshot data is ${snapshot.data}");

                var notificationsModel =
                    ref.watch(notificationProvider).getDataList;

                return notificationsModel?.notifications?.length != 0
                    ? ListView.builder(
                        itemCount: notificationsModel?.notifications?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return notificationCard(
                              notificationsModel?.notifications?[index]
                                      .notificationText ??
                                  'تم الانتهاء من تركيب نانو سيراميك السيارة ,يمكنك استلامها الان',
                              notificationsModel?.notifications?[0].date ??
                                  'قبل 22د',
                              true);
                        },
                      )
                    : Padding(
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
                              color: AppColors.white.withOpacity(0.8),
                            ),
                            width: 320.w,
                            height: 500.h,
                            child: Column(
                              children: [
                                Image.asset('assets/images/nullstate.png'),
                                SizedBox(
                                  height: 20.h,
                                ),
                                SizedBox(
                                  width: 300.w,
                                  child: CustomText(
                                    'dont add any'.tr(),
                                    color: AppColors.orange,
                                    textAlign: TextAlign.center,
                                    fontFamily: 'DINNEXTLTARABIC',
                                    fontSize: 18.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 60.h,
                                ),
                                RaisedGradientButton(
                                  text: 'new'.tr(),
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
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Card notificationCard(data, time, isNew) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300.w,
                  child: CustomText(
                    data,
                    fontFamily: 'DINNEXTLTARABIC',
                    color: AppColors.scadryColor,
                    textAlign: TextAlign.start,
                  ),
                ),
                CustomText(
                  time,
                  fontSize: 10.sp,
                  fontFamily: 'DINNEXTLTARABIC',
                  color: AppColors.grey.withOpacity(0.5),
                  textAlign: TextAlign.start,
                )
              ],
            ),
            // Container(
            //   width: 20.w,
            //   height: 20.h,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(20.w),
            //     color: isNew == true
            //         ? AppColors.green
            //         : AppColors.grey.withOpacity(0.3),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
