import 'package:http/http.dart' as http;
import 'package:mvrg_app/services/secret.dart';

class WebhookService {
  Future<bool> sendMessageToMvRG(String content) async {
    String host = "discord.com",
        path = "api/webhooks/${Secret.webhookId}/${Secret.webhookToken}";
    Uri uri = Uri(scheme: "https", host: host, path: path);
    http.Response response = await http.post(uri, body: {"content": content});
    if (response.statusCode == 204) {
      return true;
    }
    throw getError(uri, response);
  }

  Exception getError(Uri uri, http.Response response) {
    print("Request $uri failed\n" +
        "Response: ${response.statusCode} ${response.body}");
    throw response;
  }
}
