import '../api_urls.dart';
import '../base_dio_api.dart';

class EditUserProfile extends BaseDioApi {
  String fName;
  String lName;
  String email;
  String phoneNumber;
  String address;
  String img;

  EditUserProfile({
    required this.fName,
    required this.lName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.img,
  }) : super(ApiUrls.profileUpdate);

  @override
  body() {
    return {
      "fname": fName,
      "lname": lName,
      "email": email,
      "mobile": phoneNumber,
      "address": address,
      "img": img
    };
  }

  Future fetch() async {
    final response = await postRequest();
    return response;
  }
}
