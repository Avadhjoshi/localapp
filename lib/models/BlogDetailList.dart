class Blog_Detail_list{

  String BlogPostId='';
  String Heading='';
  String Text='';
  String PostDisplayPhoto='';
  String  Status='';
  String TimeAgo='';
  String SubCategoryName='';
  String CategoryName='';
  String PostImage1='';
  String PostImage2='';
  String PostImage3='';
  String PostImage4='';
  String PostImage5='';
  String PostCategory='';
  String PostSubCategory='';
  String VideoLink;
  String ShareText;
  String ShareLink;
  String WhatsappText;
  String WhatsappNumber;
  String ContactDetail='';
  String TotalClicks='';
  String PostByName='';
  String RejectionComment='';
  String EndDate='';
  String Area = '';


  List<Blog_Detail_list> data=[];

  Blog_Detail_list({
    required this.BlogPostId,
    required this.Heading,
    required this.Text,
    required this.PostDisplayPhoto,
    required this.TimeAgo,
    required this.SubCategoryName,
    required this.CategoryName,
    required this.PostImage1,
    required this.PostImage2,
    required this.PostImage3,
    required this.PostImage4,
    required this.PostImage5,
    required this.PostCategory,
    required this.PostSubCategory,
    required this.VideoLink,
    required this.ShareLink,
    required this.ShareText,
    required this.WhatsappText,
    required this.WhatsappNumber,
    required this.ContactDetail,
    required this.Status,
    required this.TotalClicks,
    required this.PostByName,
    required this.RejectionComment,
    required this.EndDate,
    required this.Area,


  });

  factory Blog_Detail_list.fromJson(Map<String, dynamic> json) {
    return Blog_Detail_list(
      BlogPostId: json['BlogPostId'] as String,
      Heading: json['Heading'] ==null?'': json['Heading'] as String,
      Text: json['Text']==null?'': json['Text'] as String,
      PostDisplayPhoto: json['PostDisplayPhoto']==null?'': json['PostDisplayPhoto'] as String,
      TimeAgo: json['TimeAgo']==null?'': json['TimeAgo'] as String,
      SubCategoryName: json['SubCategoryName']==null?'': json['SubCategoryName'] as String,
      CategoryName: json['CategoryName']==null?'': json['CategoryName'] as String,
      PostImage1: json['PostImage1']==null?'': json['PostImage1'] as String,
      PostImage2: json['PostImage2']==null?'': json['PostImage2'] as String,
      PostImage3: json['PostImage3']==null?'': json['PostImage3'] as String,
      PostImage4: json['PostImage4']==null?'': json['PostImage4'] as String,
      PostImage5: json['PostImage5']==null?'': json['PostImage5'] as String,
      PostCategory: json['PostCategory']==null?'': json['PostCategory'] as String,
      PostSubCategory: json['PostSubCategory']==null?'': json['PostSubCategory'] as String,
      VideoLink: json['VideoLink']==null?'': json['VideoLink'] as String,
      ShareLink: json['ShareLink']==null?'': json['ShareLink'] as String,
      ShareText: json['ShareText']==null?'': json['ShareText'] as String,
      WhatsappText: json['WhatsappText']==null?'': json['WhatsappText'] as String,
      WhatsappNumber: json['WhatsappNumber']==null?'': json['WhatsappNumber'] as String,
      ContactDetail: json['ContactDetail']==null?'': json['ContactDetail'] as String,
      Status: json['Status']==null?'': json['Status'] as String,
      TotalClicks: json['TotalClicks']==null?'': json['TotalClicks'] as String,
      PostByName: json['PostByName']==null?'': json['PostByName'] as String,
      RejectionComment: json['RejectionComment']==null?'': json['RejectionComment'] as String,
      EndDate: json['EndDate']==null?'': json['EndDate'] as String,
      Area: json['Area']==null?'': json['Area'].toString(),



    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}



