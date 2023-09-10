import 'package:flutter/cupertino.dart';
import 'package:untitled/models/Models.dart';
import 'package:untitled/services/apiServices.dart';

class ModelProvider with ChangeNotifier{
  List<Models> modelsList=[];
  String currentModel="gpt-3.5-turbo-0301";
  List<Models> get getmodelsList{
    return modelsList;
  }
  Future<List<Models>> getModels()async {
    modelsList=await ApiServices.getApiResponse();
    return modelsList;
}
  String get getCurrentModel{
    return currentModel;
  }
  void setCurrentModel(String newModel)
  {
    currentModel=newModel;
    notifyListeners();
  }

}