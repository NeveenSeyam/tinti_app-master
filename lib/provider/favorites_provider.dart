import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tinti_app/Models/favorites_model.dart';
import 'package:tinti_app/Models/orders_model.dart';
import 'package:tinti_app/apis/favorites/get_favorites_data_api.dart';

import '../helpers/failure.dart';

final favsProvider =
    ChangeNotifierProvider<FvorateProvider>((ref) => FvorateProvider());

class FvorateProvider extends ChangeNotifier {
  //! create the data object
  FavoritesModel? _favList = FavoritesModel();
//! create get method for the data object
  FavoritesModel? get getFavsDataList => _favList;
  void getFavsList(FavoritesModel favoritesModel) {
    _favList = favoritesModel;

    notifyListeners();
  }

  Future getFavsDataRequset() async {
    //! we create this object to set new data to the data object
    FavoritesModel? favProductModel = FavoritesModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetFavoritesDataApi().fetch();
      log("response $response");

      //! use FormJson method to convert the data to the data object
      favProductModel = FavoritesModel.fromJson(response);
      //! set the new data to the data object
      getFavsList(favProductModel);

      return favProductModel;
    } on Failure catch (f) {
      return f;
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
