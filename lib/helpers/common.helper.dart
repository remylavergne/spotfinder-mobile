import 'package:uuid/uuid.dart';

class CommonHelper {
  CommonHelper._privateConstructor();

  static final CommonHelper instance = CommonHelper._privateConstructor();

  String generateUuidv4() {
    return Uuid().v4();
  }
}
