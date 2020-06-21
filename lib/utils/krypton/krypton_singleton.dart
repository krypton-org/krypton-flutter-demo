import 'package:boilerplate/utils/secure_storage/secure_storage_singleton.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:krypton/krypton.dart';

class KryptonSingleton {
  static final String refreshTokenPropertyName = 'refreshToken';

  static KryptonClient _krypton;

  static Future<void> init() async {
      getInstance();
      FlutterSecureStorage secureStorage = SecureStorageSingleton.getInstance();
      String refreshToken =
          await secureStorage.read(key: refreshTokenPropertyName);
      try {
        await _krypton.setRefreshToken(refreshToken);
      } catch (e) {
        // refresh token expired
      }
  }

  static KryptonClient getInstance() {
    if (_krypton == null) {
      _krypton = KryptonClient(
          endpoint: "https://nusid.net/krypton-auth",
          saveRefreshTokenClbk: (refreshToken) async {
            await SecureStorageSingleton.getInstance().write(
                key: refreshTokenPropertyName, value: refreshToken);
          });
    }
    return _krypton;
  }
}
