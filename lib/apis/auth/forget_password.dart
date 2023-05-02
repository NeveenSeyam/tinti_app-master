//forgotPasswordUrl
import '../api_urls.dart';
import '../base_dio_api.dart';

class GetForgetPasswordApi extends BaseDioApi {
  final String email;
  GetForgetPasswordApi({required this.email}) : super(ApiUrls.forgetPassword);

  @override
  body() {
    return {
      'email': this.email,
    };
  }

  Future fetch() async {
    final response = await postRequest();
    return response;
  }
}
