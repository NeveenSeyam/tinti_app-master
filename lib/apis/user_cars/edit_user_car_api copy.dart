import '../api_urls.dart';
import '../base_dio_api.dart';

class EditUserCar extends BaseDioApi {
  dynamic id;

  EditUserCar({
    required this.id,
  }) : super(ApiUrls.editCars(id: id));

  @override
  body() {
    return {};
  }

  Future fetch() async {
    final response = await putRequest();
    return response;
  }
}
