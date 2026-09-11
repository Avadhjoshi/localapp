import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localapp/component/customFeild.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localapp/component/show%20coustomMesage.dart';
import 'package:localapp/constants/Config.dart';
import 'package:localapp/providers/profieleDataProvider.dart';
import 'package:logger/logger.dart';

Future<void> openLogInDialog(BuildContext context) async {



  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  // GlobalKey<FormFieldState> _formKey3 = GlobalKey<FormFieldState>();



  final style = TextStyle(
    fontWeight: FontWeight.w500,
    color: Colors.grey.shade800,
  );
  await showDialog(
      context: context,
      builder: (context) => WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide.none),

              // contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 20),
              insetPadding: EdgeInsets.symmetric(horizontal: 30),

              content: Consumer(
                builder: (a, ref, c) {

                  logger.t("ashgdfasdfa");

                  ref.watch(profileProvider);

                  var profileProviderState =
                      ref.watch(profileProvider.notifier);

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      if(kDebugMode)
                        IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close)),

                      //
                      Text(
                        "For us to show you relevant information, we need to know you better.",
                        style: style,
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      //
                      Text(
                        "Your Name",
                        style: style,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: CustomField(
                          validator: (s){
                            if(s!.isEmpty)
                              {
                                return "Please Enter Your Name";
                              }
                            else if(s.length<2)
                              {
                                return "Please Enter At Least 2 Character";
                              }
                          },
                          hintText: "Type Your Name here",
                          controller: ref.watch(profileProvider.notifier).nameController,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      //
                      Text(
                        "10 Digit Whatsapp Number",
                        style: style,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Form(
                        key: _formKey2,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: CustomField(
                          validator: (s) {
                            if(s!.isEmpty)
                              {
                                return "Please Enter Whatsapp Number";
                              }
                            else if(s.trim().length<10)
                              {
                                return 'Please Enter Valid Mobile Number';
                              }

                          },
                          inputType: TextInputType.number,
                          hintText: "10 Digit Whatsapp Number",
                          controller: ref.watch(profileProvider.notifier).phoneNumController,
                          formatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      //
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          "This Whatsapp number will NOT be visible to other users in the app. It is solely used for creating your profile.",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.blue.shade300,
                              fontSize: 13),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      //
                      SizedBox(
                          width: double.maxFinite,
                          child: Consumer(

                            builder: (context, ref, child) {


                              return ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                              (states) => ref.watch(profileProvider.notifier).submitted?Colors.green:Colors.grey.shade900),
                                      shape: MaterialStateProperty.resolveWith(
                                              (states) => RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(60)))),
                                  onPressed: () {
                                    if(_formKey.currentState!.validate()&&_formKey2.currentState!.validate())
                                      {
                                        ref
                                            .read(profileProvider.notifier)
                                            .updateProfile(
                                            context: context);
                                      }
                                  },
                                  child:Text(ref.watch(profileProvider.notifier).submitted?"Submitted":"Submit"));
                            }
                          ))
                    ],
                  );
                },
              ),
            ),
          ));
}
