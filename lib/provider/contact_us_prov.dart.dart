import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Apis/auth/get_data_api.dart';
import '../Models/user car/car_model.dart';
import '../apis/contact_us_post.dart';
import '../apis/user_cars/add_user_car_api.dart';
import '../apis/user_cars/get_user_cars_data_api.dart';
import '../helpers/failure.dart';
import '../helpers/ui_helper.dart';

final contactUsProvider =
    ChangeNotifierProvider<ContactUsProvider>((ref) => ContactUsProvider());

class ContactUsProvider extends ChangeNotifier {
  //! create the data object
  CarModel? _carList = CarModel();
//! create get method for the data object
  CarModel? get getDataList => _carList;
  void setDataList(CarModel carList) {
    _carList = carList;

    notifyListeners();
  }

  Future postCountact({
    required String email,
    required String name,
    required String address,
    required String text,
  }) async {
    try {
      final response = await GetContactUsDataApi(
              email: email, name: name, address: address, mcontent: text)
          .fetch();

      log("FirstSteop $response");
      // setActiveOffers(storeOffers);
      return response;
    } on DioError catch (e) {
      var message;
      e.response?.data['message'] != 'Validation Error.'
          ? message = 'تم تسجيل جديد بنجاح'
          : message = ' هناك مشكله  ';
      UIHelper.showNotification(message);

      log(' e.mmm  ${e.message} ${e.response?.data['message']}');
      return Failure;
    }
  }

  // Future postCarDataRequset({required String name, required String email}) async {
  //   //! we create this object to set new data to the data object
  //   CarModel? carList = CarModel();

  //   try {
  //     //! here we call the api and get the data using the Fetch method
  //     final response = await AddUserCar(
  //     name:name
  //     ).fetch();
  //     //! use FormJson method to convert the data to the data object
  //     contentList = DataModel.fromJson(response);
  //     log("response $response");
  //     //! set the new data to the data object
  //     setDataList(contentList);

  //     return contentList;
  //   } on Failure catch (f) {
  //     return f;
  //   }
  // }
}
