import 'dart:convert';
import 'dart:io';
import 'package:cewers_flutter/bloc/bloc.dart';
import 'package:cewers_flutter/controller/storage.dart';
import 'package:cewers_flutter/model/error.dart';
import 'package:cewers_flutter/model/response.dart';
import 'package:cewers_flutter/service/api.dart';
import 'package:cloudinary_client/models/CloudinaryResponse.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloudinary_client/cloudinary_client.dart';
import 'package:cewers_flutter/extensions/string.dart';

class SendReportBloc implements Bloc {
  final StorageController _storageController;
  final API _api;
  SendReportBloc(this._storageController, this._api);
  String _credentialJsonUri = "assets/cloudinary.json";

  Future<List<CloudinaryResponse>> uploadImage(
    File file,
  ) async {
    var credentials = await rootBundle.loadString(_credentialJsonUri);

    CloudinaryCredential auth =
        CloudinaryCredential.fromJson(json.decode(credentials));

    CloudinaryClient client =
        CloudinaryClient(auth.secretKey, auth.apiKey.toString(), "cloud_name");
    /**
     * Get the client's userID and State from memory
     * So we can set a unique file for the file and equally
     * upload to the right folder on the cloud
     */
    String userId = await getUserId() ?? "unknowUser";
    String state = await getState() ?? "unknownState";

    List<String> paths = file.path.split(".");
    String fileExtension = paths[paths.length - 1];
    print(
        "${state.capitalize()}=====UPLOADING===========$fileExtension========FOR====$userId======");
    List<CloudinaryResponse> response = await client.uploadImages([file.path],
        filename: "$userId-${DateTime.now()}.$fileExtension",
        folder: state.capitalize());
    return response;
  }

  Future<String> getUserId() async {
    return this._storageController.getUserId();
  }

  Future<String> getState() async {
    return this._storageController.getState();
  }

  Future<dynamic> sendReport(Map<String, dynamic> data) async {
    var response = await _api.postRequest("alert", data);
    if (response is APIError) return response;
    APIResponseModel responseBody =
        APIResponseModel.fromJson(json.decode(response));

    return responseBody;
  }

  Future<dynamic> getReport() async {
    String userId = await getUserId();
    Future.delayed(Duration(seconds: 20));
    var response = await _api.getRequest("alerts/$userId");
    if (response is APIError) return response;
    APIResponseModel responseBody =
        APIResponseModel.fromJson(json.decode(response));

    return responseBody;
  }

  @override
  void dispose() {
    rootBundle.evict(_credentialJsonUri);
  }
}

class CloudinaryCredential {
  final String apiKey;
  final String secretKey;

  CloudinaryCredential(this.apiKey, this.secretKey);

  factory CloudinaryCredential.fromJson(dynamic json) {
    return CloudinaryCredential(
        json["key"] as String, json["secret"] as String);
  }
}
