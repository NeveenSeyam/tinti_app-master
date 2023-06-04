import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinti_app/Models/auth/profile_model.dart';
import 'package:tinti_app/Models/statics/car_model.dart';
import 'package:tinti_app/Models/statics/sizes.dart';
import 'package:tinti_app/Util/constants/constants.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/button_widget.dart';
import 'package:tinti_app/Widgets/custom_text.dart';
import 'package:tinti_app/helpers/ui_helper.dart';
import 'package:tinti_app/provider/account_provider.dart';
import 'package:tinti_app/provider/statics_provider.dart';

import '../../../../Helpers/failure.dart';
import '../../../../Models/user car/car_model.dart';
import '../../../../Widgets/Custom_dropDown.dart';
import '../../../../Widgets/custom_appbar.dart';
import '../../../../Widgets/custom_text_field.dart';
import '../../../../Widgets/gradint_button.dart';
import '../../../../Widgets/loader_widget.dart';
import '../../../../Widgets/loading_dialog.dart';
import '../../../../Widgets/text_widget.dart';
import '../../../../provider/car_provider.dart';
import '../../../auth/login_screen.dart';
import '../contact_us.dart';

class MyCarsScreen extends ConsumerStatefulWidget {
  const MyCarsScreen({super.key});

  @override
  _MyCarPageState createState() => _MyCarPageState();
}

enum Language {
  Arabic,
  English,
}

class _MyCarPageState extends ConsumerState<MyCarsScreen> {
  TextEditingController _name = TextEditingController();
  TextEditingController _model = TextEditingController();
  TextEditingController _size = TextEditingController();
  TextEditingController _color = TextEditingController();
  TextEditingController _number = TextEditingController();
  int pageIndex = 0;

