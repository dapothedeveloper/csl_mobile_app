import 'dart:convert';
import 'package:cewers_flutter/model/error.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class API {
  Uri _baseUrl = Uri(scheme: "http", host: "165.22.80.212");
  Map<String, String> _headers = {"Content-Type": "application/json"};
  Map<String, int> _ports = {"benue": 8000, "taraba": 8001, "nasarawa": 8002};
  SharedPreferences _pref;

  Future<String> getPort() async {
    _pref = await SharedPreferences.getInstance();

    return _pref.getString("preferredState");
  }

  Future<dynamic> postRequest(String path, Map<String, dynamic> data) async {
    var body = json.encode(data);
    var state = await getPort();
    int port = _ports[state];
    http.Response response = await http.post("$_baseUrl:$port/api/$path",
        headers: _headers, body: body);
    if (response.statusCode == 200)
      return response.body;
    else
      return APIError("Server currently unavailable");
  }

  Future<dynamic> getRequest(String path) async {
    var state = await getPort();
    int port = _ports[state];
    final response =
        await http.post("$_baseUrl:$port/api/$path", headers: _headers);
    if (response.statusCode == 200)
      return response.body;
    else
      return APIError("Server currently unavailable");
  }

  Future<dynamic> putRequest(String path, Map<String, String> data) async {
    final body = json.encode(data);
    var state = await getPort();
    int port = _ports[state];
    var response = await http.put("$_baseUrl:$port/api/$path",
        headers: _headers, body: body);
    if (response.statusCode == 200)
      return response.body;
    else
      return APIError("Server currently unavailable");
  }
}
