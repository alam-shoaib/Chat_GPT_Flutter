import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/constants/constants.dart';
//import 'package:untitled/services/apiServices.dart';
import 'package:untitled/widgets/text_widget.dart';
import 'package:untitled/models/Models.dart';
import 'package:untitled/provider/models_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DropDown extends StatefulWidget {
  const DropDown({Key? key}) : super(key: key);

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String? currentModel;
  bool isFirstLoading = true;

  @override
  Widget build(BuildContext context) {
    final modelProvider=Provider.of<ModelProvider>(context,listen: false);
    currentModel=modelProvider.getCurrentModel;
    return FutureBuilder<List<Models>>(
      future: modelProvider.getModels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            isFirstLoading == true) {
          isFirstLoading = false;
          return const FittedBox(
            child: SpinKitFadingCircle(
              color: Colors.lightBlue,
              size: 30,
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: TextWidget(lable: snapshot.error.toString()),
          );
        }
        return snapshot.data == null || snapshot.data!.isEmpty
            ? const SizedBox.shrink()
            : FittedBox(
              child: DropdownButton(
                  dropdownColor: scaffoldBackgroundColor,
                  iconEnabledColor: Colors.white,
                  items: List<DropdownMenuItem<String>>.generate(
                    snapshot.data!.length,
                        (index) => DropdownMenuItem(
                      value: snapshot.data![index].id,
                      child: TextWidget(
                        lable: snapshot.data![index].id,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  value: currentModel,
                  onChanged: (value) {
                    setState(
                      () {
                        currentModel = value.toString();
                      },
                    );
                    modelProvider.setCurrentModel(value.toString());
                  },
                ),
            );
      },
    );
  }
}
