import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WebhookService {
  Future<bool> sendMessageToMvRGDc(String content) async {
    String host = "discord.com",
        path =
            "api/webhooks/${dotenv.env["dcWebhookId"]}/${dotenv.env["dcWebhookToken"]}";
    Uri uri = Uri(scheme: "https", host: host, path: path);
    http.Response response = await http.post(uri, body: {"content": content});
    if (response.statusCode == 204) {
      return true;
    }
    throw getError(uri, response);
  }

  Future<bool> sendMessageToMvRGTelegram(String text) async {
    Uri uri = Uri(
        scheme: "https",
        host: "api.telegram.org",
        path: "bot${dotenv.env["telegramMvRGBotToken"]}/sendMessage");
    http.Response response = await http.post(uri,
        body: {"chat_id": dotenv.env["telegramMvRGGroupChatId"], "text": text});
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      return responseBody["ok"];
    }
    throw getError(uri, response);
  }

  Exception getError(Uri uri, http.Response response) {
    print("Request $uri failed\n" +
        "Response: ${response.statusCode} ${response.body}");
    throw response;
  }
}
