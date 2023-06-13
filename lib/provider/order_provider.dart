import 'dart:developer';
import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tinti_app/Models/orders_model.dart';
import 'package:tinti_app/Models/product/service_products_model.dart';
import 'package:tinti_app/Models/product/single_product_model.dart';
import 'package:tinti_app/apis/orders/get_user_order_data_api.dart';
import 'package:tinti_app/apis/products/get_sale_product.dart';
import 'package:tinti_app/apis/products/get_single_product.dart';

import '../Apis/api_urls.dart';
import '../Apis/auth/get_data_api.dart';
import '../Models/companies/comany_model.dart';
import '../Models/product/company_products_model copy.dart';
import '../Models/product/sales_products_model.dart';
import '../Models/user car/car_model.dart';
import '../Util/constants/constants.dart';
import '../Util/theme/app_colors.dart';
import '../apis/companies/get_companies.dart';
import '../apis/products/get_all_product.dart';
import '../apis/products/get_product_by_company.dart';
import '../apis/products/get_product_by_servies.dart';
import '../apis/user_cars/add_user_car_api.dart';
import '../apis/user_cars/get_user_cars_data_api.dart';
import '../helpers/failure.dart';
import '../helpers/ui_helper.dart';

final ordersProvider =
    ChangeNotifierProvider<OrderProvider>((ref) => OrderProvider());

class OrderProvider extends ChangeNotifier {
  //! create the data object
  OrdeModel? _orderSellsList = OrdeModel();
//! create get method for the data object
  OrdeModel? get getOrdersDataList => _orderSellsList;
  void getDataSellsList(OrdeModel ordeModel) {
    _orderSellsList = ordeModel;

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
}
