import 'package:flutter/cupertino.dart';

const String rootDataKey = "users";

class BaseResponse<T> extends ChangeNotifier {
  T? _data;
  bool? _status;
  String _message;

  T? get data => _data;

  bool? get status => _status;

  String get message => _message;

  factory BaseResponse.empty(){
    return BaseResponse(null, null, "");
  }

  BaseResponse(this._data, this._status, this._message);

  set data(T? value) {
    _data = value;
    notifyListeners(); // Notify listeners when data changes
  }

  set status(bool? value) {
    _status = value;
    notifyListeners();
  }

  set message(String value) {
    _message = value;
    notifyListeners();
  }


  factory BaseResponse.fromJson(Map<String, dynamic> json,
      T Function(dynamic) fromJsonT) {
    return BaseResponse(
        json[rootDataKey] != null ? fromJsonT(json[rootDataKey]) : null,
        json["status"] == null ? false : json["status"].toString() == "true",
        json["message"] ?? "");
  }

  factory BaseResponse.init(Map<String, dynamic> json) {
    return BaseResponse(
        null,
        json["status"] == null ? false : json["status"].toString() == "true",
        json["message"] ?? "");
  }

  factory BaseResponse.error(String message){
    return BaseResponse(null, false, message);
  }
}
