import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myschool/app_notes/dlg_note.dart';
import 'package:myschool/app_notes/notes.dart';
import 'package:myschool/app_settings/settings.dart';
import 'package:myschool/app_timetable/dlg_table.dart';
import 'package:myschool/app_timetable/timetable.dart';
import 'package:myschool/app_helper/io.dart';
// ignore: depend_on_referenced_packages
import 'package:fluttertoast/fluttertoast.dart' as toast;
import 'package:myschool/app_helper/tt.dart' as tt;

class Home extends StatefulWidget {
  const Home({super.key});

  // Static Variables
  // Current Page
  static dynamic curPage = const TimeTable();

  // Current Tab
  static dynamic curTab = 0;

  // Current Page Title
  static dynamic title = "Timetables";

  // Refresh
  static dynamic refresh;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Page Bucket
  var bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    // Set Refresh Call
    Home.refresh = clbRefresh;

    // Prepare everything
    IOFunctions.getFolders().then((value) => IOFunctions.readSettings());

    // PageStorage
    var pagination = PageStorage(
      bucket: bucket,
      child: Home.curPage,
    );

    // App Bar
    var appBar = _Funcs().getTitle();

    // Bottom Bar
    var bottomBar = _Funcs().getBottom(context);

    // Get Floating Action
    var floating = _Funcs().getFloating(context);

    // Get Actions

    // Main Scaffold Widget
    var sca = Scaffold(
      // AppBar
      appBar: appBar,

      // ButtomBar
      bottomNavigationBar: bottomBar,

      // Floating Button
      floatingActionButton: floating,
      // Scroll view
      body: SingleChildScrollView(
        // Main Pagination
        child: pagination,
      ),
    );

    // Return Scaffold
    return WillPopScope(onWillPop: _Funcs().onBack, child: sca);
  }

  // Refresh
  clbRefresh() {
    setState(() {});
  }
}

class _Funcs {
  // Text Controllers
  var cont1 = TextEditingController();
  var cont2 = TextEditingController(text: "8");

  // Actions
  getActions() {
    List<Widget> actions = [];
    if (Home.curTab == 3) {
      // Field 1 Edit Title
      var f1 = IconButton(
          onPressed: () {
            DlgTable.editTitle();
          },
          icon: const Icon(
            Icons.edit_note,
            size: 32,
          ));

      // Field 2 Delete Note
      var f2 = IconButton(
        onPressed: () {
          DlgTable.delete();
        },
        icon: const Icon(
          Icons.delete,
          size: 32,
        ),
      );

      // Actions
      actions = [
        // Edit Title
        f1,

        // Delete Note
        f2,
      ];
    }

    if (Home.curTab == 4) {
      // Icon 1 Edit Title
      var ico1 = IconButton(
        onPressed: () => DlgNote.editTitle(),
        icon: const Icon(
          Icons.edit_note,
          size: 32,
        ),
      );

      // Icon 2 Delete
      var ico2 = IconButton(
        onPressed: () => DlgNote.deleteNote(),
        icon: const Icon(
          Icons.delete,
          size: 32,
        ),
      );

      actions = [
        // Edit Title
        ico1,

        // Dekete
        ico2,
      ];
    }
    return actions;
  }

  // Go back
  Future<bool> onBack() async {
    if (Home.curTab == 1) {
      Home.curTab = 0;
      Home.title = "TimeTables";
      Home.curPage = const TimeTable();
      Home.refresh();
      return false;
    }

    if (Home.curTab == 2) {
      Home.curTab = 0;
      Home.title = "TimeTables";
      Home.curPage = const TimeTable();
      Home.refresh();
      return false;
    }

    if (Home.curTab == 3) {
      Home.curTab = 1;
      Home.title = "TimeTables";
      Home.curPage = const TimeTable();
      Home.refresh();
      return false;
    }

    if (Home.curTab == 4) {
      Home.curTab = 1;
      DlgNote.saveNote();
      Home.title = "Notes";
      Home.curPage = const Notes();
      Home.refresh();
      return false;
    }

    if (Home.curTab == 5) {
      Home.curTab = 2;
      Home.title = "Settings";
      Home.curPage = const Settings();
      Home.refresh();
      return false;
    }
    return true;
  }

