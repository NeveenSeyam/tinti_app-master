import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tinti_app/Models/auth/user_chang_profile_pass.dart';
import 'package:tinti_app/Models/state_model.dart';
import 'package:tinti_app/Modules/auth/activate.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/apis/auth/activate.dart';
import '../Apis/api_urls.dart';
import '../Apis/auth/login_api.dart';
import '../Helpers/failure.dart';
import '../Models/auth/profile_model.dart';
import '../Models/auth/user_model.dart';
import '../Models/change.dart';
import '../Models/forget_pass.dart';
import '../Util/constants/constants.dart';
import '../apis/auth/add_user_api.dart';
import '../apis/auth/change_password_api.dart';
import '../apis/auth/forget_password.dart';
import '../apis/user_profile/get_user_profile.dart';
import '../helpers/ui_helper.dart';

final accountProvider =
    ChangeNotifierProvider<AccountProvider>((ref) => AccountProvider());

class AccountProvider with ChangeNotifier {
  var userNameG = '';
  var password = '';
  var confirmPass = '';
  var userEmail = '';
  var userPhoneNumber = '';
  LoginModel? userAuthModel;
// * ===== State List =====
  List<StateModel>? _stateMdoelList;
  List<StateModel>? get getStateModelList => _stateMdoelList;

  setStateModel(List<StateModel> state) {
    _stateMdoelList = state;
  }

// * ===== State List =====

// * ===== User Profile =====
  ProfileModel? _profileModel;
  ProfileModel? get getProfileModel => _profileModel;

  setProfileModel(ProfileModel profile) {
    _profileModel = profile;
  }

  ActivateModel? _activateModel;
  ActivateModel? get getActivateModel => _activateModel;

  setActivateModel(ActivateModel activ) {
    _activateModel = activ;
  }

  ForgetPasswordDataModel? _forgetPasswordDataModel;
  ForgetPasswordDataModel? get getForgetPassModel => _forgetPasswordDataModel;

  setForgetPassModel(ForgetPasswordDataModel profile) {
    _forgetPasswordDataModel = profile;
  }

  changePasswordDataModel? _changeData;
  changePasswordDataModel? get getChangePassModel => _changeData;

  setChangePassModel(changePasswordDataModel change) {
    _changeData = change;
  }

// * ===== State List =====

