import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myschool/app_helper/io.dart';
import 'package:myschool/app_notes/dlg_note.dart';
import 'package:myschool/home.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  var loaded = false;
  var files = [];

  @override
  Widget build(BuildContext context) {
    // Load Files
    Timer.periodic(const Duration(seconds: 1), (t) {
      if (IOHelper.appPath != null) {
        if (loaded == false) {
          var data = IOFunctions.getNotes();
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

  Widget getTile(e) {
    // Title
    var title = Text(
      e['title'],
      style: const TextStyle(fontSize: 20),
    );

    // Main Button
    var btn = MaterialButton(
      onPressed: () {
        Home.curPage = DlgNote(
          filename: e['filename'],
        );
        Home.curTab = 4;
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
    return col;
  }
}
