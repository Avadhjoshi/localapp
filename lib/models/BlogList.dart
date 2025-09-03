// To parse this JSON data, do
//
//     final blogList = blogListFromJson(jsonString);

import 'dart:convert';

Blog_list blogListFromJson(String str) => Blog_list.fromJson(json.decode(str));

String blogListToJson(Blog_list data) => json.encode(data.toJson());

class Blog_list {
  String? blogPostId;
  String? cityId;
  String? postCategory;
  String? postSubCategory;
  String? postDisplayPhoto;
  String? postImage1;
  dynamic postImage2;
  dynamic postImage3;
  String? postImage4;
  String? postImage5;
  String? videoLink;
  String? heading;
  String? text;
  String? isActive;
  String? displaySequence;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? createdDateTime;
  DateTime? updatedDateTime;
  String? totalClicks;
  String? shareText;
  String? shareLink;
  dynamic shareMessage;
  String? whatsappNumber;
  String? whatsappText;
  String? postById;
  String? postByName;
  String? contactOn;
  String? contactDetail;
  String? status;
  String? rejectionComment;
  String? subCategoryName;
  String? timeAgo;
  String? categoryName;
  String? area;

  Blog_list({
    this.blogPostId,
    this.cityId,
    this.postCategory,
    this.postSubCategory,
    this.postDisplayPhoto,
    this.postImage1,
    this.postImage2,
    this.postImage3,
    this.postImage4,
    this.postImage5,
    this.videoLink,
    this.heading,
    this.text,
    this.isActive,
    this.displaySequence,
    this.startDate,
    this.endDate,
    this.createdDateTime,
    this.updatedDateTime,
    this.totalClicks,
    this.shareText,
    this.shareLink,
    this.shareMessage,
    this.whatsappNumber,
    this.whatsappText,
    this.postById,
    this.postByName,
    this.contactOn,
    this.contactDetail,
    this.status,
    this.rejectionComment,
    this.subCategoryName,
    this.timeAgo,
    this.categoryName,
    this.area,
  });

  factory Blog_list.fromJson(Map<String, dynamic> json) => Blog_list(
        blogPostId: json["BlogPostId"],
        cityId: json["CityId"],
        postCategory: json["PostCategory"],
        postSubCategory: json["PostSubCategory"],
        postDisplayPhoto: json["PostDisplayPhoto"],
        postImage1: json["PostImage1"],
        postImage2: json["PostImage2"],
        postImage3: json["PostImage3"],
        postImage4: json["PostImage4"],
        postImage5: json["PostImage5"],
        videoLink: json["VideoLink"],
        heading: json["Heading"],
        text: json["Text"],
        area: json["Area"],
        isActive: json["IsActive"],
        displaySequence: json["DisplaySequence"],
        startDate: json["StartDate"] == null || json["StartDate"] == ""
            ? null
            : DateTime.parse(json["StartDate"]),
        endDate: json["EndDate"] == null || json["EndDate"] == ""
            ? null
            : DateTime.parse(json["EndDate"]),
        createdDateTime:
            json["CreatedDateTime"] == null || json["CreatedDateTime"] == ""
                ? null
                : DateTime.parse(json["CreatedDateTime"]),
        updatedDateTime:
            json["UpdatedDateTime"] == null && json["UpdatedDateTime"] == ""
                ? null
                : DateTime.parse(json["UpdatedDateTime"]),
        totalClicks: json["TotalClicks"],
        shareText: json["ShareText"],
        shareLink: json["ShareLink"],
        shareMessage: json["ShareMessage"],
        whatsappNumber: json["WhatsappNumber"],
        whatsappText: json["WhatsappText"],
        postById: json["PostById"],
        postByName: json["PostByName"],
        contactOn: json["ContactOn"],
        contactDetail: json["ContactDetail"],
        status: json["Status"],
        rejectionComment: json["RejectionComment"],
        subCategoryName: json["SubCategoryName"],
        timeAgo: json["TimeAgo"],
        categoryName: json["CategoryName"],
      );

  Map<String, dynamic> toJson() => {
        "BlogPostId": blogPostId,
        "CityId": cityId,
        "PostCategory": postCategory,
        "PostSubCategory": postSubCategory,
        "PostDisplayPhoto": postDisplayPhoto,
        "PostImage1": postImage1,
        "PostImage2": postImage2,
        "PostImage3": postImage3,
        "PostImage4": postImage4,
        "PostImage5": postImage5,
        "VideoLink": videoLink,
        "Heading": heading,
        "Text": text,
        "IsActive": isActive,
        "DisplaySequence": displaySequence,
        "StartDate":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "EndDate":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "CreatedDateTime": createdDateTime?.toIso8601String(),
        "UpdatedDateTime": updatedDateTime?.toIso8601String(),
        "TotalClicks": totalClicks,
        "ShareText": shareText,
        "ShareLink": shareLink,
        "ShareMessage": shareMessage,
        "WhatsappNumber": whatsappNumber,
        "WhatsappText": whatsappText,
        "PostById": postById,
        "PostByName": postByName,
        "ContactOn": contactOn,
        "ContactDetail": contactDetail,
        "Status": status,
        "RejectionComment": rejectionComment,
        "SubCategoryName": subCategoryName,
        "TimeAgo": timeAgo,
    "Area": area,
    "CategoryName":categoryName
      };
}
