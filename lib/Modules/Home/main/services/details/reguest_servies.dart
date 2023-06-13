import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Models/statics/cites_model.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/button_widget.dart';
import 'package:tinti_app/Widgets/custom_appbar.dart';
import 'package:tinti_app/Widgets/custom_text_field.dart';
import 'package:tinti_app/provider/car_provider.dart';
import '../../../../../Helpers/failure.dart';
import '../../../../../Models/statics/regions_model.dart';
import '../../../../../Util/constants/constants.dart';
import '../../../../../Widgets/Custom_dropDown.dart';
import '../../../../../Widgets/cash_image.dart';
import '../../../../../Widgets/custom_text.dart';
import '../../../../../Widgets/gradint_button.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

import '../../../../../Widgets/loader_widget.dart';
import '../../../../../Widgets/text_widget.dart';
import '../../../../../provider/statics_provider.dart';
import '../../../more home screens/contact_us.dart';

class RequestServieses extends ConsumerStatefulWidget {
  const RequestServieses({super.key});

  @override
  _RequestServiesesState createState() => _RequestServiesesState();
}

class _RequestServiesesState extends ConsumerState<RequestServieses> {
  bool isFav = true;
  bool isVisible1 = false;
  bool isVisible2 = false;
  String? selectedRigon;
  String? selectedCity;
  String? selectedCar;

  late Future _fetchedRegioRequest;
  late var id;
  CitesModel? citezModel;
  RegionsModel? regionsModel;
  Future _getRigonsData() async {
    final prov = ref.read(staticsProvider);
    return await prov.getRegionsDataRequset();
  }

  late Future _fetchedCitiesRequest;

  Future _getCitiesData() async {
    final prov = ref.read(staticsProvider);
    return await prov.getCtiesDataRequset(id: id);
  }

  late Future _fetchedCarsRequest;

