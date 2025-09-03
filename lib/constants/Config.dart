import 'package:logger/logger.dart';

class Config {
  static String Main_Link = "https://shubhapp.com/local_app/api/";
  // static String Main_Link = "https://mirzapurmetalcraft.in/api/";
  static String Image_Path = "https://shubhapp.com/local_app/uploads/";
  // static String Image_Path = "https://mirzapurmetalcraft.in/uploads/";
  static String signup = Main_Link + "signup";
  static String get_home = Main_Link + "get_home";
  static String get_city = Main_Link + "get_city";
  static String get_city_area = Main_Link + "get_city_area";
  static String get_contacts = Main_Link + "get_contacts";
  static String get_blogs = Main_Link + "get_blogs";
  static String get_sub_category = Main_Link + "get_sub_category";
  static String get_blog_data = Main_Link + "get_blog_data";
  static String get_user_post_category = Main_Link + "get_user_post_category";
  static String get_search_city_area = Main_Link + "get_search_city_area";
  static String get_area_home = Main_Link + "get_area_home";
  static String get_contact_home = Main_Link + "get_contact_home";
  static String get_search_area_home = Main_Link + "get_search_area_home";
  static String get_directory_data = Main_Link + "get_directory_data";
  static String get_category = Main_Link + "get_category";
  static String get_category_data = Main_Link + "get_category_data";
  static String post_upload = Main_Link + "post_upload";
  static String get_my_post = Main_Link + "get_my_post";
  static String get_setup = Main_Link + "get_setup";
  static String update_upload = Main_Link + "update_upload";
  static String delete_post = Main_Link + "delete_post";
  static String insert_ad_response = Main_Link + "insert_ad_response";
  static String get_subSub_Categoey = Main_Link + "get_subsub_category";
  static String get_user = Main_Link + "get_user";
  static String insert_log = Main_Link + "app_log";
  static String update_Profile = Main_Link + "update_profile";
}

Logger logger = Logger();
