import 'package:cewers_flutter/controller/storage.dart';
import 'package:cewers_flutter/model/response.dart';
import 'package:cewers_flutter/service/api.dart';
import 'dart:convert';

class ReportController {
  API _api = new API();

  Future<String> getUserId() async {
    var storage = new StorageController();
    String userId = await storage.getUserId();
    return userId;
  }

  Future<APIResponseModel> sendReport(Map<String, dynamic> data) async {
    var response = await _api.postRequest("alert", data);
    var responseBody = json.decode(response.body);
    print(responseBody);

    return responseBody;
  }

  Future<APIResponseModel> getReport() async {
    String userId = await getUserId();
    var response = await _api.getRequest("alerts/$userId");
    APIResponseModel responseBody =
        APIResponseModel.fromJson(json.decode(response.body));
    print(response.message);
    print(response.body);

    return responseBody;
  }
}
