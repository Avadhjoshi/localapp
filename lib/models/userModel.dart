// To parse this JSON data, do
//
//     final getUserApiResponce = getUserApiResponceFromJson(jsonString);

import 'dart:convert';

GetUserApiResponce getUserApiResponceFromJson(String str) => GetUserApiResponce.fromJson(json.decode(str));

String getUserApiResponceToJson(GetUserApiResponce data) => json.encode(data.toJson());

class GetUserApiResponce {
  String? success;
  User? data;
  String? message;

  GetUserApiResponce({
    this.success,
    this.data,
    this.message,
  });

  factory GetUserApiResponce.fromJson(Map<String, dynamic> json) => GetUserApiResponce(
    success: json["success"],
    data: json["data"] == null ? null : User.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "message": message,
  };
}

class User {
  String? profileId;
  String? deviceId;
  String? name;
  dynamic gender;
  dynamic cityId;
  dynamic areaId;
  String? mobileNumber1;
  dynamic mobileNumber2;
  dynamic isActive;
  dynamic status;
  String? deviceToken;
  dynamic lastVisitDate;
  String? groupAccess;
  dynamic totalVisitCount;
  String? totalContactsVisited;
  DateTime? createdDateTime;
  DateTime? updatedDateTime;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic remarks;
  String? uploading;

  User({
    this.profileId,
    this.deviceId,
    this.name,
    this.gender,
    this.cityId,
    this.areaId,
    this.mobileNumber1,
    this.mobileNumber2,
    this.isActive,
    this.status,
    this.groupAccess,
    this.deviceToken,
    this.lastVisitDate,
    this.totalVisitCount,
    this.totalContactsVisited,
    this.createdDateTime,
    this.updatedDateTime,
    this.createdBy,
    this.updatedBy,
    this.remarks,
    this.uploading,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    profileId: json["ProfileId"],
    deviceId: json["DeviceId"],
    name: json["Name"],
    gender: json["Gender"],
    cityId: json["CityId"],
    areaId: json["AreaId"],
    mobileNumber1: json["MobileNumber1"],
    mobileNumber2: json["MobileNumber2"],
    isActive: json["IsActive"],
    status: json["Status"],
    deviceToken: json["DeviceToken"],
    lastVisitDate: json["LastVisitDate"],
    totalVisitCount: json["TotalVisitCount"],
    totalContactsVisited: json["TotalContactsVisited"],
    createdDateTime: json["CreatedDateTime"] == null ? null : DateTime.parse(json["CreatedDateTime"]),
    updatedDateTime: json["UpdatedDateTime"] == null ? null : DateTime.parse(json["UpdatedDateTime"]),
    createdBy: json["CreatedBy"],
    updatedBy: json["UpdatedBy"],
    remarks: json["Remarks"],
    uploading: json["Uploading"],
    groupAccess: json["GroupAccess"],
  );

  Map<String, dynamic> toJson() => {
    "ProfileId": profileId,
    "DeviceId": deviceId,
    "Name": name,
    "Gender": gender,
    "CityId": cityId,
    "AreaId": areaId,
    "MobileNumber1": mobileNumber1,
    "MobileNumber2": mobileNumber2,
    "IsActive": isActive,
    "Status": status,
    "DeviceToken": deviceToken,
    "LastVisitDate": lastVisitDate,
    "TotalVisitCount": totalVisitCount,
    "TotalContactsVisited": totalContactsVisited,
    "CreatedDateTime": createdDateTime?.toIso8601String(),
    "UpdatedDateTime": updatedDateTime?.toIso8601String(),
    "CreatedBy": createdBy,
    "UpdatedBy": updatedBy,
    "Remarks": remarks,
    "Uploading": uploading,
    "GroupAccess": groupAccess,
  };
}
