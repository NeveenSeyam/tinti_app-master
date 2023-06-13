import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinti_app/Models/statics/cites_model.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/custom_appbar.dart';
import 'package:tinti_app/Widgets/custom_text_field.dart';
import 'package:tinti_app/provider/car_provider.dart';
import '../../../../../Helpers/failure.dart';
import '../../../../../Models/statics/car_model.dart';
import '../../../../../Models/statics/regions_model.dart';
import '../../../../../Models/statics/sizes.dart';
import '../../../../../Models/user car/car_model.dart';
import '../../../../../Widgets/Custom_dropDown.dart';
import '../../../../../Widgets/custom_text.dart';
import '../../../../../Widgets/gradint_button.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

import '../../../../../Widgets/loader_widget.dart';
import '../../../../../Widgets/loading_dialog.dart';
import '../../../../../Widgets/text_widget.dart';
import '../../../../../helpers/ui_helper.dart';
import '../../../../../provider/order_provider.dart';
import '../../../../../provider/statics_provider.dart';

// ignore: must_be_immutable
class RequestServieses extends ConsumerStatefulWidget {
  dynamic serviceid;
  String? price;
  RequestServieses({super.key, required this.price, required this.serviceid});

  @override
  _RequestServiesesState createState() {
    return _RequestServiesesState();
  }
}

class _RequestServiesesState extends ConsumerState<RequestServieses> {
  TextEditingController _name = TextEditingController();
  TextEditingController _model = TextEditingController();
  TextEditingController _size = TextEditingController();
  TextEditingController _modelType = TextEditingController();
  TextEditingController _color = TextEditingController();
  TextEditingController _number = TextEditingController();
  int pageIndex = 0;

