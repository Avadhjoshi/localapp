import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showMessage(BuildContext context, String data) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    padding: EdgeInsets.zero,
    behavior: SnackBarBehavior.floating,
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Center(child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(.8),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              // BoxShadow(
              //   blurStyle: BlurStyle.outer,
              //   color: Colors.black,
              //
              //   blurRadius: 3,
              //
              // )
            ]
          ),
          child: Text(data,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 17),),
      ))));
}
