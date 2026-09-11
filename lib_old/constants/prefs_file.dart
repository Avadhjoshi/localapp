import 'dart:convert';


import 'package:shared_preferences/shared_preferences.dart';

class Prefs {

  final  _LoggedIn = "_LoggedIn";
  final  phone_num = "phone_num";
  final  fname = "fname";
  final  user_name = "user_name";
  final  _member_id = "_member_id";

  final  recent_id = "recent_id";
  final  recent_image = "recent_image";

  final  post_desc = "post_desc";
  final  post_name = "post_name";
  final post_contact="post_contact";

  final post_uploading="post_uploading";
  final first_instaled = "first_installed";

  Future<String> getpost_uploading() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(post_uploading) ?? 'No';
  }

  Future<bool> setpost_uploading(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(post_uploading, value);
  }

  Future<String> getpost_contact() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(post_contact) ?? '';
  }

  Future<bool> setpost_contact(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(post_contact, value);
  }



  Future<String> getpost_desc() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(post_desc) ?? '';
  }

  Future<bool> setpost_desc(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(post_desc, value);
  }


  Future<String> getpost_name() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(post_name) ?? '';
  }

  Future<bool> setpost_name(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(post_name, value);
  }


  Future<String> getrecent_id() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(recent_id) ?? '0';
  }

  Future<bool> setrecent_id(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(recent_id, value);
  }




  Future<String> getrecent_image() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(recent_image) ?? '0';
  }

  Future<bool> setrecent_image(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(recent_image, value);
  }

  Future<String> isuser_name() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(user_name) ?? 'Guest';
  }

  Future<bool> setuser_name(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(user_name, value);
  }



logout() async{
  final pref = await SharedPreferences.getInstance();
  await pref.clear();
}

    getAllPrefsClear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("_LoggedIn");
  }



  Future<String> ismember_id() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_member_id) ?? '0';
  }

  Future<bool> setmember_id(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_member_id, value);
  }


  //-------------------Login id ------------------------//

  Future<String> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_LoggedIn) ?? '0';
  }

  Future<bool> setLoggedIn(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_LoggedIn, value);
  }

  //----------------- phone_num----------------------//

  Future<String> isphone_num() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(phone_num) ?? '0';
  }

  Future<bool> setphone_num(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(phone_num, value);
  }

  Future<String> isfname() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(fname) ?? 'Guest';
  }

  Future<bool> setfname(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(fname, value);
  }



  Future<bool> checkUserFirstInstalled() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(first_instaled)??true;
  }

  Future<void> setInstallStatus(bool status) async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(first_instaled, status);
  }



}
