import 'api_urls.dart';
import 'base_dio_api.dart';

class SentSmsOtp extends BaseDioApi {
  String lang;
  String userName;
  String apiKey;
  String number;
  dynamic userSender;

  SentSmsOtp({
    required this.lang,
    required this.userName,
    required this.apiKey,
    required this.userSender,
    required this.number,
  }) : super(ApiUrls.sent_otp);

  @override
  body() {
    return {
      "lang": lang,
      "userName": userName,
      "apiKey": apiKey,
      "number": number,
      "userSender": userSender
    };
  }

  Future fetch() async {
    final response = await postRequest();
    return response;
  }
}
