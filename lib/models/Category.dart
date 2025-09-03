class Category_list{

  String CategoryId='';
  String CategoryName='';
  String  status='';
  String DisplaySequence='';
  String CategoryPhoto='';
  String DescriptionPlaceholder='';
  List<Category_list> data=[];

  Category_list({
    required this.CategoryId,
    required this.CategoryName,
    required this.DisplaySequence,
    required this.CategoryPhoto,
    required this.DescriptionPlaceholder
  });

  factory Category_list.fromJson(Map<String, dynamic> json) {
    return Category_list(
      CategoryId: json['CategoryId'] as String,
      CategoryName: json['CategoryName'] as String,
      DisplaySequence: json['DisplaySequence']==null?'0':json['DisplaySequence'] as String,
      CategoryPhoto: json['CategoryPhoto']==null?'0':json['CategoryPhoto'] as String,
      DescriptionPlaceholder: json['DescriptionPlaceholder']==null?'0':json['DescriptionPlaceholder'] as String,

    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}



