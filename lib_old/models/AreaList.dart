class Area_list{

  String AreaId='';
  String AreaName='';
  String SearchKeyword='';
  String DisplayPhoto='';
  String  status='';
  String TimeAgo='';
  String SubCategoryName='';
  List<Area_list> data=[];

  Area_list({
    required this.AreaId,
    required this.AreaName,
    required this.SearchKeyword,
    required this.DisplayPhoto,
    required this.TimeAgo,
    required this.SubCategoryName

  });

  factory Area_list.fromJson(Map<String, dynamic> json) {
    return Area_list(
      AreaId:json['AreaId']==null?'': json['AreaId'] as String,
      AreaName: json['AreaName'] as String,
      SearchKeyword: json['SearchKeyword']==null?'': json['SearchKeyword'] as String,
      DisplayPhoto: json['DisplayPhoto']==null?'NoImageFound.png': json['DisplayPhoto'] as String,
      TimeAgo: json['TimeAgo']==null?'': json['TimeAgo'] as String,
      SubCategoryName: json['SubCategoryName']==null?'': json['SubCategoryName'] as String,



    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}



