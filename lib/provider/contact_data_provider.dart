import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tinti_app/apis/notification.dart';
import '../Models/app_data_model.dart';
import '../Models/contact_model.dart';
import '../Models/intro_model.dart';
import '../Models/notification_model.dart';
import '../apis/app_info.dart';
import '../apis/contact_api.dart';
import '../apis/intro.dart';
import '../helpers/failure.dart';

final contactDataProvider =
    ChangeNotifierProvider<ContactDataProvider>((ref) => ContactDataProvider());

class ContactDataProvider extends ChangeNotifier {
  //! create the data object
  ContactDataModel? _cntactList = ContactDataModel();
//! create get method for the data object
  ContactDataModel? get getContactDataList => _cntactList;
  void setContactDataList(ContactDataModel introList) {
    _cntactList = introList;

    notifyListeners();
  }

  Future getContactDataRequset() async {
    //! we create this object to set new data to the data object
    ContactDataModel? appContactDataModelList = ContactDataModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetContactDataApi().fetch();
      log("response $response");

      //! use FormJson method to convert the data to the data object
      appContactDataModelList = ContactDataModel.fromJson(response);
      //! set the new data to the data object
      setContactDataList(appContactDataModelList);

      return appContactDataModelList;
    } on Failure catch (f) {
      return f;
    }
  }
}
