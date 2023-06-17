import '../api_urls.dart';
import '../base_dio_api.dart';

class LoginApi extends BaseDioApi {
  String username;
  String password;

  LoginApi({
    required this.username,
    required this.password,
  }) : super(ApiUrls.login);

  @override
  body() {
    return {
      "username": username,
      "password": password,
    };
  }

  Future fetch() async {
    final response = await postRequest();
    return response;
  }
}
