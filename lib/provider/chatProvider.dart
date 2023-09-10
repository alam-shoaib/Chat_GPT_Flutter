import 'package:flutter/cupertino.dart';
//import 'package:provider/provider.dart';
import 'package:untitled/models/chat_model.dart';
import 'package:untitled/services/apiServices.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatModel = [];
  List<ChatModel> get getChatModel {
    return chatModel;
  }

  void addUserMessage(String msg) {
    chatModel.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMsgGetAns(String msg, String models) async {
    if (models.toLowerCase().startsWith('gpt')) {
      chatModel.addAll(await ApiServices.sendmessage(
        msg,
        models,
      ));
    } else {
      chatModel
          .addAll(await ApiServices.sendMessage(message: msg, modelId: models));
    }
    notifyListeners();
  }
}
