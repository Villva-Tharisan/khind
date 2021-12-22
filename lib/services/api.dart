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
}