  File? img;
  Future _getImageData() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    img = File(pickedFile!.path);
  }

  String dropdownValue = '';
  String sizedropdownValue = '';
  String modelTypesdropdownValue = '';
  CarSizes? carSizes;
  int? sizeId;
  String? selectedNationality;
  double? widthh;

  late Future _fetchedMyRequest;

  Future _getCarData() async {
    final prov = ref.read(staticsProvider);

    return await prov.getCarsDataRequset();
  }

  var id = 0;
  var id2 = 0;

  bool isFav = true;
  bool isVisible1 = false;
  bool isAvailble = false;
  bool isVisible2 = false;
  String? selectedRigon;
  String? selectedCity;
  String? selectedCar;
  int? selectedRigonId;
  int? selectedCityId;
  int? selectedCarId;
  late Future _fetchedRegioRequest;
  late var idCite;
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

  Future _getContentModelData() async {
    final prov = ref.read(staticsProvider);

    return await prov.getCarsDataRequset();
  }

  late Future _fetchedCarsRequest;

  Future _getCarsData() async {
    final prov = ref.read(carProvider);
    return await prov.getCarDataRequset();
  }

  Future _getSizesData() async {
    final prov = ref.read(staticsProvider);
    return await prov.getSizesDataRequset(id: id2);
  }

  late Future _fetchedSizesRequest;

  Future _getModelTypesData() async {
    final prov = ref.read(staticsProvider);

    return await prov.getSizesDataRequset(id: id);
  }

  late Future _fetchedModelTypesRequest;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _fetchedRegioRequest = _getRigonsData();

    _fetchedCitiesRequest = _getCitiesData();
    _fetchedCarsRequest = _getCarsData();
    _fetchedMyRequest = _getContentModelData();

    _fetchedSizesRequest = _getSizesData();
    _fetchedModelTypesRequest = _getModelTypesData();

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
                          Column(
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
                                      selectedRigonId = regionsModel?.regions
                                          ?.firstWhere(
                                              (element) => element.name == p0)
                                          .id;
                                      idCite = regionsModel?.regions
                                              ?.firstWhere((element) =>
                                                  element.name == p0)
                                              .id ??
                                          0;
                                      await _getCitiesData();
                                      regionsModel = ref
                                          .watch(staticsProvider)
                                          .getRegiosDataList;
                                      if (citezModel?.regions?.isNotEmpty ??
                                          false)
                                        selectedRigon = regionsModel
                                                ?.regions?.first.name
                                                .toString() ??
                                            '';

                                      final prov = ref.read(staticsProvider);
                                      //   carModelTaypesModel = CarModelTaypesModel();

                                      await prov
                                          .getCtiesDataRequset(id: idCite)
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
                              // if (citiesModel?.regions?.isNotEmpty ?? false)
                              citiesModel?.regions?.length != 0
                                  ? Container(
                                      width: 350.w,
                                      child: CustomDropDown(
                                        hintText: "city".tr(),
                                        title: "city".tr(),
                                        value: citiesModel?.regions?[0].name,
                                        list: citiesModel?.regions
                                            ?.map((e) => e.name.toString())
                                            .toList(),
                                        onChange: (p0) async {
                                          selectedCity = citiesModel?.regions
                                              ?.firstWhere((element) =>
                                                  element.name == p0)
                                              .id
                                              .toString();
                                          selectedCityId = citiesModel?.regions
                                              ?.firstWhere((element) =>
                                                  element.name == p0)
                                              .id;
                                          // await _getCitiesData();
                                          // citezModel = ref
                                          //     .watch(staticsProvider)
                                          //     .getCitiesDataList;

                                          // setState(() {});
                                        },
                                      ))
                                  : Container(),
                            ],
                          ),
                          Container(
                            height: 70.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 300.w,
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
                                        selectedCarId = carsModel?.carModles
                                            ?.firstWhere(
                                                (element) => element.name == p0)
                                            .id;
                                        await _getCarsData();

                                        setState(() {});
                                      },
                                    )),
                                Container(
                                  width: 50.w,
                                  height: 40.h,
                                  child: Consumer(
                                    builder: (context, ref, child) =>
                                        FutureBuilder(
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
                                          return Container();
                                        }
                                        if (snapshot.hasData) {
                                          if (snapshot.data is Failure) {
                                            return Container();
                                          }
                                          //
                                          //  print("snapshot data is ${snapshot.data}");
                                          var serviceModel = ref
                                                  .watch(carProvider)
                                                  .getDataList ??
                                              CarModel();
                                          var carModel = ref
                                                  .watch(staticsProvider)
                                                  .getCarsDataList ??
                                              CarModel2();
                                          var sizeModel = ref
                                                  .watch(staticsProvider)
                                                  .getSizessDataList ??
                                              SizesModel();
                                          var carModelTaypesModel = ref
                                              .watch(staticsProvider)
                                              .getCarModelTypesDataList;
                                          var getSizessDataList = ref
                                              .watch(staticsProvider)
                                              .getSizessDataList;
                                          var changCarModel =
                                              ref.watch(carProvider);
                                          print(
                                              'lingth ${serviceModel.carModles?.length}');
                                          return GestureDetector(
                                            child: Container(
                                              width: 60.w,
                                              decoration: BoxDecoration(
                                                  color: AppColors.scadryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.w)),
                                              padding: EdgeInsets.all(7.w),
                                              child: CustomText(
                                                '  +  ',
                                                color: AppColors.orange,
                                                fontSize: 24.sp,
                                              ),
                                            ),
                                            onTap: () {
                                              _color.text = '';

                                              _model.text = '';
                                              _name.text = '';
                                              _number.text = '';
                                              selectedNationality = null;
                                              dropdownValue = "";
                                              sizedropdownValue = '';
                                              widthh = 340.w;
                                              String? subModelId = "";
                                              // _image2 = null;
                                              _size.text = '';
                                              img = null;

                                              carModelTaypesModel?.carModles
                                                  ?.clear();
                                              sizeModel.carSizes?.clear();
                                              showModalBottomSheet<void>(
                                                context: context,
                                                isScrollControlled: true,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              25.w)),
                                                ),
                                                builder:
                                                    (BuildContext context) {
                                                  return StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              setState /*You can rename this!*/) {
                                                    // carModelTaypesModel
                                                    //     ?.carModles
                                                    //     ?.clear();

                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10.w),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10.w)),
                                                        ),
                                                        height: 600.h,
                                                        width: 30,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Container(
                                                              padding: EdgeInsetsDirectional
                                                                  .only(
                                                                      start:
                                                                          18.w,
                                                                      end:
                                                                          18.w),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(20
                                                                            .w),
                                                                child:
                                                                    CustomText(
                                                                  'add-car'
                                                                      .tr(),
                                                                  color: AppColors
                                                                      .scadryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      'DINNextLTArabic',
                                                                  fontSize:
                                                                      18.sp,
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                await _getImageData();
                                                                setState(() {});
                                                              },
                                                              child: img == null
                                                                  ? Padding(
                                                                      padding: EdgeInsets
                                                                          .all(10
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
                                                                              100.h,
                                                                          child:
                                                                              Icon(Icons.add_a_photo_outlined),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Center(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.all(10.w),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              150.h,
                                                                          width:
                                                                              350.w,
                                                                          child:
                                                                              Image.file(
                                                                            img ??
                                                                                File('path'),
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                RoundedInputField(
                                                                  hintText:
                                                                      'name'
                                                                          .tr(),
                                                                  width: 160.w,
                                                                  seen: false,
                                                                  controller:
                                                                      _name,
                                                                  hintColor: AppColors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.4),
                                                                  onChanged:
                                                                      (val) {},
                                                                ),
                                                                SizedBox(
                                                                  width: 10.w,
                                                                ),
                                                                Container(
                                                                  width: 170.w,
                                                                  child:
                                                                      CustomDropDown(
                                                                    hintText:
                                                                        "model"
                                                                            .tr(),
                                                                    title: "model"
                                                                        .tr(),
                                                                    value:
                                                                        dropdownValue,
                                                                    list: carModel
                                                                        .carModles
                                                                        ?.map((e) => e
                                                                            .name
                                                                            .toString())
                                                                        .toList(),
                                                                    onChange:
                                                                        (p0) async {
                                                                      widthh =
                                                                          160.w;
                                                                      selectedNationality = carModel
                                                                          .carModles
                                                                          ?.firstWhere((element) =>
                                                                              element.name ==
                                                                              p0)
                                                                          .id
                                                                          .toString();

                                                                      dropdownValue = carModel
                                                                              .carModles
                                                                              ?.firstWhere((element) => element.name == p0)
                                                                              .name
                                                                              .toString() ??
                                                                          "";
                                                                      _model.text =
                                                                          dropdownValue;
                                                                      id2 = carModel
                                                                              .carModles
                                                                              ?.firstWhere((element) => element.name == p0)
                                                                              .id ??
                                                                          0;
                                                                      //    _fetchedModelTypesRequest = _getModelTypesData();

                                                                      final prov =
                                                                          ref.read(
                                                                              staticsProvider);
                                                                      //   carModelTaypesModel = CarModelTaypesModel();

                                                                      await prov
                                                                          .getCarModelTypesDataRequset(
                                                                              id:
                                                                                  id2)
                                                                          .then(
                                                                              (value) {
                                                                        //_carModelTypesList
                                                                      });
                                                                      carModelTaypesModel = ref
                                                                          .read(
                                                                              staticsProvider)
                                                                          .getCarModelTypesDataList;
                                                                      carModelTaypesModel
                                                                          ?.carModles = ref
                                                                              .read(staticsProvider)
                                                                              .getCarModelTypesDataList
                                                                              ?.carModles ??
                                                                          [];
                                                                      setState(
                                                                          () {});

                                                                      log("carModelTaypesModel?.carModles?. ${carModelTaypesModel?.carModles?.length ?? 0}");
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                RoundedInputField(
                                                                  hintText:
                                                                      'color'
                                                                          .tr(),
                                                                  hintColor: AppColors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.4),
                                                                  seen: false,
                                                                  controller:
                                                                      _color,
                                                                  width:
                                                                      widthh ??
                                                                          340.w,
                                                                  onChanged:
                                                                      (val) {},
                                                                ),
                                                                SizedBox(
                                                                  width: 10.h,
                                                                ),
                                                                if (carModelTaypesModel
                                                                        ?.carModles
                                                                        ?.isNotEmpty ??
                                                                    false)
                                                                  Container(
                                                                    width:
                                                                        170.w,
                                                                    child:
                                                                        CustomDropDown(
                                                                      hintText:
                                                                          "model_type"
                                                                              .tr(),
                                                                      title: "model_type"
                                                                          .tr(),
                                                                      list: carModelTaypesModel
                                                                          ?.carModles
                                                                          ?.map((e) => e
                                                                              .title
                                                                              .toString())
                                                                          .toList(),
                                                                      onChange:
                                                                          (p0) async {
                                                                        subModelId = carModelTaypesModel
                                                                            ?.carModles
                                                                            ?.firstWhere((element) =>
                                                                                element.title ==
                                                                                p0)
                                                                            .id
                                                                            .toString();

                                                                        id2 = carModelTaypesModel?.carModles?.firstWhere((element) => element.title == p0).id ??
                                                                            0;
                                                                        await _getSizesData();
                                                                        sizeModel =
                                                                            ref.watch(staticsProvider).getSizessDataList ??
                                                                                SizesModel();
                                                                        if (sizeModel.carSizes?.isNotEmpty ??
                                                                            false)
                                                                          sizedropdownValue =
                                                                              sizeModel.carSizes?.first.name.toString() ?? '';

                                                                        setState(
                                                                            () {
                                                                          sizeId =
                                                                              sizeModel.carSizes?.first.id ?? 0;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                            if (sizeModel
                                                                    .carSizes
                                                                    ?.isNotEmpty ??
                                                                false)
                                                              Center(
                                                                child:
                                                                    Container(
                                                                  width: 340.w,
                                                                  child:
                                                                      CustomDropDown(
                                                                    hintText:
                                                                        "size"
                                                                            .tr(),
                                                                    title: "size"
                                                                        .tr(),
                                                                    value:
                                                                        sizedropdownValue,
                                                                    list: sizeModel
                                                                        .carSizes
                                                                        ?.map((e) => e
                                                                            .name
                                                                            .toString())
                                                                        .toList(),
                                                                    onChange:
                                                                        (p0) {
                                                                      var selectedsize = sizeModel
                                                                          .carSizes
                                                                          ?.firstWhere(
                                                                              (element) {
                                                                        return element.name ==
                                                                            p0;
                                                                      });
                                                                      sizedropdownValue =
                                                                          selectedsize?.name.toString() ??
                                                                              "";
                                                                      carSizes =
                                                                          selectedsize;
                                                                      _size.text =
                                                                          sizedropdownValue;
                                                                      setState(
                                                                          () {});
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            Center(
                                                              child:
                                                                  RoundedInputField(
                                                                width: 340.w,
                                                                hintText:
                                                                    'number'
                                                                        .tr(),
                                                                controller:
                                                                    _number,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                seen: false,
                                                                maxLingth: 9,
                                                                hintColor: AppColors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.4),
                                                                onChanged:
                                                                    (val) {},
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5.h,
                                                            ),
                                                            Center(
                                                              child:
                                                                  RaisedGradientButton(
                                                                text: 'حفظ ',
                                                                color: AppColors
                                                                    .scadryColor,
                                                                height: 48.h,
                                                                width: 340.w,
                                                                circular: 10.w,
                                                                onPressed:
                                                                    () async {
                                                                  loadingDialog(
                                                                      context);

                                                                  if (selectedNationality
                                                                          ?.isEmpty ??
                                                                      true) {
                                                                    UIHelper.showNotification(
                                                                        "aaaa");

                                                                    return;
                                                                  }
                                                                  log("img ${img?.path ?? ""}");
                                                                  await changCarModel
                                                                      .addCarRequset(
                                                                          data: {
                                                                        "name":
                                                                            _name.text,
                                                                        "color":
                                                                            _color.text,
                                                                        "car_number":
                                                                            _number.text,
                                                                        "car_model_id":
                                                                            selectedNationality,
                                                                        "car_model_type_id":
                                                                            subModelId,
                                                                        "car_size_id":
                                                                            sizeId ??
                                                                                0
                                                                      },
                                                                          file:
                                                                              img);
                                                                  setState(() {
                                                                    _fetchedMyRequest =
                                                                        _getContentModelData();

                                                                    _color.text =
                                                                        '';
                                                                    _model.text =
                                                                        '';
                                                                    _name.text =
                                                                        '';
                                                                    _number.text =
                                                                        '';
                                                                    selectedNationality =
                                                                        '';
                                                                    sizedropdownValue =
                                                                        '';
                                                                    // _image2 = null;
                                                                    _size.text =
                                                                        '';
                                                                  });
                                                                  Navigator.of(
                                                                          context,
                                                                          rootNavigator:
                                                                              true)
                                                                      .pop();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
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
                                          );
                                        }
                                        return Container();
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
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
                                var ordersModel = ref.watch(ordersProvider);
                                ordersModel.addOrderRequset(data: {
                                  "region_id": selectedRigonId,
                                  "city_id": selectedCityId,
                                  "car_id": selectedCarId,
                                  "product_id": widget.serviceid,
                                  "payment_flag": 1,
                                }).then((value) {
                                  if (value is! Failure) {
                                    if (value != null) {
                                      UIHelper.showNotification("error".tr());
                                      //    Navigator.pop(context);
                                      setState(() {
                                        // isAvailble=true;
                                        isVisible1 = true;
                                      });
                                    }
                                  }

                                  return isAvailble;
                                });
                              },
                              text: 'تنفيذ',
                              circular: 10.w,
                              width: 260.w,
                            ),
                            Container(
                              width: 90.w,
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
                                '${widget.price} \$' ?? ' 100 \$',
                                color: AppColors.orange,
                                fontSize: 16.sp,
                                fontFamily: 'DINNextLTArabic',
                                textAlign: TextAlign.start,
                              ),
                            )
                          ],
                        )
                      : isVisible1 == true
                          ? MyFatoorah(
                              onResult: (response) {
                                print(response.status);
                              },
                              request: MyfatoorahRequest.test(
                                currencyIso: Country.SaudiArabia,
                                successUrl: 'https://www.facebook.com',
                                errorUrl: 'https://www.google.com',
                                invoiceAmount:
                                    double.parse(widget.price ?? '0'),
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
                            )
                          : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