  File? img;
  var immage;
  Future _getImageData() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    img = File(pickedFile!.path);
  }

  String dropdownValue = '';
  String sizedropdownValue = '';
  String? selectedNationality;

  Future _getContentData() async {
    final prov = ref.read(carProvider);

    return await prov.getCarDataRequset();
  }

  late Future _fetchedMyRequest;

  Future _getCarData() async {
    final prov = ref.read(staticsProvider);

    return await prov.getCarsDataRequset();
  }

  late Future _fetchedCarRequest;

  Future _getSizesData() async {
    final prov = ref.read(staticsProvider);

    return await prov.getSizesDataRequset();
  }

  late Future _fetchedSizesRequest;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _fetchedMyRequest = _getContentData();

    _fetchedCarRequest = _getCarData();
    _fetchedSizesRequest = _getSizesData();

    super.initState();
  }
  // var selectedValue = 'Option 1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'my-cars'.tr(),
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
            child: Constants.isQuest == false
                ? Consumer(
                    builder: (context, ref, child) => FutureBuilder(
                      future: _fetchedMyRequest,
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
                                              builder: (context) =>
                                                  ContactUsScreen()),
                                        );
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
                          var serviceModel =
                              ref.watch(carProvider).getDataList ?? CarModel();
                          var carModel =
                              ref.watch(staticsProvider).getCarsDataList ??
                                  CarModel2();
                          var sizeModel =
                              ref.watch(staticsProvider).getSizessDataList ??
                                  SizesModel();

                          var changCarModel = ref.watch(carProvider);
                          print('lingth ${serviceModel.carModles?.length}');
                          return serviceModel.carModles?.length != 0
                              ? ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount:
                                      serviceModel.carModles?.length ?? 0,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 10.h),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.w)),
                                      width: 370.w,
                                      height: 140.h,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 180.w,
                                            height: 140.h,
                                            alignment: Alignment.bottomRight,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.w),
                                              child: Image.network(
                                                serviceModel.carModles?[index]
                                                        .image ??
                                                    '',
                                                width: 180.w,
                                                height: 160.h,
                                                fit: BoxFit.fill,
                                                alignment:
                                                    Alignment.bottomRight,
                                              ),
                                            ),
                                          ),
                                          // SizedBox(
                                          //   width: 10.w,
                                          // ),
                                          Padding(
                                            padding: EdgeInsets.all(10.w),
                                            child: SizedBox(
                                              width: 160.w,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CustomText(
                                                        fontFamily:
                                                            'DINNEXTLTARABIC',
                                                        color: AppColors
                                                            .scadryColor,
                                                        serviceModel
                                                                ?.carModles?[
                                                                    index]
                                                                .carModelName ??
                                                            ' أودي  ',
                                                        fontSize: 14.sp,
                                                      ),
                                                      CustomText(
                                                        fontFamily:
                                                            'DINNEXTLTARABIC',
                                                        color: AppColors.orange,
                                                        serviceModel
                                                                ?.carModles?[
                                                                    index]
                                                                .carNumber ??
                                                            ' 2020  ',
                                                        fontSize: 14.sp,
                                                      ),
                                                      CustomText(
                                                        fontFamily:
                                                            'DINNEXTLTARABIC',
                                                        color: AppColors
                                                            .scadryColor,
                                                        serviceModel
                                                                ?.carModles?[
                                                                    index]
                                                                .color ??
                                                            ' أحمر  ',
                                                        fontSize: 14.sp,
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          _color
                                                              .text = serviceModel
                                                                  ?.carModles?[
                                                                      index]
                                                                  .color ??
                                                              '';

                                                          _model
                                                              .text = serviceModel
                                                                  ?.carModles?[
                                                                      index]
                                                                  .carModelName ??
                                                              '';
                                                          _name
                                                              .text = serviceModel
                                                                  ?.carModles?[
                                                                      index]
                                                                  .name ??
                                                              '';
                                                          _number
                                                              .text = serviceModel
                                                                  ?.carModles?[
                                                                      index]
                                                                  .carNumber ??
                                                              '';
                                                          selectedNationality =
                                                              null;
                                                          dropdownValue = "";
                                                          sizedropdownValue =
                                                              '';
                                                          // _image2 = null;
                                                          _size.text = '';
                                                          img = null;
                                                          showModalBottomSheet<
                                                              void>(
                                                            context: context,
                                                            isScrollControlled:
                                                                true,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.vertical(
                                                                      top: Radius
                                                                          .circular(
                                                                              25.w)),
                                                            ),
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return StatefulBuilder(builder:
                                                                  (BuildContext
                                                                          context,
                                                                      StateSetter
                                                                          setState /*You can rename this!*/) {
                                                                return Padding(
                                                                  padding: EdgeInsets.only(
                                                                      bottom: MediaQuery.of(
                                                                              context)
                                                                          .viewInsets
                                                                          .bottom),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(10
                                                                              .w),
                                                                          topRight:
                                                                              Radius.circular(10.w)),
                                                                    ),
                                                                    height:
                                                                        500.h,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          alignment:
                                                                              Alignment.centerRight,
                                                                          padding: EdgeInsetsDirectional.only(
                                                                              start: 18.w,
                                                                              end: 18.w),
                                                                          child:
                                                                              CustomText(
                                                                            'update-car'.tr(),
                                                                            color:
                                                                                AppColors.scadryColor,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontFamily:
                                                                                'DINNextLTArabic',
                                                                            fontSize:
                                                                                18.sp,
                                                                          ),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () async {
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
                                                                                  padding: EdgeInsets.all(10.w),
                                                                                  child: Center(
                                                                                    child: Container(
                                                                                      color: AppColors.grey.withOpacity(0.3),
                                                                                      width: 350.w,
                                                                                      height: 100.h,
                                                                                      child: Icon(Icons.add_a_photo_outlined),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              : Center(
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.all(10.w),
                                                                                    child: Container(
                                                                                      height: 150.h,
                                                                                      width: 350.w,
                                                                                      child: Image.file(
                                                                                        img ?? File('path'),
                                                                                        fit: BoxFit.fill,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            RoundedInputField(
                                                                              hintText: serviceModel?.carModles?[index].name ?? 'name'.tr(),
                                                                              width: 160.w,
                                                                              seen: false,
                                                                              controller: _name,
                                                                              hintColor: AppColors.grey.withOpacity(0.4),
                                                                              onChanged: (val) {},
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10.w,
                                                                            ),
                                                                            Container(
                                                                              width: 170.w,
                                                                              child: CustomDropDown(
                                                                                hintText: "model".tr(),
                                                                                title: "model".tr(),
                                                                                value: dropdownValue,
                                                                                list: carModel.carModles!.map((e) => e.name.toString()).toList(),
                                                                                onChange: (p0) {
                                                                                  selectedNationality = carModel.carModles!.firstWhere((element) => element.name == p0).id.toString();
                                                                                  dropdownValue = selectedNationality ?? "";
                                                                                  _model.text = dropdownValue;
                                                                                  setState(() {});
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            RoundedInputField(
                                                                              hintText: serviceModel?.carModles?[index].color ?? 'color'.tr(),
                                                                              hintColor: AppColors.grey.withOpacity(0.4),
                                                                              seen: false,
                                                                              controller: _color,
                                                                              width: 160.w,
                                                                              onChanged: (val) {},
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10.h,
                                                                            ),
                                                                            Container(
                                                                              width: 170.w,
                                                                              child: CustomDropDown(
                                                                                hintText: "size".tr(),
                                                                                title: "size".tr(),
                                                                                value: sizedropdownValue,
                                                                                list: sizeModel.carSizes!.map((e) => e.name.toString()).toList(),
                                                                                onChange: (p0) {
                                                                                  var selectedSize = sizeModel.carSizes!.firstWhere((element) {
                                                                                    return element.name == p0;
                                                                                  });
                                                                                  sizedropdownValue = selectedSize.id.toString() ?? "";
                                                                                  _size.text = sizedropdownValue;
                                                                                  setState(() {});
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        RoundedInputField(
                                                                          width:
                                                                              340.w,
                                                                          hintText:
                                                                              serviceModel?.carModles?[index].carNumber ?? 'number'.tr(),
                                                                          controller:
                                                                              _number,
                                                                          seen:
                                                                              false,
                                                                          hintColor: AppColors
                                                                              .grey
                                                                              .withOpacity(0.4),
                                                                          onChanged:
                                                                              (val) {},
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5.h,
                                                                        ),
                                                                        RaisedGradientButton(
                                                                          text:
                                                                              'save'.tr(),
                                                                          color:
                                                                              AppColors.scadryColor,
                                                                          height:
                                                                              48.h,
                                                                          width:
                                                                              340.w,
                                                                          circular:
                                                                              10.w,
                                                                          onPressed:
                                                                              () async {
                                                                            loadingDialog(context);

                                                                            if (selectedNationality?.isEmpty ??
                                                                                true) {
                                                                              UIHelper.showNotification("should select value".tr());
                                                                              if (sizedropdownValue.isEmpty ?? true) {
                                                                                UIHelper.showNotification("should select value".tr());
                                                                                return;
                                                                              }

                                                                              return;
                                                                            }
                                                                            log("img ${img?.path ?? ""}");
                                                                            await changCarModel.editCarRequset(data: {
                                                                              "name": _name.text ?? serviceModel?.carModles?[index].name,
                                                                              "color": _color.text ?? serviceModel?.carModles?[index].color,
                                                                              "car_number": _number.text ?? serviceModel?.carModles?[index].carNumber,
                                                                              "car_model_id": selectedNationality ?? serviceModel?.carModles?[index].carModelName,
                                                                              "car_size_id": sizedropdownValue ?? serviceModel?.carModles?[index].carSizeName
                                                                            }, id: serviceModel.carModles?[index].id.toString() ?? '', file: img);
                                                                            setState(() {
                                                                              _fetchedMyRequest = _getContentData();

                                                                              _color.text = '';
                                                                              _model.text = '';
                                                                              _name.text = '';
                                                                              _number.text = '';
                                                                              selectedNationality = '';
                                                                              sizedropdownValue = '';
                                                                              // _image2 = null;
                                                                              _size.text = '';
                                                                              dropdownValue = '';
                                                                            });

                                                                            Navigator.pop(context);
                                                                            Navigator.pop(context);
                                                                          },
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                            },
                                                          );
                                                        },
                                                        child: Container(
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          child: Image.asset(
                                                              'assets/images/update_car.png'),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          loadingDialog(
                                                              context);

                                                          await changCarModel
                                                              .removeCarRequset(
                                                                  id: serviceModel
                                                                          ?.carModles?[
                                                                              index]
                                                                          .id ??
                                                                      '');

                                                          setState(() {
                                                            _fetchedMyRequest =
                                                                _getContentData();
                                                          });
                                                          UIHelper.showNotification(
                                                              'delete succses'
                                                                  .tr(),
                                                              backgroundColor:
                                                                  AppColors
                                                                      .green);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          child: Image.asset(
                                                              'assets/images/delete.png'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.all(20.w),
                                  child: Container(
                                      padding: EdgeInsets.all(20.w),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.w),
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
                                              'dont add car'.tr(),
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
                                            text: 'show product'.tr(),
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
                          text: ' login'.tr(),
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
        ),
      ),
      floatingActionButton: Constants.isQuest == false
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
                                  "contact support".tr(),
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
                    var carModel = ref.watch(staticsProvider).getCarsDataList ??
                        CarModel2();
                    var sizeModel =
                        ref.watch(staticsProvider).getSizessDataList ??
                            SizesModel();
                    var changCarModel = ref.watch(carProvider);
                    print('lingth ${serviceModel.carModles?.length}');
                    return Container(
                      width: 50.w,
                      height: 50.h,
                      child: FloatingActionButton(
                        onPressed: () {
                          _color.text = '';
                          _model.text = '';
                          _name.text = '';
                          _number.text = '';
                          selectedNationality = '';
                          sizedropdownValue = '';
                          dropdownValue = '';
                          // _image2 = null;
                          _size.text = '';
                          img = null;
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
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.w),
                                          topRight: Radius.circular(10.w)),
                                    ),
                                    height: 500.h,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 20.w),
                                          child: Container(
                                            padding: EdgeInsetsDirectional.only(
                                                start: 18.w, end: 18.w),
                                            child: CustomText(
                                              'add-car'.tr(),
                                              color: AppColors.scadryColor,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'DINNextLTArabic',
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                                      padding:
                                                          EdgeInsets.all(10.w),
                                                      child: Center(
                                                        child: Container(
                                                          color: AppColors.grey
                                                              .withOpacity(0.3),
                                                          width: 350.w,
                                                          height: 100.h,
                                                          child: Icon(Icons
                                                              .add_a_photo_outlined),
                                                        ),
                                                      ),
                                                    )
                                                  : Center(
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            10.w),
                                                        child: Container(
                                                          height: 150.h,
                                                          width: 350.w,
                                                          child: Image.file(
                                                            img ?? File('path'),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                RoundedInputField(
                                                  hintText: 'name'.tr(),
                                                  width: 160.w,
                                                  seen: false,
                                                  controller: _name,
                                                  hintColor: AppColors.grey
                                                      .withOpacity(0.4),
                                                  onChanged: (val) {},
                                                ),
                                                SizedBox(
                                                  width: 15.w,
                                                ),
                                                Container(
                                                  width: 170.w,
                                                  child: CustomDropDown(
                                                    hintText: "model".tr(),
                                                    title: "model".tr(),
                                                    value: dropdownValue,
                                                    list: carModel.carModles!
                                                        .map((e) =>
                                                            e.name.toString())
                                                        .toList(),
                                                    onChange: (p0) {
                                                      selectedNationality =
                                                          carModel
                                                              .carModles!
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .name ==
                                                                      p0)
                                                              .id
                                                              .toString();
                                                      dropdownValue =
                                                          selectedNationality ??
                                                              "";
                                                      _model.text =
                                                          dropdownValue;
                                                      setState(() {});
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                RoundedInputField(
                                                  hintText: 'color'.tr(),
                                                  hintColor: AppColors.grey
                                                      .withOpacity(0.4),
                                                  seen: false,
                                                  controller: _color,
                                                  width: 160.w,
                                                  onChanged: (val) {},
                                                ),
                                                SizedBox(
                                                  width: 15.h,
                                                ),
                                                Container(
                                                  width: 170.w,
                                                  child: CustomDropDown(
                                                    hintText: "size".tr(),
                                                    title: "النوع",
                                                    value: sizedropdownValue,
                                                    list: sizeModel.carSizes!
                                                        .map((e) =>
                                                            e.name.toString())
                                                        .toList(),
                                                    onChange: (p0) {
                                                      var selectedSize =
                                                          sizeModel.carSizes!
                                                              .firstWhere(
                                                                  (element) {
                                                        return element.name ==
                                                            p0;
                                                      });
                                                      sizedropdownValue =
                                                          selectedSize.id
                                                                  .toString() ??
                                                              "";
                                                      _size.text =
                                                          sizedropdownValue;
                                                      setState(() {});
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            RoundedInputField(
                                              width: 340.w,
                                              hintText: 'number'.tr(),
                                              controller: _number,
                                              seen: false,
                                              hintColor: AppColors.grey
                                                  .withOpacity(0.4),
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
                                              onPressed: () async {
                                                loadingDialog(context);

                                                if (selectedNationality
                                                        ?.isEmpty ??
                                                    true) {
                                                  UIHelper.showNotification(
                                                      "aaaa");

                                                  return;
                                                }
                                                log("img ${img?.path ?? ""}");
                                                await changCarModel
                                                    .addCarRequset(data: {
                                                  "name": _name.text,
                                                  "color": _color.text,
                                                  "car_number": _number.text,
                                                  "car_model_id":
                                                      selectedNationality,
                                                  "car_size_id":
                                                      sizedropdownValue
                                                }, file: img);
                                                setState(() {
                                                  _fetchedMyRequest =
                                                      _getContentData();

                                                  _color.text = '';
                                                  _model.text = '';
                                                  _name.text = '';
                                                  _number.text = '';
                                                  selectedNationality = '';
                                                  sizedropdownValue = '';
                                                  // _image2 = null;
                                                  _size.text = '';
                                                });
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            },
                          );
                        },
                        child: Icon(Icons.add),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            )
          : null,
    );
  }
}
