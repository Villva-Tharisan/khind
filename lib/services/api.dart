import 'dart:convert';

class Api {
  // static const endpoint = 'http://kemaman.org:8080/jobgrabber_webapi/';
  static const endpoint = 'http://cm.khind.com.my/';
  static const defaultToken = "Basic a2hpbmRhcGk6S2hpbmQxcWF6MndzeDNlZGM=";
  static String APP_KEY =
      "445a555cff7cfc3a6b84c50791f4c4cff0ed63c9c203061f158e2ac90663e244";
  static String PUB_KEY =
      "445a555cff7cfc3a6b84c50791f4c4cff0ed63c9c203061f158e2ac90663e244";

  static final ENCODING = Encoding.getByName('utf-8');

  static const GET_STATES = "provider/state.php";
  static const GET_CITIES = "provider/city.php";
  static const GET_SERVICE = "provider/service.php";
  static const GET_REQUEST_SERVICE = "provider/khind_service.php";
  static const GET_MY_PURCHASE = "provider/purchase.php";
  static const GET_PRODUCT_WARRANTY = "provider/product_info.php";
  static const REGISTER_EWARRANTY = "provider/warranty_registration.php";
  static const GET_SERVICE_PRODUCT = "provider/service_product.php";
  static const GET_PRODUCT_GROUP = 'provider/product_group.php';
  static const EXTEND_WARRANTY = 'provider/extend_warranty.php';
  static const GET_STORE = 'provider/store.php';
  static const CREATE_SERIAL_NO = 'provider/create_serial_number.php';
  static const CREATE_SERVICE_REQUEST = 'provider/create_service_request.php';
}
