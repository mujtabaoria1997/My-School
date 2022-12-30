import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myschool/app_helper/io.dart';
import 'package:myschool/app_timetable/dlg_table.dart';
import 'package:myschool/home.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({super.key});

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  var loaded = false;
  List files = [];

  @override
  Widget build(BuildContext context) {
    // Load Files
    Timer.periodic(const Duration(seconds: 1), (t) {
      if (IOHelper.appPath != null) {
        if (loaded == false) {
          var data = IOFunctions.getTimeTables();
          files = data;
          try {
            setState(() {});
          } catch (e) {}
          loaded = true;
        }
        t.cancel();
      }
    });

    var list = Column(
      children: files.map((e) {
        return getTile(e);
      }).toList(),
    );

    return SingleChildScrollView(
      child: list,
    );
  }

  // Get File Tile
  Widget getTile(e) {
    // Title
    var title = Text(
      e['title'],
      style: const TextStyle(fontSize: 20),
    );

    // Main Button
    var btn = MaterialButton(
      onPressed: () {
        Home.curPage = DlgTable(
          filename: e['filename'],
        );
        Home.curTab = 3;
        Home.title = e['title'];
        Home.refresh();
      },
      child: Container(
        alignment: Alignment.centerLeft,
        child: title,
      ),
    );

    // Main Column
    var col = Column(
      children: [
        // Main Button
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 12,
          child: btn,
        ),

        // Divider
        const Divider(
          color: Colors.grey,
          height: 6,
        ),
      ],
    );

    // Return Col
    return col;
  }
}
