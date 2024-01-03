class TimeModel {
  late String title;
  late String time;

  TimeModel({required this.title, required this.time});

  factory TimeModel.fromMap(Map<String, dynamic> map) {
    return TimeModel(
      title: map['title'],
      time: map['time'],
    );
  }

  // Convert Chat object to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'time': time,
    };
  }
}
