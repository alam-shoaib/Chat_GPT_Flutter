import 'package:flutter/material.dart';
import 'package:untitled/constants/constants.dart';
import 'package:untitled/services/assetsManager.dart';
import 'package:untitled/widgets/text_widget.dart';
import 'package:untitled/services/modelSheet.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget(
      {required this.chatMsg,
      required this.index,
      this.shouldAnimate = false,
      Key? key})
      : super(key: key);
  final String chatMsg;
  final int index;
  final bool shouldAnimate;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: index == 0 ? scaffoldBackgroundColor : cardColor,
          //color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  index == 0
                      ? assetsMananager.person
                      : assetsMananager.chatlogo,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: index == 0
                      ? TextWidget(lable: chatMsg)
                      : shouldAnimate
                          ? DefaultTextStyle(
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              child: AnimatedTextKit(
                                isRepeatingAnimation: false,
                                repeatForever: false,
                                totalRepeatCount: 1,
                                displayFullTextOnTap: true,
                                animatedTexts: [
                                  TyperAnimatedText(
                                    chatMsg.trim(),
                                  ),
                                ],
                              ),
                            )
                          : Text(
                              chatMsg.trim(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                ),
                index == 0
                    ? const SizedBox.shrink()
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.thumb_down_alt_outlined,
                            color: Colors.white,
                          ),
                        ],
                      )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
