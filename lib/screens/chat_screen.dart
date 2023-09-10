//import 'dart:math';

import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:untitled/constants/constants.dart';
import 'package:untitled/services/assetsManager.dart';
import 'package:untitled/widgets/chat_widget.dart';
//import 'package:untitled/widgets/text_widget.dart';
import 'package:untitled/services/modelSheet.dart';
import 'package:untitled/provider/models_provider.dart';
//import 'package:untitled/services/apiServices.dart';
//import 'package:untitled/models/chat_model.dart';
import 'package:untitled/provider/chatProvider.dart';
import 'package:untitled/widgets/text_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  late TextEditingController textEditingController;
  late FocusNode focusNode;
  late ScrollController _scrollController;
  @override
  void initState() {
    // TODO: implement initState
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textEditingController.dispose();
    focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  //List<ChatModel> chatModel = [];
  @override
  Widget build(BuildContext context) {
    final modelProvider = Provider.of<ModelProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(assetsMananager.openai),
        ),
        title: const Text('ChatGPT'),
        actions: [
          IconButton(
              onPressed: () async {
                await ModelSheet.showmodelSheet(context: context);
              },
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          Flexible(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: chatProvider.getChatModel.length,
              itemBuilder: (context, index) {
                return ChatWidget(
                  chatMsg: chatProvider.getChatModel[index].msg,
                  index: chatProvider.getChatModel[index].chatIndex,
                  shouldAnimate: chatProvider.getChatModel.length-1==index,
                );
              },
            ),
          ),
          if (_isTyping) ...[
            const SpinKitThreeBounce(
              color: Colors.white,
              size: 18,
            ),
          ],
          const SizedBox(
            height: 15,
          ),
          Material(
            color: cardColor,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: focusNode,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      controller: textEditingController,
                      onSubmitted: (value) async {
                        await sendMessage(modelProvider, chatProvider);
                      },
                      decoration: const InputDecoration.collapsed(
                        hintText: 'How can i help you?',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await sendMessage(modelProvider, chatProvider);
                      },
                      icon: const Icon(Icons.send,color: Colors.white,)),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  void scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessage(

      ModelProvider modelProvider, ChatProvider chatProvider) async {
    if(_isTyping){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(
          lable:"You cant send multiple messages at a time",
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if(textEditingController.text.isEmpty){
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(
          lable:"Please type a message",
        ),
        backgroundColor: Colors.red,
      ));
       return;
    }
    try {
      String msg=textEditingController.text;
      setState(() {
        _isTyping = true;
        chatProvider.addUserMessage(msg);
        //chatModel.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMsgGetAns(
          msg, modelProvider.getCurrentModel);
      // chatModel.addAll(await ApiServices.sendmessage(
      //   textEditingController.text,
      //   modelProvider.getCurrentModel,
      // ));
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          lable: e.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollToEnd();
        _isTyping = false;
      });

    }
  }
}
