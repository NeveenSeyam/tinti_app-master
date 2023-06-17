import '../api_urls.dart';
import '../base_dio_api.dart';

class GetSearchProductsDataApi extends BaseDioApi {
  String name;
  GetSearchProductsDataApi({required this.name}) : super(ApiUrls.search);

  @override
  body() {
    return {
      "name": name,
    };
  }

  Future fetch() async {
    //* u can  chose the what the request type
    //! Get , Post , Put , Delete
    final response = await postRequest();
    return response;
  }
}
