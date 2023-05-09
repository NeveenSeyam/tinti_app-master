import '../api_urls.dart';
import '../base_dio_api.dart';

class DeleteUserCar extends BaseDioApi {
  dynamic id;

  DeleteUserCar({
    required this.id,
  }) : super(ApiUrls.removeCar(id: id));

  @override
  body() {
    return {};
  }

  Future fetch() async {
    final response = await deleteRequest();
    return response;
  }
}
