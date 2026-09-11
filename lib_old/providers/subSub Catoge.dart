import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:localapp/APIs/Api.dart';
import 'package:localapp/component/show%20coustomMesage.dart';
import 'package:localapp/constants/Config.dart';
import 'package:localapp/models/Susteom%20Print.dart';
import 'package:localapp/models/subsubCategoryModel.dart';
import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

final subSubCategoryProvider =
    StateNotifierProvider<SubSubCategoryNotifier, List<SubSubCategory>>((ref) {
  return SubSubCategoryNotifier([]);
});

class SubSubCategoryNotifier extends StateNotifier<List<SubSubCategory>> {
  SubSubCategoryNotifier(super.state);

  bool _loading = false;

  bool get  isLoading => _loading;

  //Lode
  Future<void> lodeCategory(BuildContext context,String categoryId) async {

    _loading = true;
    state = [];

    var resp = await CategoryApi().getSubSubCategory(categoryId);

    if(resp.statusCode==200)
      {
        var decode = jsonDecode(resp.body);
        logger.t(" sub Sub Cat \n$decode");
        var data = SubSubCategoryResponce.fromJson(decode);
        _loading = false;
        state = data.data??[];
      }
    else if(resp.statusCode==404)
      {
        showMessage(context, "No Category Found");
        _loading= false;
        state = [];
      }
    else if(resp.statusCode==500)
      {
        _loading = false;
        state = [];
        showMessage(context, "Server Error");
      }
    else
      {
        _loading  = false;
        state = [];
        customLog(title: "responce frome subSub Category ${resp.statusCode}", data: "${resp.body}");
        showMessage(context, "Something Wrong");
      }
  }

  //clean
clean()
{
  _loading = false;
  state = [];
  Logger().e('Sub Sub Category clear');
}
}
