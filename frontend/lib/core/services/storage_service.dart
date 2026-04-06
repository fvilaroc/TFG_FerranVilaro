import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();

  static const String tokenKey = 'jwt_token';
  static const String usernameKey = 'username';

  Future<void> saveToken(String token) async {
    await _storage.write(key: tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: tokenKey);
  }

  Future<void> saveUsername(String username) async {
    await _storage.write(key: usernameKey, value: username);
  }

  Future<String?> getUsername() async {
    return await _storage.read(key: usernameKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}