class ContactDataModel {
  List<Info>? info;
  String? message;

  ContactDataModel({this.info, this.message});

  ContactDataModel.fromJson(Map<String, dynamic> json) {
    if (json['info'] != null) {
      info = <Info>[];
      json['info'].forEach((v) {
        info!.add(new Info.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Info {
  String? address;
  String? mobile;
  String? email;
  String? facebook;
  String? twitter;
  String? instagram;

  Info(
      {this.address,
      this.mobile,
      this.email,
      this.facebook,
      this.twitter,
      this.instagram});

  Info.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    mobile = json['mobile'];
    email = json['email'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    instagram = json['instagram'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['facebook'] = this.facebook;
    data['twitter'] = this.twitter;
    data['instagram'] = this.instagram;
    return data;
  }
}
