library constants;

const bool MOCK_SERVICES = true;

class Constants {
  static bool mockEnabled = false;

  static String getBaseApi() {
      // return 'http://localhost:8080';
      return 'http://192.168.1.32:8080'; // macbook
      // return 'http://10.0.2.2:8080'; // macbook
  }
}
