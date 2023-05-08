import '../api_urls.dart';
import '../base_dio_api.dart';

class GetSizeDataApi extends BaseDioApi {
  GetSizeDataApi() : super(ApiUrls.car_sizes);

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
