import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tinti_app/apis/notification.dart';
import '../Models/notification_model.dart';
import '../helpers/failure.dart';

final notificationProvider = ChangeNotifierProvider<NotificationProvider>(
    (ref) => NotificationProvider());

class NotificationProvider extends ChangeNotifier {
  //! create the data object
  NotificationModel? _notificationList = NotificationModel();
//! create get method for the data object
  NotificationModel? get getDataList => _notificationList;
  void setDataList(NotificationModel notificationList) {
    _notificationList = notificationList;

    notifyListeners();
  }

  Future getNotificationsDataRequset() async {
    //! we create this object to set new data to the data object
    NotificationModel? notificationList = NotificationModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetNotificationDataApi().fetch();
      log("response $response");

      //! use FormJson method to convert the data to the data object
      notificationList = NotificationModel.fromJson(response);
      //! set the new data to the data object
      setDataList(notificationList);

      return notificationList;
    } on Failure catch (f) {
      return f;
    }
  }
}
