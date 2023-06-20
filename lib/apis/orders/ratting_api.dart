import '../api_urls.dart';
import '../base_dio_api.dart';

class AddRate extends BaseDioApi {
  dynamic order_id;
  dynamic star_rating;
  dynamic comments;

  AddRate({
    required this.order_id,
    required this.star_rating,
    required this.comments,
  }) : super(ApiUrls.addRate);

  @override
  body() {
    return {
      "order_id": order_id,
      "star_rating": star_rating,
      "comments": comments,
    };
  }

  Future fetch() async {
    final response = await postRequest();
    return response;
  }
}
