import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myschool/app_helper/io.dart';
import 'package:myschool/app_timetable/timetable.dart';
import 'package:myschool/home.dart';
import 'package:fluttertoast/fluttertoast.dart' as toast;
import 'package:flutter_colorpicker/flutter_colorpicker.dart' as col;

class DlgTable extends StatefulWidget {
  final dynamic filename;
  const DlgTable({super.key, this.filename});
  static dynamic delete;
  static dynamic editTitle;

  @override
  State<DlgTable> createState() => _DlgTableState();
}

class _DlgTableState extends State<DlgTable> {
  dynamic tData;

  @override
  Widget build(BuildContext context) {
    // Set Delete CallBack
    DlgTable.delete = deleteTimeTable;
    DlgTable.editTitle = editTitle;

    // Read File
    dynamic data = IOFunctions.readFile(
      '${IOHelper.pathTimeTable}/${widget.filename}',
    );

    data = jsonDecode(data);
    tData = data;
    List<Widget> cols = [];

    // Get Ready Columns
    Map days = data['data'];
    cols = days
        .map(
          (key, value) {
            return getTile(key, value);
          },
        )
        .values
        .cast<Widget>()
        .toList();

    return SingleChildScrollView(
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              children: cols,
            ),
          )),
    );
  }

  // Get TimeTable Tile
  getTile(key, value) {
    // Get Valuse as List
    List values = value;

    // Day Container
    var day = Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Text(
        key.toUpperCase(),
        style: const TextStyle(fontSize: 15),
      ),
    );

    // Count List
    var cnt = -1;
    // Subjects Row
    var row = Row(
      children: [
            // Day
            day,
          ] +
          values.map((e) {
            // Continue Count
            cnt += 1;
            return getDay(key, e, cnt);
          }).toList(),
    );

    return MapEntry(key, row);
  }

  // Get Each Day
  Container getDay(key, e, cnt) {
    // Empty Subject
    var vEmp = const Text(
      "//",
      style: TextStyle(fontSize: 15),
    );

    // Subject
    var vSub = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Subject Text(
        Text(
          "${e['sub'].toUpperCase()}",
          style: TextStyle(
            fontSize: 15,
            color: Color(e['color']),
          ),
          textAlign: TextAlign.center,
        ),

        // Time
        Text(
          "${e['start']} - ${e['end']}",
          style: TextStyle(
            fontSize: 13,
            color: Color(e['color']),
          ),
        )
      ],
    );

    // Container for Each Subject
    var cont = Container(
      width: 200,
      height: 100,
      alignment: Alignment.center,
      margin: null,
      decoration: BoxDecoration(
        color: Color(e['bg']),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: MaterialButton(
        minWidth: 200,
        height: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        onPressed: () {
          changeDet(key, cnt);
        },
        child: e['empty'] == true ? vEmp : vSub,
      ),
    );
    return cont;
  }

  // Change Subject Details
  changeDet(key, cnt) {
    dynamic startTime = tData['data'][key][cnt]['start'];
    dynamic endTime = tData['data'][key][cnt]['end'];
    var color = Color(tData['data'][key][cnt]['color']);
    var bgcolor = Color(tData['data'][key][cnt]['bg']);

    var actDone = false;

    // Main Dialog
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          // Title
          var title = const Text("Change Details");

          // Sub Field 1 Start Time
          var sf1 = MaterialButton(
            onPressed: () async {
              var c = false;
              // Pick Time Dialog
              var time = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 0, minute: 0),
              );

              if (time == null) {
                return;
              }
              if (c == false) {
                c = true;
                setState((() {
                  var t1 =
                      "0${time.hourOfPeriod}:${time.minute} ${time.period.name.toUpperCase()}";
                  var t2 =
                      "${time.hourOfPeriod}:${time.minute} ${time.period.name.toUpperCase()}";
                  startTime = time.hourOfPeriod < 10 ? t1 : t2;
                }));
              }
            },
            child: Text(startTime),
          );

          // Sub Field 1 End Time
          var sf2 = MaterialButton(
            onPressed: () async {
              var c = false;
              // Pick Time Dialog
              var time = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 0, minute: 0),
              );

              if (time == null) {
                return;
              }
              if (c == false) {
                c = true;
                setState((() {
                  var t1 =
                      "0${time.hourOfPeriod}:${time.minute} ${time.period.name.toUpperCase()}";
                  var t2 =
                      "${time.hourOfPeriod}:${time.minute} ${time.period.name.toUpperCase()}";
                  endTime = time.hourOfPeriod < 10 ? t1 : t2;
                }));
              }
            },
            child: Text(endTime),
          );

          // Field 1 Subject's Name
          var cont = TextEditingController(
            text: tData['data'][key][cnt]['sub'],
          );
          var f1 = TextField(
            controller: cont,
            decoration: const InputDecoration(labelText: "Subject's Name"),
          );

          // Field 2 Subject's Start and End Time
          var f2 = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Start Time
              sf1,

              // -
              const Text("-"),

              // End Time
              sf2
            ],
          );

          // Text Color
          var f3 = MaterialButton(
            onPressed: () {
              var c = false;
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  scrollable: true,
                  title: const Text("Pick a Color"),
                  content: col.ColorPicker(
                    pickerColor: color,
                    onColorChanged: (value) => setState(() => color = value),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: (() => Navigator.pop(context)),
                        child: const Text("Ok"))
                  ],
                ),
              );
            },
            color: bgcolor,
            child: Text(
              "Text Color",
              style: TextStyle(
                fontSize: 15,
                color: color,
              ),
            ),
          );

          // Text Color
          var f4 = MaterialButton(
            onPressed: () {
              var c = false;
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  scrollable: true,
                  title: const Text("Pick a Color"),
                  content: col.ColorPicker(
                    pickerColor: bgcolor,
                    onColorChanged: (value) => setState(() => bgcolor = value),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: (() => Navigator.pop(context)),
                        child: const Text("Ok"))
                  ],
                ),
              );
            },
            color: bgcolor,
            child: Text(
              "Background Color",
              style: TextStyle(fontSize: 15, color: color),
            ),
          );

          // Alert Dialog
          var alert = AlertDialog(
            scrollable: true,
            title: title,
            content: Column(children: [
              // Subject's Name,
              f1,

              // Subject's Time
              f2,

              // Text Color
              f3,

              // Background Color
              f4
            ]),

            // Buttons
            actions: [
              // Button Save
              ElevatedButton(
                onPressed: () {
                  tData["data"][key][cnt]["sub"] = cont.text;
                  tData["data"][key][cnt]["start"] = startTime;
                  tData["data"][key][cnt]["end"] = endTime;
                  tData["data"][key][cnt]["color"] = color.value;
                  tData["data"][key][cnt]["bg"] = bgcolor.value;
                  tData["data"][key][cnt]["empty"] = false;

                  var data = jsonEncode(tData);
                  IOFunctions.writeFile(
                      "${IOHelper.pathTimeTable}/${widget.filename}", data);
                  Navigator.pop(context);
                },
                child: const Text("Save Info"),
              ),

              // Empty
              ElevatedButton(
                  onPressed: () {
                    tData["data"][key][cnt]["sub"] = "Sample Subject";
                    tData["data"][key][cnt]["start"] = "01:00 AM";
                    tData["data"][key][cnt]["end"] = "02:00 AM";
                    tData["data"][key][cnt]["color"] = Colors.black.value;
                    tData["data"][key][cnt]["bg"] = Colors.grey.value;
                    tData["data"][key][cnt]["empty"] = true;

                    var data = jsonEncode(tData);
                    IOFunctions.writeFile(
                        "${IOHelper.pathTimeTable}/${widget.filename}", data);
                    Navigator.pop(context);
                  },
                  child: const Text("Empty Hour")),

              // Button Cancel
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ],
          );

          return alert;
        },
      ),
    ).then((value) {
      if (actDone == false) {
        setState(() {
          actDone = true;
        });
      }
    });
  }

  // Edit Title
  editTitle() {
    var actDone = false;
    showDialog(
        context: context,
        builder: (context) {
          var cont = TextEditingController(text: tData['title']);
          var alert = AlertDialog(
            title: const Text("Edit Title"),
            content: TextField(
              controller: cont,
              onSubmitted: (value) {
                tData['title'] = value;
                var data = jsonEncode(tData);
                IOFunctions.writeFile(
                  "${IOHelper.pathTimeTable}/${widget.filename}",
                  data,
                );
                Home.title = value;
                Home.refresh();
                Navigator.pop(context);
              },
            ),

            // Buttons
            actions: [
              // Save Button
              ElevatedButton(
                onPressed: () {
                  tData['title'] = cont.text;
                  var data = jsonEncode(tData);
                  IOFunctions.writeFile(
                    "${IOHelper.pathTimeTable}/${widget.filename}",
                    data,
                  );
                  Home.title = cont.text;
                  Home.refresh();
                  Navigator.pop(context);
                },
                child: const Text("Save Info"),
              ),

              // Cancel Button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ],
          );
          return alert;
        });
  }

  // Delete TimeTable
  deleteTimeTable() {
    showDialog(
        context: context,
        builder: (context) {
          // Button 1 Yes
          var btn1 = ElevatedButton(
            onPressed: () {
              IOFunctions.deleteFile(
                '${IOHelper.pathTimeTable}/${widget.filename}',
              );
              Navigator.pop(context);

              Home.curPage = const TimeTable();
              Home.curTab = 0;
              Home.title = "TimeTables";
              Home.refresh();
              toast.Fluttertoast.showToast(
                msg: "TimeTable successfully deleted!",
                toastLength: toast.Toast.LENGTH_SHORT,
              );
            },
            child: const Text("Yes"),
          );

          // Button 2 No
          var btn2 = ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("No"),
          );

          var alert = AlertDialog(
            // Title
            title: const Text("TimeTable"),

            // Message
            content: const Text(
              "Are you sure you want to delete this timetable?",
              style: TextStyle(fontSize: 20),
            ),

            // Actions
            actions: [
              // Yes Button
              btn1,

              // No Button
              btn2,
            ],
          );

          // Return
          return alert;
        });
  }
}
