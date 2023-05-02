import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tinti_app/Models/product/service_products_model.dart';
import 'package:tinti_app/Models/product/single_product_model.dart';
import 'package:tinti_app/apis/favorites/add_favorite_api.dart';
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
import '../apis/favorites/remove_favorite_api.dart';
import '../apis/products/get_all_product.dart';
import '../apis/products/get_product_by_company.dart';
import '../apis/products/get_product_by_servies.dart';
import '../apis/user_cars/add_user_car_api.dart';
import '../apis/user_cars/get_user_cars_data_api.dart';
import '../helpers/failure.dart';
import '../helpers/ui_helper.dart';

final productsProvider =
    ChangeNotifierProvider<ProductsProvider>((ref) => ProductsProvider());

class ProductsProvider extends ChangeNotifier {
  //! create the data object
  ProductModel? _productList = ProductModel();
//! create get method for the data object
  ProductModel? get getProductsDataList => _productList;
  void setDataList(ProductModel productModel) {
    _productList = productModel;

    notifyListeners();
  }

  //==============
  //! create the data object
  ProductModel? _productSellsList = ProductModel();
//! create get method for the data object
  ProductModel? get getProductsSellsDataList => _productSellsList;
  void setDataSellsList(ProductModel productModel) {
    _productSellsList = productModel;

    notifyListeners();
  }

// =========
  ServiceProductModel? _productsBySirvesList = ServiceProductModel();
//! create get method for the data object
  ServiceProductModel? get getProductsSirvesDataList => _productsBySirvesList;
  void setDataSirvesList(ServiceProductModel serviceProductModel) {
    _productsBySirvesList = serviceProductModel;

    notifyListeners();
  }

// =========
  CompanyProductModel? _productsByCompanyList = CompanyProductModel();
//! create get method for the data object
  CompanyProductModel? get getProductsCompanyDataList => _productsByCompanyList;
  void setDataCompanyList(CompanyProductModel companyProductModel) {
    _productsByCompanyList = companyProductModel;

    notifyListeners();
  }

// =========
  SingleProductModel? _singleProductModel = SingleProductModel();
//! create get method for the data object
  SingleProductModel? get getSingleProduct => _singleProductModel;
  void setSingleProductList(SingleProductModel singleProductModel) {
    _singleProductModel = singleProductModel;

    notifyListeners();
  }

  Future getProductDataByServisesRequset({required int id}) async {
    //! we create this object to set new data to the data object
    ServiceProductModel? serviceProductModel = ServiceProductModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetProductByServisesApi(id: id).fetch();
      log("response $response");

      //! use FormJson method to convert the data to the data object
      serviceProductModel = ServiceProductModel.fromJson(response);
      //! set the new data to the data object
      setDataSirvesList(serviceProductModel);

      return serviceProductModel;
    } on Failure catch (f) {
      return f;
    }
  }

  Future getProductDataByCompanyRequsett({required int id}) async {
    //! we create this object to set new data to the data object
    CompanyProductModel? productList = CompanyProductModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetProductByCompanyApi(id: id.toString()).fetch();
      log("response getProductDataByCompanyRequsett $response");

      //! use FormJson method to convert the data to the data object
      productList = CompanyProductModel.fromJson(response);
      //! set the new data to the data object
      setDataCompanyList(productList);

      return productList;
    } on Failure catch (f) {
      return f;
    }
  }

  Future getAllProductDataRequset() async {
    //! we create this object to set new data to the data object
    ProductModel? productList = ProductModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetProductsDataApi().fetch();
      log("response $response");

      //! use FormJson method to convert the data to the data object
      productList = ProductModel.fromJson(response);
      //! set the new data to the data object
      setDataList(productList);

      return productList;
    } on Failure catch (f) {
      return f;
    }
  }

  Future getSalesProductDataRequset() async {
    //! we create this object to set new data to the data object
    ProductModel? productList = ProductModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetSalesProductsDataApi().fetch();
      log("GetSalesProductsDataApi $response");

      //! use FormJson method to convert the data to the data object
      productList = ProductModel.fromJson(response);
      //! set the new data to the data object
      setDataSellsList(productList);

      return productList;
    } on Failure catch (f) {
      return f;
    }
  }

  Future getSingleProductDataRequset({required int id}) async {
    //! we create this object to set new data to the data object
    SingleProductModel? productList = SingleProductModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetSingleProductDataApi(id: id.toString()).fetch();
      log("response getProductDataByCompanyRequsett $response");

      //! use FormJson method to convert the data to the data object
      productList = SingleProductModel.fromJson(response);
      //! set the new data to the data object
      setSingleProductList(productList);

      return response;
    } on Failure catch (f) {
      return f;
    }
  }
}
