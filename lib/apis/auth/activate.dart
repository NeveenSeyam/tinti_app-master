import '../api_urls.dart';
import '../base_dio_api.dart';

class GetActivateApi extends BaseDioApi {
  GetActivateApi() : super(ApiUrls.activate);
  @override
  body() {
    return {};
  }

  Future fetch() async {
    final response = await postRequest();
    return response;
  }
}
