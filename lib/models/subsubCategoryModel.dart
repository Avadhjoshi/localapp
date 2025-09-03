// To parse this JSON data, do
//
//     final subSubCategoryResponce = subSubCategoryResponceFromJson(jsonString);

import 'dart:convert';

SubSubCategoryResponce subSubCategoryResponceFromJson(String str) => SubSubCategoryResponce.fromJson(json.decode(str));

String subSubCategoryResponceToJson(SubSubCategoryResponce data) => json.encode(data.toJson());

class SubSubCategoryResponce {
  String? success;
  List<SubSubCategory>? data;
  String? message;

  SubSubCategoryResponce({
    this.success,
    this.data,
    this.message,
  });

  factory SubSubCategoryResponce.fromJson(Map<String, dynamic> json) => SubSubCategoryResponce(
    success: json["success"],
    data: json["data"] == null ? [] : List<SubSubCategory>.from(json["data"]!.map((x) => SubSubCategory.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class SubSubCategory {
  String? subSubCategoryName;
  String? subSubCategoryId;

  SubSubCategory({
    this.subSubCategoryName,
    this.subSubCategoryId,
  });

  factory SubSubCategory.fromJson(Map<String, dynamic> json) => SubSubCategory(
    subSubCategoryName: json["SubSubCategoryName"],
    subSubCategoryId: json["SubSubCategoryId"],
  );

  Map<String, dynamic> toJson() => {
    "SubSubCategoryName": subSubCategoryName,
    "SubSubCategoryId": subSubCategoryId,
  };
}
