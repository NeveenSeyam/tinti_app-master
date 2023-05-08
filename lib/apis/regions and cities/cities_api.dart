import '../api_urls.dart';
import '../base_dio_api.dart';

class GetCitiesDataApi extends BaseDioApi {
  dynamic id;
  GetCitiesDataApi({required id}) : super(ApiUrls.cities(id: id));

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
