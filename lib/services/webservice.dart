import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:GitCommits/utils/constants.dart';

const apiUrl = Constants.COMMITS_URL;

class API {
  static Future getCommits(url) async {
    return await http.get(url);
  }
}