  // Get Title
  getTitle() {
    var appBar = AppBar(
      // Back Button
      leading: getBackButton(),

      // Get Actions
      actions: getActions(),

      // Title
      title: Text(
        "My School: ${Home.title}",
      ),
    );

    return appBar;
  }

  // Get BottomBar
  getBottom(context) {
    // Text 1 TimeTables
    var txt1 = const Text(
      "TimeTables",
      style: TextStyle(fontSize: 20),
    );

    // Text 2 Notes
    var txt2 = const Text(
      "Notes",
      style: TextStyle(fontSize: 20),
    );

    // Icon 1 TimeTables
    var ico1 = Stack(
      children: [
        Icon(
          Icons.calendar_month,
          size: 48,
          color: Home.curTab == 0 ? Colors.blue : Colors.grey,
        ),
        Positioned(
          left: 24,
          top: 24,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.width / 5),
              ),
              color: Colors.white,
            ),
            child: Icon(
              Icons.timer,
              size: 24,
              color: Home.curTab == 0 ? Colors.blue[500] : Colors.grey,
            ),
          ),
        )
      ],
    );

    // Icon 2 Notes
    var ico2 = Icon(
      Icons.edit_calendar,
      size: 48,
      color: Home.curTab == 1 ? Colors.blue : Colors.grey,
    );

    // Icon 3 Settings
    var ico3 = Icon(
      Icons.settings,
      size: 48,
      color: Home.curTab == 2 ? Colors.blue : Colors.grey,
    );

    var bottomBar = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Button 1
        SizedBox(
          width: MediaQuery.of(context).size.width / 3.05,
          height: 80,
          child: MaterialButton(
            onPressed: () {
              Home.curTab = 0;
              Home.title = "TimeTables";
              Home.curPage = const TimeTable();
              Home.refresh();
            },
            child: ico1,
          ),
        ),

        // Button 2
        SizedBox(
          width: MediaQuery.of(context).size.width / 3.05,
          height: 80,
          child: MaterialButton(
            onPressed: () {
              Home.curTab = 1;
              Home.title = "Notes";
              Home.curPage = const Notes();
              Home.refresh();
            },
            child: ico2,
          ),
        ),

        // Button 3
        SizedBox(
          width: MediaQuery.of(context).size.width / 3.05,
          height: 80,
          child: MaterialButton(
            onPressed: () {
              Home.curTab = 2;
              Home.title = "Settings";
              Home.curPage = const Settings();
              Home.refresh();
            },
            child: ico3,
          ),
        ),
      ],
    );

    return SizedBox(
        height: 80,
        child: BottomAppBar(
          notchMargin: 0,
          child: bottomBar,
        ));
  }

  // Get Floating Button
  getFloating(context) {
    var floating = FloatingActionButton(
      onPressed: () {
        if (Home.curTab == 0) {
          timetableDialog(context);
        }
        if (Home.curTab == 1) {
          noteDialog(context);
        }
      },
      child: const Icon(Icons.add),
    );
    if (Home.curTab > 1) {
      return null;
    } else {
      return floating;
    }
  }

  // Back Button
  getBackButton() {
    // Back Button
    var back = BackButton(
      onPressed: () {
        if (Home.curTab == 3) {
          Home.curTab = 0;
          Home.title = "TimeTables";
          Home.curPage = const TimeTable();
          Home.refresh();
        }

        if (Home.curTab == 4) {
          DlgNote.saveNote();
          Home.curTab = 1;
          Home.title = "Notes";
          Home.curPage = const Notes();
          Home.refresh();
        }
        if (Home.curTab == 5) {
          Home.curTab = 2;
          Home.title = "Settings";
          Home.curPage = const Settings();
          Home.refresh();
        }
      },
    );

    if (Home.curTab > 2) {
      return back;
    } else {
      return null;
    }
  }

  // Create New Timetable
  timetableDialog(context) {
    cont1.text = "";
    cont2.text = "8";

    showDialog(
        context: context,
        builder: (context) {
          // Field 1 TimeTable Name
          var f1 = TextField(
            autofocus: true,
            controller: cont1,
            decoration: const InputDecoration(
              labelText: "TimeTable Name",
            ),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          );

          // Field 2 Class Hours
          var f2 = TextField(
            controller: cont2,
            decoration: const InputDecoration(
              labelText: "Class Hours",
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            keyboardType: TextInputType.number,
            onSubmitted: (value) {
              var result = createTimeTable(cont1.text, value);
              if (result == true) {
                Navigator.pop(context);
              }
            },
          );

          // Button 1 Create
          var btn1 = ElevatedButton(
            onPressed: () {
              var result = createTimeTable(cont1.text, cont2.text);

              if (result == true) {
                Navigator.pop(context);
              }
            },
            child: const Text("Create TimeTable"),
          );

          // Button 2 Cancel
          var btn2 = ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          );

          var alert = AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            // Title
            title: const Text("TimeTable"),

            // Fields
            content: SizedBox(
                height: MediaQuery.of(context).size.height / 7,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // TimeTable Title
                      f1,
                      // Class Hours
                      f2
                    ],
                  ),
                )),

            // Actions
            actions: [
              // Create Timetable
              btn1,

              // Cancel
              btn2
            ],

            // Scrollable
            scrollable: true,
          );

          return alert;
        });
  }

  // Create New TimeTable
  createTimeTable(title, rows) {
    // Check Title
    if (title == "") {
      toast.Fluttertoast.showToast(
        msg: "Please enter title!",
        toastLength: toast.Toast.LENGTH_SHORT,
      );
      return false;
    }

    // Class Hours
    rows = rows == "" ? 0 : int.parse(rows);
    if (rows < 5 || rows > 12) {
      toast.Fluttertoast.showToast(
        msg: "Class Hours must be between 5 and 12 hours!",
        toastLength: toast.Toast.LENGTH_SHORT,
      );
      return false;
    }

    // Create Timetable
    var filename = "${IOHelper.settings['tno']}.tdata";
    IOHelper.settings['tno'] += 1;
    dynamic data = {
      "title": title,
      "data": tt.getEmptyTable(rows),
    };

    data = jsonEncode(data);

    IOFunctions.writeFile('${IOHelper.pathTimeTable}/$filename', data);
    Home.curPage = DlgTable(
      filename: filename,
    );
    Home.title = title;
    Home.curTab = 3;
    Home.refresh();
    IOFunctions.writeSettings();

    return true;
  }

  // New Note Dialog
  noteDialog(context) {
    // Note Title Controller
    var cont = TextEditingController();
    showDialog(
        context: context,
        builder: ((context) {
          var alert = AlertDialog(
            // Title
            title: const Text("Note"),
            content: Container(
              margin: const EdgeInsets.all(5),
              child: TextField(
                controller: cont,
                decoration: const InputDecoration(labelText: "Note Title"),
                autofocus: true,
                onSubmitted: (value) {
                  if (value == "") {
                    toast.Fluttertoast.showToast(
                      msg: "Please enter note title",
                      toastLength: toast.Toast.LENGTH_SHORT,
                    );
                    return;
                  }
                  createNote(value);
                  Navigator.pop(context);
                },
              ),
            ),

            // Actions
            actions: [
              // Create Button
              ElevatedButton(
                onPressed: () {
                  if (cont.text == "") {
                    toast.Fluttertoast.showToast(
                      msg: "Please enter note title",
                      toastLength: toast.Toast.LENGTH_SHORT,
                    );
                    return;
                  }
                  createNote(cont.text);
                  Navigator.pop(context);
                },
                child: const Text("Create Note"),
              ),

              // Cancel Button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ],
          );
          return alert;
        }));
  }

  // Create New Note
  createNote(title) {
    dynamic data = {
      "title": title,
      "data": "",
    };

    data = jsonEncode(data);
    var filename = "${IOHelper.settings['nno']}.ndata";
    IOHelper.settings['nno'] += 1;
    IOFunctions.writeSettings();
    IOFunctions.writeFile("${IOHelper.pathNotes}/$filename", data);
    Home.curPage = DlgNote(
      filename: filename,
    );
    Home.curTab = 4;
    Home.title = title;
    Home.refresh();
  }

  // End of the line
}
