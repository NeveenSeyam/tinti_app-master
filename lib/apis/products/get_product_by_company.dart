import '../api_urls.dart';
import '../base_dio_api.dart';

class GetProductByCompanyApi extends BaseDioApi {
  String id;
  int page;

  GetProductByCompanyApi({
    required this.id,
    required this.page,
  }) : super(ApiUrls.showproductByCompany(id: id));

  @override
  body() {
    return {
      "page": page,
    };
  }

  Future fetch() async {
    //* u can  chose the what the request type
    //! Get , Post , Put , Delete
    final response = await getRequest();
    return response;
  }
}
