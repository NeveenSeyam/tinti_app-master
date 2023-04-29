import '../api_urls.dart';
import '../base_dio_api.dart';

class GetStateApi extends BaseDioApi {
  GetStateApi() : super(ApiUrls.activate);
  @override
  body() {
    return {};
  }

  Future fetch() async {
    final response = await getRequest();
    return response;
  }
}
