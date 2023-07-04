import 'package:cuts/models/ScheduleModel.dart';

class ScheduleList {
  int? id;
  int id_store;
  List<ScheduleModel> list;

  ScheduleList({
    this.id,
    required this.id_store,
    required this.list,
  });

  factory ScheduleList.fromJson(Map<String, dynamic> json) {
    var schedule = json['scheduleList'].toString().replaceAll(r"\", "");
    return ScheduleList(
      id: json['id'],
      id_store: json['id_store'],
      list: ScheduleModel.decode(schedule),
    );
  }

  Map<String, dynamic> get toJson => {
        'id': id.toString(),
        'id_store': id_store.toString(),
        'scheduleList': ScheduleModel.encode(list),
      };

  static Map<String, dynamic> toMap(ScheduleList scheduleList) => {
        'id': scheduleList.id,
        'id_store': scheduleList.id_store,
        'scheduleList': scheduleList.list,
      };
}
