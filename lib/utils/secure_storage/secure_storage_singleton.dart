import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageSingleton {
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static FlutterSecureStorage getInstance() {
    return _secureStorage;
  }
}
