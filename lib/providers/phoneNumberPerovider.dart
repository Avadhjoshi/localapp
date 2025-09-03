
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:localapp/component/show%20coustomMesage.dart';
import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sim_data_plus/sim_data.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';


final phoneNumberProvider = StateNotifierProvider<PhoneNumberNotifier,String?>((ref) {
  return PhoneNumberNotifier(null);
});


class PhoneNumberNotifier extends StateNotifier<String?> {
PhoneNumberNotifier(super.state);


// Future<void> getSimNumber(BuildContext context)async
// {
//
//
//
//   var d = await SimDataPlugin.getSimData();
//
//   Logger().t("Getting sim  total sims are  = ${d.cards}");
//   showMessage(context, "Getting sim  total sims are  = ${d.cards}");
//
//   for(var i in d.cards)
//     {
//       Logger().e("sim ${i.phoneNumber}");
//       showMessage(context, "sim ${i.phoneNumber}");
//     }
//
//   if(d.cards.length==0)
//     {
//       return ;
//     }
//
//
//   if(d.cards.first.phoneNumber!=null||d.cards.first.phoneNumber!.isEmpty)
//     {
//       state = d.cards.first.phoneNumber;
//     }
//
//   else if(d.cards.length>1)
//     {
//    if(d.cards[1].phoneNumber!=null||d.cards.first.phoneNumber!.isEmpty)
//   {
//     state = d.cards[1].phoneNumber;
//   }
//     }
//
//   if(state==null||state!.isEmpty)
//     {
//       showMessage(context, "No simCard Found");
//     }
//   Logger().e("3");
//
// }
//



  Future<void> getSimNumber(BuildContext context) async
  {

    var d = await MobileNumber.hasPhonePermission;

    if(d)
      {
        var sims = await MobileNumber.getSimCards;

        if(sims!=null && sims?.length!=0)
          {
            state = sims.first.number;
          }

        if(kDebugMode)
          {
            showMessage(context, 'sim Card Length is ${sims?.first.number}');
          }
        Logger().e("${sims}");

      }
    else{
      var d2 = await MobileNumber.requestPhonePermission;

      var grant = MobileNumber.hasPhonePermission;

    }
  }

Future <void> requestPermission()async
{
  Logger().e("Requisting Permission");
 var d  = await Permission.phone.request();
  Logger().e("Requested Permission");
 Logger().e(d);
}


}
