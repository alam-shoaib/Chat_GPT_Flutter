import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:untitled/constants/apiConstants.dart';
import 'package:untitled/models/Models.dart';
import 'package:untitled/models/chat_model.dart';

class ApiServices {
  static Future<List<Models>> getApiResponse() async {
    try {
      var response = await http.get(
        Uri.parse('$BASEURL/models'),
        headers: {"Authorization": "Bearer $apikey"},
      );
      Map jasonResponse = jsonDecode(response.body);
      if (jasonResponse['error'] != null) {
        //print(jasonResponse['error']['message'].toString());
        throw HttpException(jasonResponse['error']['message']);
      }
      List temp = [];
      for (var value in jasonResponse["data"]) {
        temp.add(value);
      }
      return Models.modelsFromSnapshot(temp);
    } catch (e) {
      log('error: ${e.toString()}');
      rethrow;
    }
  }

  //Send Messages
  static Future<List<ChatModel>> sendmessage(String msg, String modelId) async {
    try {
      var response = await http.post(Uri.parse('$BASEURL/chat/completions'),
          headers: {
            "Authorization": "Bearer $apikey",
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "model": modelId,
            "messages": [
              {"role": "user", "content": msg,}
            ],
            "temperature": 0.7,
          }));
      //Map jasonResponse = jsonDecode(response.body);
      Map jasonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jasonResponse['error'] != null) {
        //print(jasonResponse['error']['message'].toString());
        throw HttpException(jasonResponse['error']['message']);
      }
      List<ChatModel> chatList = [];
      if (jasonResponse["choices"].length > 0) {
        chatList = List.generate(
            jasonResponse["choices"].length,
            (index) => ChatModel(
                  msg: jasonResponse["choices"][index]["message"]["content"],
                  chatIndex: 1,
                ),);
      }
      return chatList;
    } catch (e) {
      log('error: ${e.toString()}');
      rethrow;
    }
  }
  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      log("modelId $modelId");
      var response = await http.post(
        Uri.parse("$BASEURL/completions"),
        headers: {
          'Authorization': 'Bearer $apikey',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "prompt": message,
            "max_tokens": 300,
          },
        ),
      );

      // Map jsonResponse = jsonDecode(response.body);

      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        // log("jsonResponse[choices]text ${jsonResponse["choices"][0]["text"]}");
        chatList = List.generate(
          jsonResponse["choices"].length,
              (index) => ChatModel(
            msg: jsonResponse["choices"][index]["text"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
