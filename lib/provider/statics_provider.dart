import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tinti_app/Models/single_company.dart';
import 'package:tinti_app/Models/statics/cites_model.dart';
import '../Models/companies/comany_model.dart';
import '../Models/statics/car_model.dart';
import '../Models/statics/car_model_types_model.dart';
import '../Models/statics/regions_model.dart';
import '../Models/statics/sizes.dart';
import '../apis/car model and size/car_api.dart';
import '../apis/car model and size/car_model_types_api.dart';
import '../apis/car model and size/size_api.dart';
import '../apis/companies/get_companies.dart';
import '../apis/companies/get_single_companies.dart';
import '../apis/regions and cities/cities_api.dart';
import '../apis/regions and cities/regions_api.dart';
import '../helpers/failure.dart';

final staticsProvider =
    ChangeNotifierProvider<StaticsProvider>((ref) => StaticsProvider());

class StaticsProvider extends ChangeNotifier {
  //! create the data object
  CarModel2? _carList = CarModel2();
//! create get method for the data object
  CarModel2? get getCarsDataList => _carList;
  void setDataList(CarModel2 companyModel) {
    _carList = companyModel;

    notifyListeners();
  }

  CarModelTaypesModel? _carModelTypesList = CarModelTaypesModel();
//! create get method for the data object
  CarModelTaypesModel? get getCarModelTypesDataList => _carModelTypesList;
  void setCarModelTypesDataList(CarModelTaypesModel carModelTypes) {
    _carModelTypesList = carModelTypes;

    notifyListeners();
  }

  Future getCarsDataRequset() async {
    //! we create this object to set new data to the data object
    CarModel2? carList = CarModel2();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetCarsDataApi().fetch();
      log("response $response");

      //! use FormJson method to convert the data to the data object
      carList = CarModel2.fromJson(response);
      //! set the new data to the data object
      setDataList(carList);

      return carList;
    } on Failure catch (f) {
      return f;
    }
  }

  Future getCarModelTypesDataRequset({required id}) async {
    //! we create this object to set new data to the data object
    CarModelTaypesModel? carModelTypesList = CarModelTaypesModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetCarModelTypesDataApi(id: id).fetch();
      log("response $response");

      //! use FormJson method to convert the data to the data object
      carModelTypesList = CarModelTaypesModel.fromJson(response);
      //! set the new data to the data object
      setCarModelTypesDataList(carModelTypesList);

      return carModelTypesList;
    } on Failure catch (f) {
      return f;
    }
  }

  CitesModel? _citiesList = CitesModel();
//! create get method for the data object
  CitesModel? get getCitiesDataList => _citiesList;
  void setCitiesDataList(CitesModel companyModel) {
    _citiesList = companyModel;

    notifyListeners();
  }

  Future getCtiesDataRequset({required id}) async {
    //! we create this object to set new data to the data object
    CitesModel? cittiesList = CitesModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetCitiesDataApi(id: id).fetch();
      log("response $response");

      //! use FormJson method to convert the data to the data object
      cittiesList = CitesModel.fromJson(response);
      //! set the new data to the data object
      setCitiesDataList(cittiesList);

      return cittiesList;
    } on Failure catch (f) {
      return f;
    }
  }

  RegionsModel? _regonsList = RegionsModel();
//! create get method for the data object
  RegionsModel? get getRegiosDataList => _regonsList;
  void setRegionsDataList(RegionsModel companyModel) {
    _regonsList = companyModel;

    notifyListeners();
  }

  Future getRegionsDataRequset() async {
    //! we create this object to set new data to the data object
    RegionsModel? regionsList = RegionsModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetRegionsDataApi().fetch();
      log("response $response");

      //! use FormJson method to convert the data to the data object
      regionsList = RegionsModel.fromJson(response);
      //! set the new data to the data object
      setRegionsDataList(regionsList);

      return regionsList;
    } on Failure catch (f) {
      return f;
    }
  }

  SizesModel? _sizesList = SizesModel();
//! create get method for the data object
  SizesModel? get getSizessDataList => _sizesList;
  void setSizessDataList(SizesModel sizeModel) {
    _sizesList = sizeModel;

    notifyListeners();
  }

  Future getSizesDataRequset({required id}) async {
    //! we create this object to set new data to the data object
    SizesModel? sizesList = SizesModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetSizeDataApi(id: id).fetch();
      log("response $response");

      //! use FormJson method to convert the data to the data object
      sizesList = SizesModel.fromJson(response);
      //! set the new data to the data object
      setSizessDataList(sizesList);

      return sizesList;
    } on Failure catch (f) {
      return f;
    }
  }
}
