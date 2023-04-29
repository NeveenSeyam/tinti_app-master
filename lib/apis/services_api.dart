import 'api_urls.dart';
import 'base_dio_api.dart';

class GetServicesDataApi extends BaseDioApi {
  GetServicesDataApi() : super(ApiUrls.servicesList);

  @override
  body() {
    return {};
  }

  Future fetch() async {
    //* u can  chose the what the request type
    //! Get , Post , Put , Delete
    final response = await getRequest();
    return response;
  }
}
