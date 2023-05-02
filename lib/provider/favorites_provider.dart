import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tinti_app/Models/favorites_model.dart';
import 'package:tinti_app/Models/orders_model.dart';
import 'package:tinti_app/apis/favorites/get_favorites_data_api.dart';

import '../Models/product/service_products_model.dart';
import '../apis/favorites/add_favorite_api.dart';
import '../apis/favorites/remove_favorite_api.dart';
import '../helpers/failure.dart';
import '../helpers/ui_helper.dart';

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

  Future addFavRequset({
    required id,
  }) async //required String image
  {
    try {
      final response = await AddFav(product_id: id).fetch();

      log("FirstSteop $response");
      // setActiveOffers(storeOffers);
      return response;
    } on Failure catch (f) {
      UIHelper.showNotification(f.message);
      return false;
    }
  }

  Future removeFavRequset({
    required id,
  }) async //required String image
  {
    try {
      final response = await RemoveFav(product_id: id).fetch();

      log("FirstSteop $response");
      // serviceProductModel = ServiceProductModel.fromJson(response);
      // //! set the new data to the data object
      // setDataSirvesList(serviceProductModel);
      // setActiveOffers(storeOffers);
      return response;
    } on Failure catch (f) {
      UIHelper.showNotification(f.message);
      return false;
    }
  }
}
