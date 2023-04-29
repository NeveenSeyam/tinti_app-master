import '../api_urls.dart';
import '../base_dio_api.dart';

class RgisterUser extends BaseDioApi {
  String fName;
  String lName;
  String email;
  String phoneNumber;
  String password;
  String confirmPassword;

  RgisterUser({
    required this.fName,
    required this.lName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  }) : super(ApiUrls.register);

  @override
  body() {
    return {
      "fname": fName,
      "lname": lName,
      "email": email,
      "mobile": phoneNumber,
      "password": password,
      "c_password": confirmPassword
    };
  }

  Future fetch() async {
    final response = await postRequest();
    return response;
  }
}
