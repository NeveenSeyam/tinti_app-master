import '../api_urls.dart';
import '../base_dio_api.dart';

class GetSingleOrdersDataApi extends BaseDioApi {
  dynamic id;
  GetSingleOrdersDataApi({required dynamic id})
      : super(ApiUrls.showSingleOrder(id: id));

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
