import '../api_urls.dart';
import '../base_dio_api.dart';

class GetSingleCampanyDataApi extends BaseDioApi {
  int id;
  GetSingleCampanyDataApi({
    required this.id,
  }) : super(ApiUrls.showCompany(id: id));

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
