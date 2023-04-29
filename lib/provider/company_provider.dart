import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tinti_app/Models/single_company.dart';
import '../Models/companies/comany_model.dart';
import '../apis/companies/get_companies.dart';
import '../apis/companies/get_single_companies.dart';
import '../helpers/failure.dart';

final companyProvider =
    ChangeNotifierProvider<CompanyProvider>((ref) => CompanyProvider());

class CompanyProvider extends ChangeNotifier {
  //! create the data object
  CompanyModel? _companyList = CompanyModel();
//! create get method for the data object
  CompanyModel? get getCompanyDataList => _companyList;
  void setDataList(CompanyModel companyModel) {
    _companyList = companyModel;

    notifyListeners();
  }

  SingleCompanyModel? _companyModel = SingleCompanyModel();
//! create get method for the data object
  SingleCompanyModel? get getSingleCompanyDataList => _companyModel;
  void setSingleCompanyDataList(SingleCompanyModel SingleCompanyModel) {
    _companyModel = SingleCompanyModel;

    notifyListeners();
  }

  Future getCompanyDataRequset() async {
    //! we create this object to set new data to the data object
    CompanyModel? companiesList = CompanyModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetCampanyDataApi().fetch();
      log("response $response");

      //! use FormJson method to convert the data to the data object
      companiesList = CompanyModel.fromJson(response);
      //! set the new data to the data object
      setDataList(companiesList);

      return companiesList;
    } on Failure catch (f) {
      return f;
    }
  }

  Future getSingleCompanyDataRequset({required int id}) async {
    //! we create this object to set new data to the data object
    SingleCompanyModel? singleCompanyModel = SingleCompanyModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetSingleCampanyDataApi(id: id).fetch();
      log("response $response");

      //! use FormJson method to convert the data to the data object
      singleCompanyModel = SingleCompanyModel.fromJson(response);
      //! set the new data to the data object
      setSingleCompanyDataList(singleCompanyModel);

      return singleCompanyModel;
    } on Failure catch (f) {
      return f;
    }
  }
}
