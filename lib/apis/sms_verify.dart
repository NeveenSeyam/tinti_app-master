import 'api_urls.dart';
import 'base_dio_api.dart';

class VerifySmsOtp extends BaseDioApi {
  String lang;
  String userName;
  String apiKey;
  dynamic code;
  dynamic id;
  dynamic userSender;

  VerifySmsOtp({
    required this.lang,
    required this.userName,
    required this.apiKey,
    required this.code,
    required this.id,
    required this.userSender,
  }) : super(ApiUrls.verify_otp);

  @override
  body() {
    return {
      "lang": lang,
      "userName": userName,
      "apiKey": apiKey,
      "code": code,
      "id": id,
      "userSender": userSender
    };
  }

  Future fetch() async {
    final response = await postRequest();
    return response;
  }
}
