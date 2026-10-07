import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String maskPhoneNumber(String phoneNumber) {
  if (phoneNumber.length < 4) return phoneNumber;
  return phoneNumber.replaceRange(
    0,
    phoneNumber.length - 4,
    '*' * (phoneNumber.length - 4),
  );
}

bool isHoliday({
  required DateTime date,
  required String? holidayEnabled,
  required dynamic holidayList,
}) {
  debugPrint("isHoliday -- : $holidayEnabled");

  if (holidayEnabled != "Yes") return false;

  final formattedDate = DateFormat('yyyy-MM-dd').format(date);
  debugPrint("Selected Date -- : $date");

  return holidayList.any((e) {
    final holidayDate = e["holiday_date"].toString().split(' ').first;
    return holidayDate == formattedDate;
  });
}

bool isSunday({required DateTime date, required String? sundayEnabled}) {
  return sundayEnabled == "Yes" && date.weekday == DateTime.sunday;
}

bool isSpecialSaturday({
  required DateTime date,
  required String? saturdayEnabled,
}) {
  if (date.weekday != DateTime.saturday ||
      saturdayEnabled == null ||
      saturdayEnabled.isEmpty) {
    return false;
  }

  final weekNo = ((date.day - 1) ~/ 7) + 1;

  final weeks = saturdayEnabled
      .split(',')
      .map((e) => int.tryParse(e.trim()))
      .whereType<int>();

  return weeks.contains(weekNo);
}
