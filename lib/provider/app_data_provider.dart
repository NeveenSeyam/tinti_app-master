import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tinti_app/apis/notification.dart';
import '../Models/app_data_model.dart';
import '../Models/intro_model.dart';
import '../Models/notification_model.dart';
import '../apis/app_info.dart';
import '../apis/intro.dart';
import '../helpers/failure.dart';

final appDataProvider =
    ChangeNotifierProvider<AppDataProvider>((ref) => AppDataProvider());

class AppDataProvider extends ChangeNotifier {
  //! create the data object
  AppDataModel? _dataList = AppDataModel();
//! create get method for the data object
  AppDataModel? get getDataList => _dataList;
  void setDataList(AppDataModel introList) {
    _dataList = introList;

    notifyListeners();
  }

  Future getAppDataRequset() async {
    //! we create this object to set new data to the data object
    AppDataModel? appDataModelList = AppDataModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetAppDataApi().fetch();
      log("response $response");

      //! use FormJson method to convert the data to the data object
      appDataModelList = AppDataModel.fromJson(response);
      //! set the new data to the data object
      setDataList(appDataModelList);

      return appDataModelList;
    } on Failure catch (f) {
      return f;
    }
  }
}
