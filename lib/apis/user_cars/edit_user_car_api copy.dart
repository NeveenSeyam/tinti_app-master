import '../api_urls.dart';
import '../base_dio_api.dart';

class EditUserCar extends BaseDioApi {
  dynamic id;
  String name;
  String car_model_id;
  String car_size_id;
  String color;
  String car_number;
  dynamic image;
  dynamic car_model_type_id;

/*"id": 74,
        "name": "test",
        "color": "#00000",
        "car_number": "123123122",
        "car_model_name": "AMC",
        "car_model_type_name": "Vigor",
        "car_size_name": "كبيرة",
        "image": "http://sayyarte.com/img/demo_car.png" */
  EditUserCar(
      {required this.name,
      required this.car_model_id,
      required this.car_size_id,
      required this.color,
      required this.car_number,
      required this.image,
      required this.id,
      required this.car_model_type_id})
      : super(ApiUrls.editCars(id: id));

  @override
  body() {
    return {};
  }

  Future fetch() async {
    final response = await postRequest();
    return response;
  }
}
