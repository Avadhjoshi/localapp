

import 'package:flutter/foundation.dart';
import 'package:localapp/APIs/Api.dart';
import 'package:localapp/APIs/responceHendler.dart';
import 'package:localapp/component/show%20coustomMesage.dart';

Future<void> insertLog(context,{
  required String deviceId,
  required String id,
  required String type,
})async{

  var resp = await CategoryApi().insertLog(postById: deviceId, id: id, type: type);
  ResponceHandler(context, resp,

    //
    onStatus_200: (d){
    if(kDebugMode)
      {
        showMessage(context, "Log Inserted Done");
      }

      },

    //
    onStatus_404: (){
    showMessage(context, "404");
    }


  );



}