import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfatoorah_flutter/embeddedapplepay/MFApplePayButton.dart';
import 'package:myfatoorah_flutter/embeddedpayment/MFPaymentCardView.dart';
import 'package:myfatoorah_flutter/model/initpayment/SDKInitiatePaymentResponse.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
import 'package:myfatoorah_flutter/utils/MFCountry.dart';
import 'package:myfatoorah_flutter/utils/MFEnvironment.dart';
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
import '../../../../../Widgets/button_widget.dart';
import '../../../../../Widgets/custom_text.dart';
import '../../../../../Widgets/gradint_button.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

import '../../../../../Widgets/loader_widget.dart';
import '../../../../../Widgets/loading_dialog.dart';
import '../../../../../Widgets/text_widget.dart';
import '../../../../../helpers/ui_helper.dart';
import '../../../../../main.dart';
import '../../../../../provider/order_provider.dart';
import '../../../../../provider/statics_provider.dart';

// ignore: must_be_immutable
class RequestServieses extends ConsumerStatefulWidget {
  dynamic serviceid;
  String? price;
  String? name;
  String? company_name;
  String? rate;
  RequestServieses(
      {super.key,
      required this.price,
      required this.serviceid,
      required this.company_name,
      required this.name,
      required this.rate});

  @override
  _RequestServiesesState createState() {
    return _RequestServiesesState();
  }
}

final String mAPIKey =
    "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL";

class _RequestServiesesState extends ConsumerState<RequestServieses> {
  String? _response = '';
  String _loading = "Loading...";

  List<PaymentMethods> paymentMethods = [];
  List<bool> isSelected = [];
  int selectedPaymentMethodIndex = -1;

  String amount = "0.010";
  String cardNumber = "5453010000095489";
  String expiryMonth = "5";
  String expiryYear = "21";
  String securityCode = "100";
  String cardHolderName = "Mahmoud Ibrahim";
  bool visibilityObs = false;
  var ordersModel;
  MFPaymentCardView? mfPaymentCardView;
  MFApplePayButton? mfApplePayButton;

  @override
  void initState() {
    super.initState();

    if (mAPIKey.isEmpty) {
      setState(() {
        _response =
            "Missing API Token Key.. You can get it from here: https://myfatoorah.readme.io/docs/test-token";
      });
      return;
    }
    _fetchedRegioRequest = _getRigonsData();

    _fetchedCitiesRequest = _getCitiesData();
    _fetchedCarsRequest = _getCarsData();
    _fetchedMyRequest = _getContentModelData();

    _fetchedSizesRequest = _getSizesData();
    _fetchedModelTypesRequest = _getModelTypesData();

    // TODO, don't forget to init the MyFatoorah Plugin with the following line
    MFSDK.init(mAPIKey, MFCountry.SAUDI_ARABIA, MFEnvironment.TEST);

    initiatePayment();
    initiateSession();
  }