  Future postRegisterUser({
    required String fName,
    required String lName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) async {
    userNameG = fName;
    userEmail = email;
    userPhoneNumber = phoneNumber;

    try {
      final response = await RgisterUser(
              confirmPassword: confirmPassword,
              email: email,
              password: password,
              phoneNumber: phoneNumber,
              fName: fName,
              lName: lName)
          .fetch();

      log("FirstSteop $response");
      // setActiveOffers(storeOffers);
      return response;
    } on DioError catch (e) {
      var message;
      e.response?.data['message'] != 'Validation Error.'
          ? message = 'تم تسجيل جديد بنجاح'
          : message = ' هناك مشكله  ';
      UIHelper.showNotification(message);

      log(' e.mmm  ${e.message} ${e.response?.data['message']}');
      return Failure;
    }
  }

  Future postLogin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await LoginApi(
        email: email,
        password: password,
      ).fetch();

      log("checkTwoFactorTkoenCode $response");

      // setActiveOffers(storeOffers);
      return response;
    } on Failure catch (f) {
      log("message ${f.message}");
      return false;
    }
  }

  Future AactivateRequest() async //required String image
  {
    try {
      Dio dio = Dio();

      var response = await dio.post(
        ApiUrls.changeUserPassword,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': "Bearer ${Constants.token}",
          },
        ),
      );
      if (response.statusCode == 200) {
        UIHelper.showNotification('تم تفعيل الحساب بنجاح',
            backgroundColor: AppColors.green);
      } else {
        UIHelper.showNotification('خطأ', backgroundColor: AppColors.red);
      }
      log("response $response");

      return response.data;
    } on DioError catch (e) {
      var message;
      e.response?.data['message'] != 'Validation Error.'
          ? message = 'تم التفعيل بنجاح'
          : message = 'خطأ';
      UIHelper.showNotification(message);

      log(' e.mmm  ${e.message} ${e.response?.data['message']}');
      return Failure;
    }
  }

  // Future getUserProfileRequset() async {
  //   try {
  //     final response = await GetUserProfile().fetch();

  //     setProfileModel(ProfileModel.fromJson(response));

  //     return response;
  //   } on Failure catch (f) {
  //     UIHelper.showNotification(f.message);
  //     return false;
  //   }
  // }

  Future getUserProfileRequset() async {
    //! we create this object to set new data to the data object
    ProfileModel? userList = ProfileModel();

    try {
      //! here we call the api and get the data using the Fetch method
      final response = await GetUserProfile().fetch();
      log("response $response");

      //! use FormJson method to convert the data to the data object
      userList = ProfileModel.fromJson(response);
      //! set the new data to the data object
      setProfileModel(userList);

      return response;
    } on Failure catch (f) {
      return f;
    }
  }

  Future editUserRequset({
    required Map<String, dynamic> data,
  }) async //required String image
  {
    String fileName = "";

    FormData formData = FormData.fromMap(data);

    try {
      Dio dio = new Dio();

      var response = await dio.post(
        ApiUrls.profileUpdate,
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

  Future editUserImageRequset(
      {required Map<String, dynamic> data,
      required File? file}) async //required String image
  {
    String fileName = "";
    if (file != null) fileName = file.path.split('/').last;

    if (file != null)
      data['img'] = await MultipartFile.fromFile(file.path, filename: fileName);
    FormData formData = FormData.fromMap(data);

    try {
      Dio dio = new Dio();

      var response = await dio.post(
        ApiUrls.profileUpdate,
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

  Future activateUserRequset() async //required String image
  {
    try {
      Dio dio = Dio();

      var response = await dio.post(
        ApiUrls.activate,
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

      return response;
    } on DioError catch (e) {
      UIHelper.showNotification(e.response?.data['message']);

      // log(e.message);
      return Failure;
    }
  }

  Future editProfilePasswordRequset({
    required Map<String, dynamic> data,
  }) async //required String image
  {
    FormData formData = FormData.fromMap(data);

    try {
      Dio dio = Dio();

      var response = await dio.post(
        ApiUrls.changeUserPassword,
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
        UIHelper.showNotification('تم تغيير كلمة المرور بنجاح',
            backgroundColor: AppColors.green);
      } else {
        UIHelper.showNotification('خطأ', backgroundColor: AppColors.red);
      }
      log("response $response");

      return response.data;
    } on DioError catch (e) {
      var message;
      e.response?.data['message'] != 'Validation Error.'
          ? message = 'تم تغيير كلمة السر بنجاح'
          : message = ' كلمة مرور غير مناسبة';
      // UIHelper.showNotification(message);
      log('eeeeeeeeeeeeeeeee ${e.response?.data['error'] ?? ''}');
      log(' e.mmm  ${e.error} ${e.response?.data['message']}');
      e.error == 'Http status error [404]'
          ? UIHelper.showNotification('كلمة مرور خاطئة',
              backgroundColor: AppColors.red)
          : null;
      return Failure;
    }
  }

  Future forgetPassRequest({
    required String email,
  }) async {
    ForgetPasswordDataModel? forgetList = ForgetPasswordDataModel();

    try {
      final response = await GetForgetPasswordApi(
        email: email,
      ).fetch();
      forgetList = ForgetPasswordDataModel.fromJson(response);

      log("checkTwoFactorTkoenCode $response");
      setForgetPassModel(forgetList);

      // setActiveOffers(storeOffers);
      return forgetList;
    } on Failure catch (f) {
      log("message ${f.message}");
      return false;
    }
  }

  // Future updatePass({
  //   required String email,
  //   required String password,
  // }) async {
  //   changePasswordDataModel? changeList = changePasswordDataModel();

  //   try {
  //     final response =
  //         await ChangePasswordApi(email: email, password: password).fetch();
  //     changeList = changePasswordDataModel.fromJson(response);

  //     log("check update $response");
  //     setChangePassModel(changeList);

  //     // setActiveOffers(storeOffers);
  //     return changeList;
  //   } on Failure catch (f) {
  //     log("message ${f.message}");
  //     return false;
  //   }
  // }

  Future updatePass({
    required Map<String, dynamic> data,
  }) async //required String image
  {
    FormData formData = FormData.fromMap(data);

    try {
      Dio dio = Dio();

      var response = await dio.post(
        ApiUrls.changePassword,
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
        UIHelper.showNotification('تم تغيير كلمة المرور بنجاح',
            backgroundColor: AppColors.green);
      } else {
        UIHelper.showNotification('خطأ', backgroundColor: AppColors.red);
      }
      log("response $response");

      return response.data;
    } on DioError catch (e) {
      var message;
      e.response?.data['message'] != 'Validation Error.'
          ? message = 'تم تغيير كلمة السر بنجاح'
          : message = ' كلمة مرور غير مناسبة';
      UIHelper.showNotification(message);

      log(' e.mmm  ${e.message} ${e.response?.data['message']}');
      return Failure;
    }
  }
}
