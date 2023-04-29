import '../api_urls.dart';
import '../base_dio_api.dart';

class GetProductByServisesApi extends BaseDioApi {
  int id;

  GetProductByServisesApi({
    required this.id,
  }) : super(ApiUrls.showproductByServises(id: id));

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
