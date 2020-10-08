library constants;

const bool MOCK_SERVICES = true;

class Constants {
  static bool mockEnabled = true;

  static String getBaseApi() {
    if (mockEnabled) {
      return 'http://localhost:8080/';
    } else {
      return '';
    }
  }
}
