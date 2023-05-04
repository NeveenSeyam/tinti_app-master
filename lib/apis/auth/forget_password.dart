//forgotPasswordUrl
import '../api_urls.dart';
import '../base_dio_api.dart';

class GetForgetPasswordApi extends BaseDioApi {
  final String email;
  String? name;
  String? mobile;
  GetForgetPasswordApi({
    required this.email,
  }) : super(ApiUrls.forgetPassword);

  @override
  body() {
    return {
      'email': this.email,
      // 'name': this.name,
      // 'mobile': this.mobile,
    };
  }

  Future fetch() async {
    final response = await postRequest();
    return response;
  }
}
