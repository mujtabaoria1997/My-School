import 'package:flutter/material.dart';

// Get Empty Table for new TimeTable
getEmptyTable(rows) {
  // Empty Hour
  var rHour = {
    "empty": true,
    "color": Colors.black.value,
    "bg": Colors.grey.value,
    "sub": "Sample Subject",
    "start": "01:00 AM",
    "end": "02:00 AM",
  };

  // Empty Day
  var rDay = [];
  for (var i = 0; i < rows;) {
    i++;
    rDay.add(rHour);
  }

  // Empty Time Table
  var timeTable = {
    // Saterday
    "sat": rDay,
    // Sunday
    "sun": rDay,
    // Monday
    "mon": rDay,
    // Tuesday
    "tue": rDay,
    // Wednessday
    "wed": rDay,
    // Thursday
    "thu": rDay,
    // Friday
    "fri": rDay,
  };

  return timeTable;
}
