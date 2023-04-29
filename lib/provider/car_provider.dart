import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Apis/auth/get_data_api.dart';
import '../Models/user car/car_model.dart';
import '../apis/user_cars/add_user_car_api.dart';
import '../apis/user_cars/get_user_cars_data_api.dart';
import '../helpers/failure.dart';

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

//   Future postCarDataRequset({required String name, required String email}) async {
//     //! we create this object to set new data to the data object
//     DataModel? contentList = DataModel();

//     try {
//       //! here we call the api and get the data using the Fetch method
//       final response = await AddUserCar(
//       name:name
//       ).fetch();
//       //! use FormJson method to convert the data to the data object
//       contentList = DataModel.fromJson(response);
//       log("response $response");
//       //! set the new data to the data object
//       setDataList(contentList);

//       return contentList;
//     } on Failure catch (f) {
//       return f;
//     }
//   }
}
