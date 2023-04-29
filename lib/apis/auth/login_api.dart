import '../api_urls.dart';
import '../base_dio_api.dart';

class LoginApi extends BaseDioApi {
  String email;
  String password;

  LoginApi({
    required this.email,
    required this.password,
  }) : super(ApiUrls.login);

  @override
  body() {
    return {
      "email": email,
      "password": password,
    };
  }

  Future fetch() async {
    final response = await postRequest();
    return response;
  }
}
