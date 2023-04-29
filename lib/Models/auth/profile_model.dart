class ProfileModel {
  User? user;
  String? message;

  ProfileModel({this.user, this.message});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class User {
  int? id;
  String? fname;
  String? lname;
  String? email;
  String? mobile;
  String? address;
  String? img;

  User(
      {this.id,
      this.fname,
      this.lname,
      this.email,
      this.mobile,
      this.address,
      this.img});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fname = json['fname'];
    lname = json['lname'];
    email = json['email'];
    mobile = json['mobile'];
    address = json['address'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['img'] = this.img;
    return data;
  }
}