  void sendPayment() {
    var request = MFSendPaymentRequest(
        invoiceValue: double.parse(widget.price ?? '0'),
        customerName: "Customer name",
        notificationOption: MFNotificationOption.LINK);

    MFSDK.sendPayment(
        context,
        MFAPILanguage.EN,
        request,
        (MFResult<MFSendPaymentResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(result.response?.toJson());
                    _response = result.response?.toJson().toString();
                  })
                }
              else
                {
                  setState(() {
                    print(result.error?.toJson());
                    _response = result.error?.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

  void initiatePayment() {
    var request = MFInitiatePaymentRequest(
        double.parse(widget.price ?? '0'), MFCurrencyISO.SAUDI_ARABIA_SAR);

    MFSDK.initiatePayment(
        request,
        MFAPILanguage.EN,
        (MFResult<MFInitiatePaymentResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(result.response?.toJson());
                    _response = ""; //result.response?.toJson().toString();
                    paymentMethods.addAll(result.response!.paymentMethods!);
                    for (int i = 0; i < paymentMethods.length; i++)
                      isSelected.add(false);
                  })
                }
              else
                {
                  setState(() {
                    print(result.error?.toJson());
                    _response = result.error?.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

  Future executeRegularPayment(int paymentMethodId) async {
    var request = MFExecutePaymentRequest(
        paymentMethodId, double.parse(widget.price ?? '0'));

    await MFSDK.executePayment(context, request, MFAPILanguage.EN,
        onInvoiceCreated: (String invoiceId) =>
            {print("invoiceId: " + invoiceId)},
        onPaymentResponse: (String invoiceId,
                MFResult<MFPaymentStatusResponse> result) async =>
            {
              if (result.isSuccess())
                {
                  print('oooooooo'),
                  ordersModel = await ref
                      .watch(ordersProvider)
                      .activeOrderRequset(id: order_id)
                      .then((value) {
                    if (value is! Failure) {
                      if (value == null) {
                        UIHelper.showNotification(value.toString());
                        print(value);
                        print('oooooooo2');
                      }
                      if (value != false) {
                        print('oooooooo3');
                        // UIHelper.showNotification(value.toString());
                        // showDialog(
                        //   context: context,
                        //   builder: (context) {
                        //     return AlertDialog(
                        //       title: Text('شكرا '),
                        //       content: Column(
                        //         children: [
                        //           ButtonWidget(
                        //             title: 'تمت',
                        //             onPressed: () {},
                        //           )
                        //         ],
                        //       ),
                        //     );
                        //   },
                        // );
                        Navigator.popAndPushNamed(
                            context, '/navegaitor_screen');

                        // Navigator.of(context).pop();
                        print(value);
                      }
                    }

                    return isAvailble;
                  }),
                  setState(() {
                    print(invoiceId);
                    print(result.response?.toJson());
                    _response = result.response?.toJson().toString();
                    isAvailble = false;
                  })
                }
              else
                {
                  setState(() {
                    print(invoiceId);
                    print(result.error?.toJson());
                    _response = result.error?.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
      isAvailble = false;
    });
  }

  void executeDirectPayment(int paymentMethodId) {
    var request = MFExecutePaymentRequest(
        paymentMethodId, double.parse(widget.price ?? '0'));

    var mfCardInfo = MFCardInfo(
        cardNumber: cardNumber,
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        securityCode: securityCode,
        cardHolderName: cardHolderName,
        bypass3DS: false,
        saveToken: false);

    MFSDK.executeDirectPayment(
        context,
        request,
        mfCardInfo,
        MFAPILanguage.EN,
        (String invoiceId, MFResult<MFDirectPaymentResponse> result) async => {
              if (result.isSuccess())
                {
                  await ordersModel
                      .activeOrderRequset(id: order_id)
                      .then((value) {
                    if (value is! Failure) {
                      if (value == null) {
                        UIHelper.showNotification(value.toString());
                        print(value);
                      }
                      if (value != false) {
                        UIHelper.showNotification(value.status.toString());
                        print(value);
                      }
                    }

                    return isAvailble;
                  }),
                  setState(() {
                    print(invoiceId);
                    print(result.response?.toJson());
                    _response = result.response?.toJson().toString();
                  })
                }
              else
                {
                  setState(() {
                    print(invoiceId);
                    print(result.error?.toJson());
                    _response = result.error?.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

  // void executeDirectPaymentWithRecurring() {
  //   int paymentMethod = 20;

  //   var request = MFExecutePaymentRequest(
  //       paymentMethod, double.parse(widget.price ?? '0'));

  //   var mfCardInfo = MFCardInfo(
  //       cardNumber: cardNumber,
  //       expiryMonth: expiryMonth,
  //       expiryYear: expiryYear,
  //       securityCode: securityCode,
  //       bypass3DS: true,
  //       saveToken: true);

  //   MFSDK.executeRecurringDirectPayment(
  //       context,
  //       request,
  //       mfCardInfo,
  //       MFRecurringType.monthly,
  //       MFAPILanguage.EN,
  //       (String invoiceId, MFResult<MFDirectPaymentResponse> result) async => {
  //             if (result.isSuccess())
  //               {
  //                 await ordersModel
  //                     .activeOrderRequset(id: order_id)
  //                     .then((value) {
  //                   if (value is! Failure) {
  //                     if (value == null) {
  //                       UIHelper.showNotification(value.toString());
  //                       print(value);
  //                     }
  //                     if (value != false) {
  //                       UIHelper.showNotification(value.status.toString());
  //                       print(value);
  //                     }
  //                   }

  //                   return isAvailble;
  //                 }),
  //                 setState(() {
  //                   print(invoiceId);
  //                   print(result.response?.toJson());
  //                   _response = result.response?.toJson().toString();
  //                 })
  //               }
  //             else
  //               {
  //                 setState(() {
  //                   print(invoiceId);
  //                   print(result.error?.toJson());
  //                   _response = result.error?.message;
  //                 })
  //               }
  //           });

  //   setState(() {
  //     _response = _loading;
  //   });
  // }

  /*
    Payment Enquiry
   */
  void getPaymentStatus() {
    var request = MFPaymentStatusRequest(invoiceId: "12345");

    MFSDK.getPaymentStatus(
        MFAPILanguage.EN,
        request,
        (MFResult<MFPaymentStatusResponse> result) async => {
              if (result.isSuccess())
                {
                  await ordersModel
                      .activeOrderRequset(id: order_id)
                      .then((value) {
                    if (value is! Failure) {
                      if (value == null) {
                        UIHelper.showNotification(value.toString());
                        print(value);
                      }
                      if (value != false) {
                        UIHelper.showNotification(value.status.toString());
                        print(value);
                      }
                    }

                    return isAvailble;
                  }),
                  setState(() {
                    print(result.response?.toJson());
                    _response = result.response?.toJson().toString();
                  })
                }
              else
                {
                  setState(() {
                    print(result.error?.toJson());
                    _response = result.error?.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

  /*
    Cancel Token
   */
  void cancelToken() {
    MFSDK.cancelToken(
        "Put your token here",
        MFAPILanguage.EN,
        (MFResult<bool> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(result.response.toString());
                    _response = result.response.toString();
                  })
                }
              else
                {
                  setState(() {
                    print(result.error?.toJson());
                    _response = result.error?.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

  /*
    Cancel Recurring Payment
   */
  void cancelRecurringPayment() {
    MFSDK.cancelRecurringPayment(
        "Put RecurringId here",
        MFAPILanguage.EN,
        (MFResult<bool> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(result.response.toString());
                    _response = result.response.toString();
                  })
                }
              else
                {
                  setState(() {
                    print(result.error?.toJson());
                    _response = result.error?.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

  void setPaymentMethodSelected(int index, bool value) {
    for (int i = 0; i < isSelected.length; i++) {
      if (i == index) {
        isSelected[i] = value;
        if (value) {
          selectedPaymentMethodIndex = index;
          visibilityObs = paymentMethods[index].isDirectPayment!;
        } else {
          selectedPaymentMethodIndex = -1;
          visibilityObs = false;
        }
      } else
        isSelected[i] = false;
    }
  }

  void initiateSession() {
    MFSDK.initiateSession(null, (MFResult<MFInitiateSessionResponse> result) {
      if (result.isSuccess()) {
        // This for embedded payment view
        mfPaymentCardView?.load(result.response!,
            onCardBinChanged: (String bin) => {print("Bin: " + bin)});

        /// This for Apple pay button
        if (Platform.isIOS) {
          loadApplePay(result.response!);
        }
      } else {
        setState(() {
          var errorJson = result.error?.toJson();
          print("Error: " + errorJson.toString());
          _response = errorJson?.toString();
        });
      }
    });
  }

  /// This for Apple pay button
  void loadApplePay(MFInitiateSessionResponse mfInitiateSessionResponse) {
    var request = MFExecutePaymentRequest.constructorForApplyPay(
        0.100, MFCurrencyISO.SAUDI_ARABIA_SAR);
    mfApplePayButton?.loadWithStartLoading(
        mfInitiateSessionResponse,
        request,
        MFAPILanguage.EN,
        () => {
              setState(() {
                _response = "Loading...";
              })
            },
        (String invoiceId, MFResult<MFPaymentStatusResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print("invoiceId: " + invoiceId);
                    _response = result.response?.toJson().toString();
                    print("Response: " + _response!);
                  })
                }
              else
                {
                  setState(() {
                    print("invoiceId: " + invoiceId);
                    print("Error: " + (result.error?.toJson() as String));
                    _response = result.error?.message;
                  })
                }
            });
  }

  void payWithEmbeddedPayment() {
    var request = MFExecutePaymentRequest.constructor(0.010);

    mfPaymentCardView?.pay(
        request,
        MFAPILanguage.EN,
        (String invoiceId, MFResult<MFPaymentStatusResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print("invoiceId: " + invoiceId);
                    _response = result.response?.toJson().toString();
                    print("Response: " + _response!);
                  })
                }
              else
                {
                  setState(() {
                    print("invoiceId: " + invoiceId);
                    var errorJson = result.error?.toJson();
                    print("Error: " + errorJson.toString());
                    _response = errorJson?.toString();
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

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
  dynamic order_id = 0;
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
                            // height: 70.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  // height: 40.h,
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
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12.w),
                                              child: Center(
                                                child: Icon(
                                                  Icons.directions_car_rounded,
                                                  size: 30.w,
                                                  color: AppColors.white,
                                                ),
                                                //  CustomText(
                                                //   '+',
                                                //   color: AppColors.orange,
                                                //   fontSize: 30.sp,
                                                // ),
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
                                                                              Icon(
                                                                            Icons.directions_car_rounded,
                                                                            color:
                                                                                AppColors.scadryColor,
                                                                            size:
                                                                                40.w,
                                                                          ),
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
                      widget.name ?? 'نانو سيراميك',
                      color: AppColors.scadryColor,
                      fontSize: 18.sp,
                      fontFamily: 'DINNextLTArabic',
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      widget.company_name ?? 'جونسون اند جونسون ',
                      color: AppColors.orange,
                      fontSize: 14.sp,
                      fontFamily: 'DINNextLTArabic',
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          widget.rate ?? ' 4.2  ',
                          color: AppColors.scadryColor,
                          fontSize: 18.sp,
                          fontFamily: 'DINNextLTArabic',
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w500,
                        ),
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
                      ],
                    ),
                    Row(
                      children: [
                        CustomText(
                          '${widget.price}' ?? '',
                          fontSize: 18.sp,
                          color: AppColors.scadryColor,
                          fontFamily: 'DINNextLTArabic',
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          ' ر.س',
                          fontSize: 18.sp,
                          color: AppColors.orange,
                          fontFamily: 'DINNextLTArabic',
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
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
              child: isVisible1 == false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RaisedGradientButton(
                          color: AppColors.scadryColor,
                          textColor: AppColors.white,
                          onPressed: () async {
                            var ordersModel = ref.watch(ordersProvider);

                            if (selectedCarId != null &&
                                selectedCityId != null &&
                                selectedRigonId != null) {
                              final response =
                                  await ordersModel.addOrderRequset(data: {
                                "region_id": selectedRigonId,
                                "city_id": selectedCityId,
                                "car_id": selectedCarId,
                                "product_id": widget.serviceid,
                                "payment_flag": 1,
                              }).then((value) async {
                                if (value is! Failure) {
                                  if (value == null) {
                                    setState(() {
                                      isVisible1 = false;
                                    });
                                  }
                                  if (value != false) {
                                    order_id = await ref
                                            .read(ordersProvider)
                                            .order_id
                                            .toString() ??
                                        '';
                                    setState(() {
                                      print(order_id);

                                      isVisible1 = true;
                                    });
                                  }
                                }

                                return isAvailble;
                              });
                            } else {
                              UIHelper.showNotification(
                                  'يجب اختار المنطقة والمدينة والسيارة المراد تنفيذ الخدمة عليها ');
                            }
                          },
                          text: 'تنفيذ',
                          circular: 10.w,
                          width: 240.w,
                        ),
                        Container(
                          width: 100.w,
                          height: 48,
                          padding: EdgeInsets.symmetric(
                              vertical: 12.w, horizontal: 2.h),
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
                          child: Center(
                            child: CustomText(
                              '${widget.price} ر.س' ?? ' 100 ر.س',
                              color: AppColors.orange,
                              fontSize: 14.sp,
                              fontFamily: 'DINNextLTArabic',
                              textAlign: TextAlign.start,
                            ),
                          ),
                        )
                      ],
                    )
                  : isVisible1 == true
                      ? Flex(direction: Axis.vertical, children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // ElevatedButton(
                                    //   onPressed: sendPayment,
                                    //   child: const Text('Send Payment'),
                                    // ),
                                    const Padding(
                                      padding: EdgeInsets.all(5.0),
                                    ),
                                    const Text("Select payment method"),
                                    const Padding(
                                      padding: EdgeInsets.all(5.0),
                                    ),
                                    SizedBox(
                                      height: 160.h,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: paymentMethods.length,
                                          itemBuilder:
                                              (BuildContext ctxt, int index) {
                                            return Padding(
                                              padding: EdgeInsets.all(8.w),
                                              child: Container(
                                                  // width: 60,
                                                  height: 80.h,
                                                  decoration: BoxDecoration(
                                                      color: AppColors.orange
                                                          .withOpacity(0.3),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.w)),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.h),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Image.network(
                                                          paymentMethods[index]
                                                              .imageUrl!,
                                                          width: 90.w,
                                                          height: 90.h),
                                                      Checkbox(
                                                          value:
                                                              isSelected[index],
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              setPaymentMethodSelected(
                                                                  index,
                                                                  value!);
                                                            });
                                                          })
                                                    ],
                                                  )),
                                            );
                                          }),
                                    ),
                                    // visibilityObs
                                    //     ? Column(
                                    //         children: <Widget>[
                                    //           const Padding(
                                    //             padding: EdgeInsets.all(5.0),
                                    //           ),
                                    //           TextField(
                                    //             keyboardType:
                                    //                 TextInputType.number,
                                    //             decoration:
                                    //                 const InputDecoration(
                                    //                     labelText:
                                    //                         "Card Number"),
                                    //             controller:
                                    //                 TextEditingController(
                                    //                     text: cardNumber),
                                    //             onChanged: (value) {
                                    //               cardNumber = value;
                                    //             },
                                    //           ),
                                    //           TextField(
                                    //             keyboardType:
                                    //                 TextInputType.number,
                                    //             decoration:
                                    //                 const InputDecoration(
                                    //                     labelText:
                                    //                         "Expiry Month"),
                                    //             controller:
                                    //                 TextEditingController(
                                    //                     text: expiryMonth),
                                    //             onChanged: (value) {
                                    //               expiryMonth = value;
                                    //             },
                                    //           ),
                                    //           TextField(
                                    //             keyboardType:
                                    //                 TextInputType.number,
                                    //             decoration:
                                    //                 const InputDecoration(
                                    //                     labelText:
                                    //                         "Expiry Year"),
                                    //             controller:
                                    //                 TextEditingController(
                                    //                     text: expiryYear),
                                    //             onChanged: (value) {
                                    //               expiryYear = value;
                                    //             },
                                    //           ),
                                    //           TextField(
                                    //             keyboardType:
                                    //                 TextInputType.number,
                                    //             decoration:
                                    //                 const InputDecoration(
                                    //                     labelText:
                                    //                         "Security Code"),
                                    //             controller:
                                    //                 TextEditingController(
                                    //                     text: securityCode),
                                    //             onChanged: (value) {
                                    //               securityCode = value;
                                    //             },
                                    //           ),
                                    //           TextField(
                                    //             keyboardType:
                                    //                 TextInputType.name,
                                    //             decoration:
                                    //                 const InputDecoration(
                                    //                     labelText:
                                    //                         "Card Holder Name"),
                                    //             controller:
                                    //                 TextEditingController(
                                    //                     text: cardHolderName),
                                    //             onChanged: (value) {
                                    //               cardHolderName = value;
                                    //             },
                                    //           ),
                                    //         ],
                                    //       )
                                    //     : Column(),
                                    Padding(
                                      padding: EdgeInsets.all(5.w),
                                    ),
                                    ButtonWidget(
                                      onPressed: () async {
                                        // pay();
                                        if (selectedPaymentMethodIndex == -1) {
                                          setState(() {
                                            _response =
                                                "Please select payment method first";
                                          });
                                        } else {
                                          if (amount.isEmpty) {
                                            setState(() {
                                              _response = "Set the amount";
                                            });
                                          } else if (paymentMethods[
                                                  selectedPaymentMethodIndex]
                                              .isDirectPayment!) {
                                            if (cardNumber.isEmpty ||
                                                expiryMonth.isEmpty ||
                                                expiryYear.isEmpty ||
                                                securityCode.isEmpty)
                                              setState(() {
                                                _response =
                                                    "Fill all the card fields";
                                              });
                                            else {
                                              executeDirectPayment(paymentMethods[
                                                      selectedPaymentMethodIndex]
                                                  .paymentMethodId!);
                                              // UIHelper.showNotification(_response!);
                                            }
                                          } else {
                                            await executeRegularPayment(
                                                paymentMethods[
                                                        selectedPaymentMethodIndex]
                                                    .paymentMethodId!);
                                            setState(() {
                                              isAvailble = false;
                                              isVisible2 = false;
                                            });
                                          }
                                        }
                                      },
                                      title: 'Pay',
                                      textColor: AppColors.white,
                                      backgroundColor: AppColors.scadryColor,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(5.0),
                                    ),
                                    if (Platform.isIOS) createApplePayButton(),
                                  ]),
                            ),
                          ),
                        ])
                      : Container(),
            ),
          ],
        ),
      ),
    );
  }

  createApplePayButton() {
    mfApplePayButton = MFApplePayButton(height: 50.0);
    return mfApplePayButton;
  }
}
