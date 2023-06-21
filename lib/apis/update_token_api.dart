import 'api_urls.dart';
import 'base_dio_api.dart';

class UpdateTokenApi extends BaseDioApi {
  String device_key;

  UpdateTokenApi({
    required this.device_key,
  }) : super(ApiUrls.updateToken);

  @override
  body() {
    return {"device_key": device_key};
  }

  Future fetch() async {
    final response = await postRequest();
    return response;
  }
}
