import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tinti_app/apis/notification.dart';
import '../Models/intro_model.dart';
import '../Models/notification_model.dart';
import '../apis/intro.dart';
import '../helpers/failure.dart';

final introProvider =
    ChangeNotifierProvider<IntroProvider>((ref) => IntroProvider());

class IntroProvider extends ChangeNotifier {
  //! create the data object
  IntroModel? _introList = IntroModel();
//! create get method for the data object
  IntroModel? get getDataList => _introList;
  void setDataList(IntroModel introList) {
    _introList = introList;

    notifyListeners();
  }

  Future getIntroDataRequset() async {
    //! we create this object to set new data to the data object
    IntroModel? introModelList = IntroModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetIntroDataApi().fetch();
      log("response $response");

      //! use FormJson method to convert the data to the data object
      introModelList = IntroModel.fromJson(response);
      //! set the new data to the data object
      setDataList(introModelList);

      return introModelList;
    } on Failure catch (f) {
      return f;
    }
  }
}
