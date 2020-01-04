import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:GitCommits/utils/constants.dart';
import 'dart:developer' as developer;

const apiUrl = Constants.COMMITS_URL;

class API {
  static Future getCommits() {
    var url = apiUrl;
    print(apiUrl + "apiUrl");
    return http.get(url);
  }
}
