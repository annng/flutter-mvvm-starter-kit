import 'package:flutter/foundation.dart';

class UiState<T> extends ChangeNotifier {
  T? _data;
  T? get data => _data;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setData(T data) {
    _data = data;
    _errorMessage = null;
    notifyListeners();
  }

  void setError(String errorMessage) {
    _errorMessage = errorMessage;
    _data = null;
    notifyListeners();
  }

  void reset() {
    _data = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
