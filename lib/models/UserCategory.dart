// To parse this JSON data, do
//
//     final userCategoryList = userCategoryListFromJson(jsonString);

import 'dart:convert';

User_Category_list userCategoryListFromJson(String str) => User_Category_list.fromJson(json.decode(str));

String userCategoryListToJson(User_Category_list data) => json.encode(data.toJson());

class User_Category_list {
  String categoryName;
  String categoryId;
  String categoryImage;
  String cityId;
  String displaySequence;
  String isActive;
  String descriptionPlaceholder;
  String allowPost;
  String categoryLabel;
  String subSubCategoryLabel;
  String privacyType;
  String privacyImage;
  String whatsappNumber;
  String whatsappText;

  User_Category_list({
    this.categoryName ='',
    this.categoryId ='',
    this.categoryImage ='',
    this.cityId ='',
    this.displaySequence ='',
    this.isActive ='',
    this.descriptionPlaceholder ='',
    this.allowPost ='',
    this.categoryLabel ='',
    this.subSubCategoryLabel ='',
    this.privacyType ='',
    this.privacyImage ='',
    this.whatsappNumber ='',
    this.whatsappText ='',
  });

  factory User_Category_list.fromJson(Map<String, dynamic> json) => User_Category_list(
    categoryName: json["CategoryName"]==null?'':json["CategoryName"],
    categoryId: json["CategoryId"]==null?'':json["CategoryId"],
    categoryImage: json["CategoryImage"]==null?'':json["CategoryImage"],
    cityId: json["CityId"]==null?'':json["CityId"],
    displaySequence: json["DisplaySequence"]==null?'':json["DisplaySequence"],
    isActive: json["IsActive"]==null?'':json["IsActive"],
    descriptionPlaceholder: json["DescriptionPlaceholder"]==null?'':json["DescriptionPlaceholder"],
    allowPost: json["AllowPost"]==null?'':json["AllowPost"],
    categoryLabel: json["CategoryLabel"]==null?'':json["CategoryLabel"],
    subSubCategoryLabel: json["SubSubCategoryLabel"]==null?'':json["SubSubCategoryLabel"],
    privacyType: json["PrivacyType"]==null?'':json["PrivacyType"],
    privacyImage: json["PrivacyImage"]==null?'':json["PrivacyImage"],
    whatsappNumber: json["WhatsappNumber"]==null?'':json["WhatsappNumber"],
    whatsappText: json["WhatsappText"]==null?'':json["WhatsappText"],
  );

  Map<String, dynamic> toJson() => {
    "CategoryName": categoryName,
    "CategoryId": categoryId,
    "CategoryImage": categoryImage,
    "CityId": cityId,
    "DisplaySequence": displaySequence,
    "IsActive": isActive,
    "DescriptionPlaceholder": descriptionPlaceholder,
    "AllowPost": allowPost,
    "CategoryLabel": categoryLabel,
    "SubSubCategoryLabel": subSubCategoryLabel,
    "PrivacyType": privacyType,
    "PrivacyImage": privacyImage,
    "WhatsappNumber": whatsappNumber,
    "WhatsappText": whatsappText,
  };
}
