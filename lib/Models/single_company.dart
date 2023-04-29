class SingleCompanyModel {
  int? id;
  String? name;
  String? about;
  String? image;

  SingleCompanyModel({this.id, this.name, this.about, this.image});

  SingleCompanyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    about = json['about'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['about'] = about;
    data['image'] = image;
    return data;
  }
}
