import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tinti_app/apis/services_api.dart';
import '../Models/services_model.dart';
import '../Models/user car/car_model.dart';
import '../apis/user_cars/get_user_cars_data_api.dart';
import '../helpers/failure.dart';

final servicesProvider =
    ChangeNotifierProvider<ServicesProvider>((ref) => ServicesProvider());

class ServicesProvider extends ChangeNotifier {
  //! create the data object
  ServicesModel? _servicesList = ServicesModel();
//! create get method for the data object
  ServicesModel? get getDataList => _servicesList;
  void setDataList(ServicesModel servicesList) {
    _servicesList = servicesList;

    notifyListeners();
  }

  Future getServiecesDataRequset() async {
    //! we create this object to set new data to the data object
    ServicesModel? servicesList = ServicesModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetServicesDataApi().fetch();
      log("response $response");

      //! use FormJson method to convert the data to the data object
      servicesList = ServicesModel.fromJson(response);
      //! set the new data to the data object
      setDataList(servicesList);

      return servicesList;
    } on Failure catch (f) {
      return f;
    }
  }
}
