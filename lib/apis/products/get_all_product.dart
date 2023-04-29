import '../api_urls.dart';
import '../base_dio_api.dart';

class GetProductsDataApi extends BaseDioApi {
  GetProductsDataApi() : super(ApiUrls.allProductsPage);

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
