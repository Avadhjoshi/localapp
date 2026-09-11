class LocalAd_list{

  String AdId='';
  String AdImage='';
  String DisplaySequence='';
  String Url='';
  String WhatsappNumber='';
  String WhatsappText='';

  String  status='';
  List<LocalAd_list> data=[];

  LocalAd_list({
    required this.AdId,
    required this.AdImage,
    required this.DisplaySequence,
    required this.Url,
    required this.WhatsappNumber,
    required this.WhatsappText
  });

  factory LocalAd_list.fromJson(Map<String, dynamic> json) {
    return LocalAd_list(
      AdId: json['AdId'] as String,
      AdImage: json['AdImage']==null?"": json['AdImage'] as String,
      DisplaySequence: json['DisplaySequence'] as String,
      Url: json['Url']==null?'':json['Url'] as String,
      WhatsappNumber: json['WhatsappNumber']==null?'':json['WhatsappNumber'] as String,
      WhatsappText: json['WhatsappText']==null?'':json['WhatsappText'] as String,

    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}



