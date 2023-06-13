import '../api_urls.dart';
import '../base_dio_api.dart';

class GetCarModelTypesDataApi extends BaseDioApi {
  dynamic id;
  GetCarModelTypesDataApi({
    required this.id,
  }) : super(ApiUrls.car_types(id: id));

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
