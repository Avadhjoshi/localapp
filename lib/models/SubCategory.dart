class SubCategory_list{

  String SubCategoryId='';
  String SubCategoryName='';
  String  status='';
  List<SubCategory_list> data=[];

  SubCategory_list({
    required this.SubCategoryId,
    required this.SubCategoryName,
  });

  factory SubCategory_list.fromJson(Map<String, dynamic> json) {
    return SubCategory_list(
      SubCategoryId: json['SubCategoryId'] as String,
      SubCategoryName: json['SubCategoryName'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}



