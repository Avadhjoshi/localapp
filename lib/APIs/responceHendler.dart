import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:localapp/component/show%20coustomMesage.dart';

class ResponceHandler {
  ResponceHandler(
    BuildContext context,
    http.Response response, {
    Function(dynamic)? onStatus_200,
    Function? onStatus_404,
    Function? onStatus_500,
    Function? unHandleException,
  }) {

    if(kDebugMode)
      {
        showMessage(context, "${response.statusCode}");
      }

    //
    //
    //Handling 200 Statue
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        try {
          var d = jsonDecode(response.body);
          if (onStatus_200 != null) {
            onStatus_200(d);
          }
        } catch (e) {
          if (onStatus_200 != null) {
            onStatus_200(null);
            showMessage(context, '$e');
          }
        }
      }
      return;
    }

    //
    //
    //Handle 404 Status
    if(response.statusCode==404)
      {
        if(onStatus_404!=null)
          {
            onStatus_404();
          }
        return;
      }
    //
    //
    //Handle 500 status
    if(response.statusCode==500)
      {
        if(onStatus_500!=null)
          {
            onStatus_500();
          }
        else
          {
            showMessage(context,'Internal Server Error');
          }
        return;
      }

    //
    //
    //

    if(unHandleException !=null)
      {
        unHandleException();
      }

  }
}
