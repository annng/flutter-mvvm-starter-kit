import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionCubit extends Cubit<String?> {
  final FlutterSecureStorage _secureStorage;

  SessionCubit(this._secureStorage) : super(null);

  static const String _tokenKey = 'auth_token';

  Future<void> checkSession() async {
    final token = await _secureStorage.read(key: _tokenKey);
    if (token != null) {
      emit(token);
    } else {
      emit(null);
    }
  }

  Future<void> createSession(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
    emit(token);
  }

  Future<void> clearSession() async {
    await _secureStorage.delete(key: _tokenKey);
    emit(null);
  }
}
