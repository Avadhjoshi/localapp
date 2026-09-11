

import 'package:logger/logger.dart';

customLog({required String title,required String data})
{
   var log = Logger();

   log.e('${title} \n ${data}');
}