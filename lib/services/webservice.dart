import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:GitCommits/utils/constants.dart';

const apiUrl = Constants.COMMITS_URL;

class API {
  static Future getCommits() async {
    var url = apiUrl;
    print(apiUrl + "apiUrl");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'token dd559a7ff149fccf64dcb24d5f587c28636c53f5'
    };
    return await http.get(
      url,
      // headers: requestHeaders,
    );
  }
}
