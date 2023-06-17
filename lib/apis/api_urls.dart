import '../Util/constants/constants.dart';

class ApiUrls {
  static const String baseUrl = 'http://sayyarte.com/';

  // Account
  static const login = '${baseUrl}api/login';
  static const String getData = '$baseUrl/users?';
  static const register = '${baseUrl}api/singup';
  static const changePassword = '${baseUrl}api/changePassword';
  static const logout = '${baseUrl}api/logout';
  static const activate = '${baseUrl}api/activate';
  static const search = '${baseUrl}api/products_search';
  static const forgetPassword = '${baseUrl}api/frogotPassword';

// user_car
  static const cars = '${baseUrl}api/cars';
  // static const editCars = '${baseUrl}api/cars';
  static String editCars({required id}) =>
      '${baseUrl}api/cars/update_car/${id.toString()}';
  static const addcars = '${baseUrl}api/cars';
  static removeCar({required id}) => '${baseUrl}api/cars/${id.toString()}';
  //

  //profile
  static String profileShow = '${baseUrl}api/profile_show';
  static String profileUpdate = '${baseUrl}api/profile_update';
  static String changeUserPassword = '${baseUrl}api/changeUserPassword';

  //api/companies
  static String companyPage = '${baseUrl}api/companies';
  static String showCompany({required id}) =>
      '${baseUrl}api/company/${id.toString()}';

  //api/orders
  static String ordersPage = '${baseUrl}api/orders';
  static String addOrders = '${baseUrl}api/orders';
  static String activeOrders({required id}) =>
      '${baseUrl}api/orders/payment_flag/${id.toString()}';
  static String showOrder() => '${baseUrl}api/orders}';
  static String addFav = '${baseUrl}api/favorites';

  //api/favs
  static String favPage = '${baseUrl}api/favorites';
  static String deleteFav({required id}) =>
      '${baseUrl}api/favorites/${id.toString()}}';
  static String showFav({required id}) =>
      '${baseUrl}api/favorites/${id.toString()}}';

  //api/products
  static String allProductsPage = '${baseUrl}api/all_products';
  static String salePoductsPage = '${baseUrl}api/sale_products';

  static String singleProductPage({required id}) =>
      '${baseUrl}api/product/${id.toString()}';
  static String showproductByServises({required id}) =>
      '${baseUrl}api/products/${id.toString()}';
  static String showproductByCompany({required id}) =>
      '${baseUrl}api/products_company/${id.toString()}';

  //api/services
  static String servicesList = '${baseUrl}api/services';

  // api/intro
  static String introList = '${baseUrl}api/intro';

  //api/notifications
  static String notificationsList = '${baseUrl}api/notifications';

  //api/notifications
  static String appData = '${baseUrl}api/page';
  static String contactData = 'https://www.sayyarte.com/api/contact_info';
  static String contactUsData({
    required email,
    required name,
    required address,
    required mcontent,
  }) =>
      '${baseUrl}api/contactUs?email=$email&name=$name&title=$address&mcontent=$mcontent';

// cars and size
  static String car_models = '${baseUrl}api/car_models';
  static String car_types({required id}) =>
      '${baseUrl}api/car_types/${id.toString()}';
  static String car_sizes({required id}) =>
      '${baseUrl}api/car_sizes/${id.toString()}';
  static String regions = '${baseUrl}api/regions';
  static String cities({required id}) =>
      '${baseUrl}api/cities/${id.toString()}';
}
// {{Base_URL}}api/contactUs?email=nevveev@test.com	&name=neveen&title=verfication my account&mcontent=it's not activate
