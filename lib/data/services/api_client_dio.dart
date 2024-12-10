import 'package:dio/dio.dart';

typedef ApiClientException = DioException;
typedef ApiClientResponse<T> = Response<T>;
typedef ApiClientRequestOptions = RequestOptions;
typedef _ResponseData = Map<String, Object?>;

extension ApiClientExceptionX on ApiClientException {
  // String? get responseMessage => response?.data?['message'] as String?;
  String get responseMessage => response?.data["message"] as String;
}

/// An API client that makes network requests.
///
/// This class is meant to be seen as a representation of the common API contract
/// or API list (such as Swagger or Postman) given by the backend.
///
/// This class does not maintain authentication state, but rather receive the token
/// from external source.
///
/// When a widget or provider wants to make a network request, it should not
/// instantiate this class, but instead call the provider that exposes an object
/// of this type.
class ApiClient {
  static final BaseOptions _defaultOptions = BaseOptions(
      baseUrl: BASE_URL);

  static const BASE_URL = "https://dummyjson.com"; //todo change url with your api path
  static const TIME_OUT = 43200;
  static const LIMIT = 10;

  final Dio _httpClient;

  /// Creates an [ApiClient] with default options.
  ApiClient() : _httpClient = Dio(_defaultOptions);

  /// Creates an [ApiClient] with [token] set for authorization.
  ApiClient.withToken(String token)
      : _httpClient = Dio(
    _defaultOptions.copyWith()
      ..headers['Authorization'] = 'Bearer $token',
  );

  @override
  String toString() {
    return "ApiClient(_httpClient.options.headers['Authorization']: ${_httpClient.options.headers['Authorization']})";
  }

  /// Generic method for making a POST request.
  Future<Map<String, dynamic>> post(String path,
      {dynamic data, Map<String, dynamic>? header}) async {
    final response = await _httpClient.post(path,
        data: data, options: Options(headers: header));

    return response.data as Map<String, dynamic>;
  }

  /// Generic method for making a POST request.
  Future<Map<String, dynamic>> formMultipart(String path,
      {dynamic data, Map<String, dynamic>? header}) async {
    final response = await _httpClient.post(path,
        data: FormData.fromMap(data), options: Options(headers: header));

    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> get(String path,
      {Map<String, dynamic>? data, Map<String, dynamic>? header}) async {
    final response = await _httpClient.get(path,
        data: data, options: Options(headers: header));
    return response.data as Map<String, dynamic>;
  }

  /// Getter to access the Dio client for custom requests.
  Dio get client => _httpClient;
}