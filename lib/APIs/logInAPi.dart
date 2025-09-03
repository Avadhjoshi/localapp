import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localapp/constants/Config.dart';
import 'package:logger/logger.dart';
import 'package:geolocator/geolocator.dart';

class LogApis{
  final _log = Logger();



  Future<http.Response> getUser(String deviceId) async
  {
    String uri = Config.get_user;

    var resp = await http.post(Uri.parse(uri),body: {"PostById":deviceId});

    return resp;
  }



  Future<http.Response> updateMobNumberAndLocation({required String postById,String? mobileNumber2,required Position location}) async
  {
    String uri = Config.update_Profile;

    var d = {
      "PostById":postById,
      "Latitude":location.latitude.toString(),
      "Longitude":location.longitude.toString(),
      "MobileNumber2":mobileNumber2,
    };

    //
    var _fd = {};
    d.forEach((key, value) {
      if(value!=null)
        {
          _fd[key] = value;
        }
    });

    //
    var resp = await http.post(Uri.parse(uri),body: _fd);

    return resp;
  }


  Future<http.Response> updateProfile({
    String? postById,
    String? name,
    String? mobileNumber1,
}) async
  {

    String uri = Config.update_Profile;

    var _data = {
      "PostById":postById,
      "Name":name,
      "MobileNumber1":mobileNumber1,

    };

    Map _filterData = {};

    _data.forEach((key, value) {
      if(value!=null)
        {
          _filterData[key]=value;
        }
    });

    var resp = await http.post(Uri.parse(uri),body: _filterData);

    return resp;

  }

}