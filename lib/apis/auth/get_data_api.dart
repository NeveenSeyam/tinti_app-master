import '../api_urls.dart';
import '../base_dio_api.dart';

class GetDataApi extends BaseDioApi {
  GetDataApi() : super(ApiUrls.login);

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
