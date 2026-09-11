class SubSubCategory_list{

  String SubSubCategoryId='';
  String SubSubCategoryName='';
  String  status='';
  List<SubSubCategory_list> data=[];

  SubSubCategory_list({
    required this.SubSubCategoryId,
    required this.SubSubCategoryName,
  });

  factory SubSubCategory_list.fromJson(Map<String, dynamic> json) {
    return SubSubCategory_list(
      SubSubCategoryId: json['SubSubCategoryId'] as String,
      SubSubCategoryName: json['SubSubCategoryName'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}



