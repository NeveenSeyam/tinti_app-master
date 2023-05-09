import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tinti_app/Models/auth/user_chang_profile_pass.dart';
import 'package:tinti_app/Models/state_model.dart';
import 'package:tinti_app/Modules/auth/activate.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/apis/auth/activate.dart';
import 'package:tinti_app/apis/user_cars/edit_user_car_api%20copy.dart';
import '../Apis/api_urls.dart';
import '../Apis/auth/login_api.dart';
import '../Helpers/failure.dart';
import '../Models/auth/profile_model.dart';
import '../Models/auth/user_model.dart';
import '../Models/change.dart';
import '../Models/forget_pass.dart';
import '../Models/user car/car_model.dart';
import '../Util/constants/constants.dart';
import '../apis/auth/add_user_api.dart';
import '../apis/auth/change_password_api.dart';
import '../apis/auth/forget_password.dart';
import '../apis/user_cars/add_user_car_api.dart';
import '../apis/user_cars/delete_user_car_api.dart';
import '../apis/user_cars/get_user_cars_data_api.dart';
import '../apis/user_profile/get_user_profile.dart';
import '../helpers/ui_helper.dart';

final carProvider = ChangeNotifierProvider<CarProvider>((ref) => CarProvider());

class CarProvider extends ChangeNotifier {
  //! create the data object
  CarModel? _carList = CarModel();
//! create get method for the data object
  CarModel? get getDataList => _carList;
  void setDataList(CarModel carList) {
    _carList = carList;

    notifyListeners();
  }

  Future getCarDataRequset() async {
    //! we create this object to set new data to the data object
    CarModel? carList = CarModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetCarDataApi().fetch();
      log("response $response");

      //! use FormJson method to convert the data to the data object
      carList = CarModel.fromJson(response);
      //! set the new data to the data object
      setDataList(carList);

      return response;
    } on Failure catch (f) {
      return f;
    }
  }

  Future editCarRequset(
      {required Map<String, dynamic> data,
      required id,
      required File? file}) async //required String image
  {
    String fileName = "";
    if (file != null) fileName = file.path.split('/').last;

    if (file != null) {
      data['image'] =
          await MultipartFile.fromFile(file.path, filename: fileName);
    }
    FormData formData = FormData.fromMap(data);
    formData.fields.forEach((element) {
      log("formData ${element.key}    ${element.value}");
    });
    try {
      Dio dio = new Dio();
      log("editCars ${ApiUrls.editCars(id: id)}");
      var response = await dio.post(
        ApiUrls.editCars(id: id),
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': "Bearer ${Constants.token}",
          },
        ),
      );
      if (response.statusCode == 200) {
        UIHelper.showNotification(response.data['message'],
            backgroundColor: AppColors.green);
      }
      log("response $response");

      return response.data;
    } on DioError catch (e) {
      UIHelper.showNotification(" ${e.response}");

      log(e.message);
      return Failure;
    }
  }

  Future addCarRequset(
      {required Map<String, dynamic> data,
      required File? file}) async //required String image
  {
    String fileName = "";
    if (file != null) fileName = file.path.split('/').last;

    if (file != null) {
      data['image'] =
          await MultipartFile.fromFile(file.path, filename: fileName);
    }
    FormData formData = FormData.fromMap(data);

    try {
      Dio dio = new Dio();
      formData.fields.forEach((element) {
        log("formData ${element.key}    ${element.value}");
      });
      var response = await dio.post(
        ApiUrls.addcars,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': "Bearer ${Constants.token}",
          },
        ),
      );
      if (response.statusCode == 200) {
        UIHelper.showNotification(response.data['message'],
            backgroundColor: AppColors.green);
      }
      log("response $response");

      return response.data;
    } on DioError catch (e) {
      UIHelper.showNotification(e.response?.data['message']);

      // log(e.message);
      return Failure;
    }
  }

  Future removeCarRequset({
    required id,
  }) async //required String image
  {
    try {
      final response = await DeleteUserCar(id: id).fetch();

      log("FirstSteop $response");
      // serviceProductModel = ServiceProductModel.fromJson(response);
      // //! set the new data to the data object
      // setDataSirvesList(serviceProductModel);
      // setActiveOffers(storeOffers);
      return response;
    } on Failure catch (f) {
      UIHelper.showNotification(f.message);
      return false;
    }
  }
}
