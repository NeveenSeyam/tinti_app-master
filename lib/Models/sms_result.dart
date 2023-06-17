class SMSResultModel {
  dynamic? code;
  String? message;
  dynamic? id;

  SMSResultModel({this.code, this.message, this.id});

  SMSResultModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['id'] = this.id;
    return data;
  }
}
