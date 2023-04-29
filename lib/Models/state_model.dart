class StateModel {
  String? name;
  String? description;
  String? code;
  bool? isActive;
  int? id;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;

  StateModel(
      {this.name,
      this.description,
      this.code,
      this.isActive,
      this.id,
      this.createdOn,
      this.createdBy,
      this.modifiedOn,
      this.modifiedBy});

  StateModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    code = json['code'];
    isActive = json['isActive'];
    id = json['id'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['code'] = this.code;
    data['isActive'] = this.isActive;
    data['id'] = this.id;
    data['createdOn'] = this.createdOn;
    data['createdBy'] = this.createdBy;
    data['modifiedOn'] = this.modifiedOn;
    data['modifiedBy'] = this.modifiedBy;
    return data;
  }
}
