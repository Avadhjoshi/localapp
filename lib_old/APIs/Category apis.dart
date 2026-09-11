import 'package:http/http.dart' as http;
import 'package:localapp/APIs/responceHendler.dart';
import 'package:localapp/constants/Config.dart';


class CategoryApi
{

  Future<http.Response> getSubSubCategory(String categoryID)async
  {
    String uri = Config.get_subSub_Categoey;

    var resp = await http.post(Uri.parse(uri),body: {"subcategory_id":categoryID});

    return resp;
  }



  Future<http.Response> insertLog({
    required String postById,
    required String id,
    required String type,
}) async
  {

    String uri = Config.insert_log;

    var dateTime = DateTime.now();

    var date= {
      'user_id':postById,
      'id':id,
      'type':type,
    };
    var resp = await http.post(Uri.parse(uri),body: date);

    return resp;

  }

}


