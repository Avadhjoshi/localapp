class Directory_list{

  String ContactId='';
  String FullName='';
  String Description='';
  String DisplayPhoto='';
  String Photo1='';
  String Photo2='';
  String Photo3='';
  String Photo4='';
  String Photo5='';
  String  status='';
  String TimeAgo='';
  String CallingNumber='';
  String SubCategoryName='';
  String IDVerified='';
  String WhatsappNumber='';
  String AlternateNumber='';
  String ShortDesc='';
  String Category='';
  String SubCategory='';
  String ServiceRange='';
  String CategoryName='';
  List<Directory_list> data=[];

  Directory_list({
    required this.ContactId,
    required this.FullName,
    required this.Description,
    required this.DisplayPhoto,
    required this.Photo1,
    required this.Photo2,
    required this.Photo3,
    required this.Photo4,
    required this.Photo5,
    required this.TimeAgo,
    required this.SubCategoryName,
    required this.IDVerified,
    required this.CallingNumber,
    required this.WhatsappNumber,
    required this.AlternateNumber,
    required this.ShortDesc,
    required this.Category,
    required this.SubCategory,
    required this.ServiceRange,
    required this.CategoryName,

  });

  factory Directory_list.fromJson(Map<String, dynamic> json) {
    return Directory_list(
      ContactId: json['ContactId']==null?'':json['ContactId'] as String,
      FullName: json['FullName']==null?'':json['FullName'] as String,
      Description: json['Description'] ==null?'':json['Description'] as String,
      DisplayPhoto: json['DisplayPhoto']==null?'': json['DisplayPhoto'] as String,
      Photo1: json['Photo1']==null?'': json['Photo1'] as String,
      Photo2: json['Photo2']==null?'': json['Photo2'] as String,
      Photo3: json['Photo3']==null?'': json['Photo3'] as String,
      Photo4: json['Photo4']==null?'': json['Photo4'] as String,
      Photo5: json['Photo5']==null?'': json['Photo5'] as String,
      TimeAgo: json['TimeAgo']==null?'': json['TimeAgo'] as String,
      SubCategoryName: json['SubCategoryName']==null?'': json['SubCategoryName'] as String,
      IDVerified: json['IDVerified']==null?'': json['IDVerified'] as String,
      CallingNumber: json['CallingNumber']==null?'': json['CallingNumber'] as String,
      WhatsappNumber: json['WhatsappNumber']==null?'': json['WhatsappNumber'] as String,
      AlternateNumber: json['AlternateNumber']==null?'': json['AlternateNumber'] as String,
      ShortDesc: json['ShortDesc']==null?'': json['ShortDesc'] as String,
      Category: json['Category']==null?'': json['Category'] as String,
      SubCategory: json['SubCategory']==null?'': json['SubCategory'] as String,
      ServiceRange: json['ServiceRange']==null?'': json['ServiceRange'] as String,
      CategoryName: json['CategoryName']==null?'': json['CategoryName'] as String,




    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}



