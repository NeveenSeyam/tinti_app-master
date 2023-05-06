import 'api_urls.dart';
import 'base_dio_api.dart';

class GetContactUsDataApi extends BaseDioApi {
  String email;
  String name;
  String address;
  String mcontent;
  GetContactUsDataApi(
      {required this.name,
      required this.email,
      required this.address,
      required this.mcontent})
      : super(ApiUrls.contactUsData(
            mcontent: mcontent, name: name, address: address, email: email));

  @override
  body() {
    return {};
  }

  Future fetch() async {
    //* u can  chose the what the request type
    //! Get , Post , Put , Delete
    final response = await postRequest();
    return response;
  }
}
