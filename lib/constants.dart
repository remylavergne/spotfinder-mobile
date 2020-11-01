library constants;

const bool MOCK_SERVICES = true;

class Constants {
  static bool mockEnabled = false;

  static String getBaseApi() {
    if (mockEnabled) {
      return 'http://localhost:8080';
    } else {
      return 'http://192.168.1.32:8080'; // macbook
      // return 'http://localhost:8080'; // macbook
    }
  }
}
