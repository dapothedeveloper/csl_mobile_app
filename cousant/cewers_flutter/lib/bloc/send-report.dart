import 'dart:convert';
import 'dart:io';
import 'package:cewers_flutter/controller/storage.dart';
import 'package:cewers_flutter/model/error.dart';
import 'package:cewers_flutter/model/response.dart';
import 'package:cewers_flutter/service/api.dart';
import 'package:cloudinary_client/models/CloudinaryResponse.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloudinary_client/cloudinary_client.dart';
import 'package:image_picker/image_picker.dart';

class SendReportBloc {
  StorageController _storageController = new StorageController();
  API _api = new API();

  Future _uploadImage(
    File file,
  ) async {
    var credentials = await rootBundle.loadString('assets/cloudinary.json');

    CloudinaryCredential auth =
        CloudinaryCredential.fromJson(json.decode(credentials));

    CloudinaryClient client =
        CloudinaryClient(auth.secretKey, auth.apiKey.toString(), "cloud_name");
    /**
     * Get the client's userID and State from memory
     * So we can set a unique file for the file and equally
     * upload to the right folder on the cloud
     */
    String userId = await _storageController.getUserId() ?? "unknowUser";
    String state = await _storageController.getState() ?? "unknownState";

    List<String> paths = file.path.split(".");
    String fileExtension = paths[paths.length - 1];

    List<CloudinaryResponse> response = await client.uploadImages([file.path],
        filename: "$userId-${DateTime.now()}.$fileExtension", folder: state);
    return response;
  }

  Future<File> pickFile() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<File> openCamera() async {
    return await ImagePicker.pickImage(source: ImageSource.camera);
  }

  Future<String> getUserId() async {
    var storage = new StorageController();
    String userId = await storage.getUserId();
    return userId;
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
    var response = await _api.getRequest("alerts/$userId");
    if (response is APIError) return response;
    APIResponseModel responseBody =
        APIResponseModel.fromJson(json.decode(response));
    print(response.message);
    print(response.body);

    return responseBody;
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