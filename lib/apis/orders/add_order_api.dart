import '../api_urls.dart';
import '../base_dio_api.dart';

class AddOrder extends BaseDioApi {
  String product_id;
  String car_id;
  String region_id;
  String city_id;
  String payment_flag;

  AddOrder({
    required this.car_id,
    required this.city_id,
    required this.payment_flag,
    required this.product_id,
    required this.region_id,
  }) : super(ApiUrls.ordersPage);

  @override
  body() {
    return {};
  }

  Future fetch() async {
    final response = await postRequest();
    return response;
  }
}
