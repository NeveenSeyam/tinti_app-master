import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tinti_app/Models/orders_model.dart';

import 'package:tinti_app/apis/orders/get_user_order_data_api.dart';

import '../Apis/api_urls.dart';
import '../Models/product/single_order_model.dart';
import '../Util/constants/constants.dart';
import '../Util/theme/app_colors.dart';

import '../apis/orders/order_api.dart';
import '../apis/orders/ratting_api.dart';
import '../helpers/failure.dart';
import '../helpers/ui_helper.dart';

final ordersProvider =
    ChangeNotifierProvider<OrderProvider>((ref) => OrderProvider());

class OrderProvider extends ChangeNotifier {
  //! create the data object
  OrdeModel? _orderSellsList = OrdeModel();
  dynamic order_id = '';

//! create get method for the data object
  OrdeModel? get getOrdersDataList => _orderSellsList;
  void getDataSellsList(OrdeModel ordeModel) {
    _orderSellsList = ordeModel;

    notifyListeners();
  }

  OrderDetailsModel? _singleOrderModel = OrderDetailsModel();
//! create get method for the data object
  OrderDetailsModel? get getSingleOrder => _singleOrderModel;
  void setSingleOrderList(OrderDetailsModel singleOrderModel) {
    _singleOrderModel = singleOrderModel;

    notifyListeners();
  }
// =========
//   SingleProductModel? _singleProductModel = SingleProductModel();
// //! create get method for the data object
//   SingleProductModel? get getSingleProduct => _singleProductModel;
//   void setSingleProductList(SingleProductModel singleProductModel) {
//     _singleProductModel = singleProductModel;

//     notifyListeners();
//   }

  Future getOrderDataRequset() async {
    //! we create this object to set new data to the data object
    OrdeModel? orderProductModel = OrdeModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetordersDataApi().fetch();
      log("response $response");

      //! use FormJson method to convert the data to the data object
      orderProductModel = OrdeModel.fromJson(response);
      //! set the new data to the data object
      getDataSellsList(orderProductModel);

      return orderProductModel;
    } on Failure catch (f) {
      return f;
    }
  }

  Future addOrderRequset(
      {required Map<String, dynamic> data}) async //required String image
  {
    FormData formData = FormData.fromMap(data);

    try {
      Dio dio = new Dio();
      formData.fields.forEach((element) {
        log("formData ${element.key}    ${element.value}");
      });
      var response = await dio.post(
        ApiUrls.addOrders,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': "Bearer ${Constants.token}",
            'Accept-Language': '${Constants.lang}',
          },
        ),
      );
      if (response.statusCode == 200) {
        UIHelper.showNotification(response.data['message'],
            backgroundColor: AppColors.green);
        order_id = response.data['data']['order_id'];
      }
      log("response $response");
      return response;
    } on DioError catch (e) {
      UIHelper.showNotification(e.response?.data['message']);

      // log(e.message);
      return false;
    }
  }

  Future activeOrderRequset({required id}) async //required String image
  {
    try {
      Dio dio = new Dio();

      var response = await dio.post(
        ApiUrls.activeOrders(id: id),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': "Bearer ${Constants.token}",
            'Accept-Language': '${Constants.lang}',
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
      return false;
    }
  }
  // Future getSingleProductDataRequset({required int id}) async {
  //   //! we create this object to set new data to the data object
  //   SingleProductModel? productList = SingleProductModel();

  //   try {
  //     //! here we call the api and get the data using the Fetch method
  //     final response = await GetSingleProductDataApi(id: id.toString()).fetch();
  //     log("response getProductDataByCompanyRequsett $response");

  //     //! use FormJson method to convert the data to the data object
  //     productList = SingleProductModel.fromJson(response);
  //     //! set the new data to the data object
  //     setSingleProductList(productList);

  //     return response;
  //   } on Failure catch (f) {
  //     return f;
  //   }
  // }

  Future getSingleOrderDataRequset({required int id}) async {
    //! we create this object to set new data to the data object
    OrderDetailsModel? productList = OrderDetailsModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetSingleOrdersDataApi(id: id.toString()).fetch();
      log("response getProductDataByCompanyRequsett $response");

      //! use FormJson method to convert the data to the data object
      productList = OrderDetailsModel.fromJson(response);
      //! set the new data to the data object
      setSingleOrderList(productList);

      return response;
    } on Failure catch (f) {
      return f;
    }
  }

  Future addRateDataRequset(
      {required id, required comments, required star_rating}) async {
    //! we create this object to set new data to the data object

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await AddRate(
        order_id: id.toString(),
        comments: comments,
        star_rating: star_rating,
      ).fetch();
      log("response getProductDataByCompanyRequsett $response");

      //! use FormJson method to convert the data to the data object

      return response;
    } on Failure catch (f) {
      return f;
    }
  }
}
