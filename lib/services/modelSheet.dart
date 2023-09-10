import 'package:flutter/material.dart';
import 'package:untitled/constants/constants.dart';
import 'package:untitled/widgets/text_widget.dart';
import 'package:untitled/widgets/drop_down.dart';

class ModelSheet {
  static Future<void> showmodelSheet({required BuildContext context}) async {
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        backgroundColor: scaffoldBackgroundColor,
        context: context,
        builder: (context) {
          return const Padding(
            padding:  EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Flexible(
                  child: TextWidget(
                    lable: 'Choose Model',
                    fontSize: 16,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: DropDown(),
                )
              ],
            ),
          );
        });
  }
}
