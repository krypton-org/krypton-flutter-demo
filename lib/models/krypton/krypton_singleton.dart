import 'package:krypton/krypton.dart';

class KryptonSingleton {
   static final KryptonClient _krypton = KryptonClient("https://nusid.net/krypton-auth");

    static KryptonClient getInstance(){
      return _krypton;
    }
}