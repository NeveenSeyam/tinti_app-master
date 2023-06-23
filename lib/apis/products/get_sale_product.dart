import '../api_urls.dart';
import '../base_dio_api.dart';

class GetSalesProductsDataApi extends BaseDioApi {
  int page;

  GetSalesProductsDataApi({required this.page})
      : super(ApiUrls.salePoductsPage(page: page));

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
