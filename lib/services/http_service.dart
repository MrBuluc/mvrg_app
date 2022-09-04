import 'package:http/http.dart' as http;

class HttpService {
  Future<bool> checkResponse(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    return response.statusCode == 200;
  }
}
