import 'dart:convert';
import 'package:cuts/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleModel {
  int? id;
  String day_week;
  TimeOfDay initTime;
  TimeOfDay endTime;
  TimeOfDay BreakinitTime;
  TimeOfDay BreakEndTime;
  bool on_off;

  ScheduleModel(
      {this.id,
      required this.day_week,
      required this.initTime,
      required this.endTime,
      required this.BreakinitTime,
      required this.BreakEndTime,
      required this.on_off});

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
        id: json['id'],
        day_week: json['day_week'],
        initTime: parseTimeOfDay(json['initTime']),
        endTime: parseTimeOfDay(json['endTime']),
        BreakinitTime: parseTimeOfDay(json['breakinitTime']),
        BreakEndTime: parseTimeOfDay(json['breakendTime']),
        on_off: json['on_off']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'day_week': day_week,
        'initTime': initTime.to24hours(),
        'endTime': endTime.to24hours(),
        'breakinitTime': BreakinitTime.to24hours(),
        'breakendTime': BreakEndTime.to24hours(),
        'on_off': on_off
      };

  static Map<String, dynamic> toMap(ScheduleModel scheduleModel) => {
        'id': scheduleModel.id,
        'day_week': scheduleModel.day_week,
        'initTime': scheduleModel.initTime.to24hours(),
        'endTime': scheduleModel.endTime.to24hours(),
        'breakinitTime': scheduleModel.BreakinitTime.to24hours(),
        'breakendTime': scheduleModel.BreakEndTime.to24hours(),
        'on_off': scheduleModel.on_off
      };

  static String encode(List<ScheduleModel> schedules) => json.encode(
        schedules
            .map<Map<String, dynamic>>(
                (schedule) => ScheduleModel.toMap(schedule))
            .toList(),
      );

  static List<ScheduleModel> decode(String schedules) =>
      (json.decode(schedules) as List<dynamic>)
          .map<ScheduleModel>((item) => ScheduleModel.fromJson(item))
          .toList();

  static TimeOfDay parseTimeOfDay(String t) {
    DateTime dateTime = DateFormat("HH:mm").parse(t);
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }
}