  Future _getCarsData() async {
    final prov = ref.read(carProvider);
    return await prov.getCarDataRequset();
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _fetchedRegioRequest = _getRigonsData();

    _fetchedCitiesRequest = _getCitiesData();
    _fetchedCarsRequest = _getCarsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'request service'.tr(),
        isHome: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: ListView(
          children: [
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Container(
            //       padding:
            //           EdgeInsets.symmetric(horizontal: 20.w, vertical: 60.w),
            //       decoration: BoxDecoration(
            //           color: AppColors.orange,
            //           borderRadius: BorderRadius.circular(10.w)),
            //       child: Icon(
            //         Icons.add,
            //         color: AppColors.white,
            //         size: 40.w,
            //       ),
            //     ),
            //     Container(
            //       width: 280.w,
            //       height: 200.h,
            //       child: SizedBox(
            //         // width: 350.w,
            //         child: PageView(
            //           scrollDirection: Axis.horizontal,
            //           // controller: _pageController,
            //           physics: const BouncingScrollPhysics(),
            //           onPageChanged: (int currentPage) {
            //             // setState(() => _currentPage = currentPage);
            //           },
            //           children: const [
            //             CachImage(
            //               image: 'credit-card-1',
            //             ),
            //             CachImage(
            //               image: 'credit-card-2',
            //             ),
            //             CachImage(
            //               image: 'credit-card',
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),

            Consumer(
              builder: (context, ref, child) => FutureBuilder(
                future: _fetchedRegioRequest,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 70.h,
                      child: const Center(
                        child: LoaderWidget(),
                      ),
                    );
                  }
                  // if (snapshot.hasError) {
                  //   var regionsModel =
                  //       ref.watch(staticsProvider).getRegiosDataList;
                  //   var citiesModel =
                  //       ref.watch(staticsProvider).getCitiesDataList;
                  //   return Container(
                  //     width: 170.w,
                  //     child: CustomDropDown(
                  //       hintText: "contrey".tr(),
                  //       title: "contrey".tr(),
                  //       value: regionsModel?.regions?[0].name,
                  //       list: regionsModel?.regions
                  //           ?.map((e) => e.name.toString())
                  //           .toList(),
                  //       onChange: (p0) async {
                  //         selectedRigon = regionsModel?.regions
                  //             ?.firstWhere((element) => element.name == p0)
                  //             .id
                  //             .toString();

                  //         id = regionsModel?.regions
                  //                 ?.firstWhere((element) => element.name == p0)
                  //                 .id ??
                  //             0;
                  //         await _getCitiesData();
                  //         regionsModel =
                  //             ref.watch(staticsProvider).getRegiosDataList;
                  //         if (regionsModel?.regions?.isNotEmpty ?? false)
                  //           selectedRigon =
                  //               regionsModel?.regions?.first.name.toString() ??
                  //                   '';

                  //         setState(() {});
                  //       },
                  //     ),
                  //   );

                  //   // Center(
                  //   //   // child: Text('Error: ${snapshot.error}'),

                  //   // );
                  // }
                  if (snapshot.hasData) {
                    if (snapshot.data is Failure) {
                      return Center(
                          child: TextWidget(snapshot.data.toString()));
                    }
                    //
                    //  print("snapshot data is ${snapshot.data}");

                    var regionsModel =
                        ref.watch(staticsProvider).getRegiosDataList;
                    var citiesModel =
                        ref.watch(staticsProvider).getCitiesDataList;
                    var carsModel = ref.watch(carProvider).getDataList;
                    return Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                              width: 350.w,
                              child: CustomDropDown(
                                hintText: "contrey".tr(),
                                title: "contrey".tr(),
                                value: regionsModel?.regions?[0].name,
                                list: regionsModel?.regions
                                    ?.map((e) => e.name.toString())
                                    .toList(),
                                onChange: (p0) async {
                                  selectedRigon = regionsModel?.regions
                                      ?.firstWhere(
                                          (element) => element.name == p0)
                                      .id
                                      .toString();

                                  id = regionsModel?.regions
                                          ?.firstWhere(
                                              (element) => element.name == p0)
                                          .id ??
                                      0;
                                  await _getCitiesData();
                                  regionsModel = ref
                                      .watch(staticsProvider)
                                      .getRegiosDataList;
                                  if (citezModel?.regions?.isNotEmpty ?? false)
                                    selectedRigon = regionsModel
                                            ?.regions?.first.name
                                            .toString() ??
                                        '';

                                  final prov = ref.read(staticsProvider);
                                  //   carModelTaypesModel = CarModelTaypesModel();

                                  await prov
                                      .getCtiesDataRequset(id: id)
                                      .then((value) {
                                    //_carModelTypesList
                                  });
                                  citiesModel = ref
                                      .read(staticsProvider)
                                      .getCitiesDataList;
                                  citiesModel?.regions = ref
                                          .read(staticsProvider)
                                          .getCitiesDataList
                                          ?.regions ??
                                      [];
                                  setState(() {});

                                  // log("carModelTaypesModel?.carModles?. ${carModelTaypesModel?.carModles?.length ?? 0}");
                                },
                              )),
                          if (citiesModel?.regions?.isNotEmpty ?? false)
                            Container(
                                width: 350.w,
                                child: CustomDropDown(
                                  hintText: "city".tr(),
                                  title: "city".tr(),
                                  value: citiesModel?.regions?[0].name,
                                  list: citiesModel?.regions
                                      ?.map((e) => e.name.toString())
                                      .toList(),
                                  onChange: (p0) async {
                                    selectedRigon = citiesModel?.regions
                                        ?.firstWhere(
                                            (element) => element.name == p0)
                                        .id
                                        .toString();

                                    await _getCitiesData();
                                    citezModel = ref
                                        .watch(staticsProvider)
                                        .getCitiesDataList;
                                    if (citiesModel?.regions?.isNotEmpty ??
                                        false)
                                      selectedRigon = citiesModel
                                              ?.regions?.first.name
                                              .toString() ??
                                          '';

                                    setState(() {});
                                  },
                                )),
                          Container(
                              width: 350.w,
                              child: CustomDropDown(
                                hintText: "car".tr(),
                                title: "car".tr(),
                                value: carsModel?.carModles?[0].name,
                                list: carsModel?.carModles
                                    ?.map((e) => e.name.toString())
                                    .toList(),
                                onChange: (p0) async {
                                  selectedCar = carsModel?.carModles
                                      ?.firstWhere(
                                          (element) => element.name == p0)
                                      .id
                                      .toString();

                                  await _getCarsData();

                                  setState(() {});
                                },
                              )),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'نانو سيراميك',
                      color: AppColors.scadryColor,
                      fontSize: 18.sp,
                      fontFamily: 'DINNextLTArabic',
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      'جونسون اند جونسون ',
                      color: AppColors.orange,
                      fontSize: 14.sp,
                      fontFamily: 'DINNextLTArabic',
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      child: isFav == true
                          ? Icon(
                              Icons.star_rate_rounded,
                              color: AppColors.orange,
                              size: 32.w,
                            )
                          : Icon(
                              Icons.star_rate_rounded,
                              color: AppColors.orange,
                              size: 32.w,
                            ),
                      onTap: () {
                        setState(() {
                          isFav == true ? isFav = false : isFav = true;
                        });
                      },
                    ),
                    CustomText(
                      ' 4.2  ',
                      color: AppColors.scadryColor,
                      fontSize: 18.sp,
                      fontFamily: 'DINNextLTArabic',
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              height: 500.h,
              child: ListView(
                children: [
                  isVisible1 == false
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RaisedGradientButton(
                              color: AppColors.scadryColor,
                              textColor: AppColors.white,
                              onPressed: () {
                                setState(() {
                                  isVisible1 = true;
                                });
                              },
                              text: 'تنفيذ',
                              circular: 10.w,
                              width: 280.w,
                            ),
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.w),
                                color: AppColors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 185, 184, 184)
                                        .withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: CustomText(
                                ' 100 \$',
                                color: AppColors.orange,
                                fontSize: 18.sp,
                                fontFamily: 'DINNextLTArabic',
                                textAlign: TextAlign.start,
                              ),
                            )
                          ],
                        )
                      : MyFatoorah(
                          onResult: (response) {
                            print(response.status);
                          },
                          request: MyfatoorahRequest.test(
                            currencyIso: Country.SaudiArabia,
                            successUrl: 'https://www.facebook.com',
                            errorUrl: 'https://www.google.com',
                            invoiceAmount: 100,
                            language: ApiLanguage.Arabic,
                            token:
                                "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL",
                          ),
                          buildAppBar: (context) {
                            return CustomAppBar(
                              "payment".tr(),
                              isProfile: false,
                              isNotification: false,
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
