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
import '../Util/constants/constants.dart';
import '../apis/auth/add_user_api.dart';
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
    } on Failure catch (f) {
      UIHelper.showNotification(f.message);
      return false;
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

  Future AactivateRequest2() async {
    try {
      final response = await GetActivateApi().fetch();

      setActivateModel(ActivateModel.fromJson(response));

      return response;
    } on Failure catch (f) {
      UIHelper.showNotification(f.message);
      return false;
    }
  } // where  home page?>

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

  Future getUserProfileRequset() async {
    try {
      final response = await GetUserProfile().fetch();

      setProfileModel(ProfileModel.fromJson(response));

      return response;
    } on Failure catch (f) {
      UIHelper.showNotification(f.message);
      return false;
    }
  } // where  home page?>

  // Future updateUserProfileRequset({
  //   required String fName,
  //   required String lName,
  //   required String email,
  //   required String phoneNumber,
  //   required String img,
  //   required String address,
  // }) async {
  //   userNameG = fName;
  //   userEmail = email;
  //   userPhoneNumber = phoneNumber;

  //   try {
  //     final response = await EditUserProfile(
  //             email: email,
  //             img: img,
  //             address: address,
  //             phoneNumber: phoneNumber,
  //             fName: fName,
  //             lName: lName)
  //         .fetch();

  //     log("update profile $response");
  //     // setActiveOffers(storeOffers);
  //     return response;
  //   } on Failure catch (f) {
  //     UIHelper.showNotification(f.message);
  //     return false;
  //   }
  // }

  // edit user info  with image mlutform
  Future editUserRequset(
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

  // Future updateUserPasswordRequset({
  //   required String email,
  //   required String password,
  //   required String confirm,
  // }) async {
  //   password = email;
  //   confirmPass = email;
  //   userPhoneNumber = confirm;

  //   try {
  //     final response =
  //         await ChangePasswordApi(email: email, password: password).fetch();

  //     log("update password $response");
  //     // setActiveOffers(storeOffers);
  //     return response;
  //   } on Failure catch (f) {
  //     UIHelper.showNotification(f.message);
  //     return false;
  //   }
  // }

  // edit user info  with image mlutform
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
      UIHelper.showNotification(message);

      log(' e.mmm  ${e.message} ${e.response?.data['message']}');
      return Failure;
    }
  }

  // Future getForgetPasswordApiRequset({required String email}) async {
  //   try {
  //     await GetForgetPasswordApi(email: email).fetch();

  //     return true;
  //   } on Failure catch (f) {
  //     UIHelper.showNotification(f.message);
  //     return false;
  //   }
  // }
}
