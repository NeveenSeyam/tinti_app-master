class NotificationModel {
  List<Notifications>? notifications;
  String? message;

  NotificationModel({this.notifications, this.message});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(new Notifications.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Notifications {
  int? id;
  String? notificationText;
  String? date;

  Notifications({this.id, this.notificationText, this.date});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    notificationText = json['notification_text'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['notification_text'] = this.notificationText;
    data['date'] = this.date;
    return data;
  }
}
