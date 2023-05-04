import '../api_urls.dart';
import '../base_dio_api.dart';

class ChangePasswordApi extends BaseDioApi {
  String email;
  String password;

  ChangePasswordApi({
    required this.email,
    required this.password,
  }) : super(ApiUrls.changePassword);

  @override
  body() {
    return {'email': email, 'password': password};
  }

  Future fetch() async {
    final response = await postRequest();
    return response;
  }
}
