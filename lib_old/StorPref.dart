import 'package:shared_preferences/shared_preferences.dart';


class LocalDb
{

  Future <void> savePrevArea(String areaName)async{
    var sp = await SharedPreferences.getInstance();
    await sp.setString("localArea", areaName);
  }

  Future<String?> getPrevArea()async {
    var sp = await SharedPreferences.getInstance();
    String? area = sp.getString("localArea");
    return area;
  }

}