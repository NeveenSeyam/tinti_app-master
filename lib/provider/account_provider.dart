import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import '../Util/constants/keys.dart';
import '../apis/auth/add_user_api.dart';
import '../apis/state/get_state_api.dart';
import '../apis/user_profile/edit_user_profile_api copy.dart';
import '../apis/user_profile/get_user_profile.dart';
import '../helpers/ui_helper.dart';

final accountProvider =
    ChangeNotifierProvider<AccountProvider>((ref) => AccountProvider());

class AccountProvider with ChangeNotifier {
  var userNameG = '';
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

//   Future postLogin({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final response = await LoginApi(
//         email: email,
//         password: password,
//       ).fetch();

//       log("checkTwoFactorTkoenCode $response");
//       // setActiveOffers(storeOffers);
//       userAuthModel = LoginModel.fromJson(response);

//       SharedPreferences prefs = await SharedPreferences.getInstance();

//       prefs.setString(
//           Keys.hasSaveUserData, json.encoder.convert(userAuthModel!.toJson()));
//       return true;
//     } on Failure catch (f) {
//       UIHelper.showNotification(f.message);
//       return false;
//     }
//   }

// // ==============================================
//   Future getStateRequset() async {
//     try {
//       List<StateModel> stateList = [];

//       final response = await GetStateApi().fetch();
//       print("get State REquset $response");

//       for (var state in response['states']) {
//         stateList.add(StateModel.fromJson(state));
//       }
//       setStateModel(stateList);

//       // setActiveOffers(storeOffers);
//       return true;
//     } on Failure catch (f) {
//       UIHelper.showNotification(f.message);
//       return false;
//     }
//   }

// =============================================

  // Future uploadUserPhoto({required XFile? imageFile}) async {
  //   String fileName = imageFile!.path.split('/').last;
  //   String pictureUrl = "";
  //   try {
  //     var dio = Dio(
  //       BaseOptions(
  //         baseUrl: ApiUrls.baseUrl,
  //         headers: {
  //           'Content-Type': 'multipart/form-data',
  //           'accept': 'application/json',
  //         },
  //         validateStatus: (status) {
  //           if (status == 500.511) {
  //             UIHelper.showNotification("Https server error");
  //             return false;
  //           } else if (status == 400.451) {
  //             UIHelper.showNotification("Failed to upload photo");

  //             return false;
  //           }
  //           return true;
  //         },
  //       ),
  //     );
  //     File _image = File(imageFile.path);
  //     var formData = FormData.fromMap({
  //       'UserName': userNameG,
  //       'Picture':
  //           await MultipartFile.fromFile(imageFile.path, filename: fileName),
  //     });
  //     final response =
  //         await dio.patch(ApiUrls.addUserProfilePicture, data: formData);
  //     print("response ${response.data}");

  //     try {
  //       UIHelper.showNotification("Photo Updated",
  //           backgroundColor: AppColors.green);
  //       pictureUrl = response.data['pictureUrl'];
  //       print(pictureUrl);
  //       return pictureUrl;
  //     } on Failure catch (f) {
  //       UIHelper.showNotification(f.message);
  //       UIHelper.showNotification("File is too large");
  //       return pictureUrl;
  //     }
  //   } on Failure catch (f) {
  //     UIHelper.showNotification(f.message);
  //     return false;
  //   }
  // }

  Future AactivateRequest() async {
    try {
      final response = await GetActivateApi().fetch();

      setActivateModel(ActivateModel.fromJson(response));

      return response;
    } on Failure catch (f) {
      UIHelper.showNotification(f.message);
      return false;
    }
  } // where  home page?>

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

  Future updateUserProfileRequset({
    required String fName,
    required String lName,
    required String email,
    required String phoneNumber,
    required String img,
    required String address,
  }) async {
    userNameG = fName;
    userEmail = email;
    userPhoneNumber = phoneNumber;

    try {
      final response = await EditUserProfile(
              email: email,
              img: img,
              address: address,
              phoneNumber: phoneNumber,
              fName: fName,
              lName: lName)
          .fetch();

      log("update profile $response");
      // setActiveOffers(storeOffers);
      return response;
    } on Failure catch (f) {
      UIHelper.showNotification(f.message);
      return false;
    }
  }

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
