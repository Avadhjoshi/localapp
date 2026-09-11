class City_list{

  String CityId='';
  String CityName='';
  String  status='';
  List<City_list> data=[];

  City_list({
    required this.CityId,
    required this.CityName,
  });

  factory City_list.fromJson(Map<String, dynamic> json) {
    return City_list(
      CityId: json['CityId'] as String,
      CityName: json['CityName'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}



