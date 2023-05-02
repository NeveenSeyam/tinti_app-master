import '../api_urls.dart';
import '../base_dio_api.dart';

class RemoveFav extends BaseDioApi {
  dynamic product_id;

  RemoveFav({
    required this.product_id,
  }) : super(ApiUrls.deleteFav(id: product_id));

  @override
  body() {
    return {};
  }

  Future fetch() async {
    final response = await deleteRequest();
    return response;
  }
}
