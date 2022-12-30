import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myschool/app_helper/io.dart';
import 'package:myschool/home.dart';

import 'notes.dart';

class DlgNote extends StatefulWidget {
  final dynamic filename;
  const DlgNote({super.key, this.filename});

  // Save Note
  static dynamic saveNote;
  static dynamic editTitle;
  static dynamic deleteNote;

  @override
  State<DlgNote> createState() => _DlgNoteState();
}

class _DlgNoteState extends State<DlgNote> {
  // Editor Controller
  TextEditingController cont = TextEditingController();

  // tData
  dynamic tData;

  @override
  Widget build(BuildContext context) {
    // Read Note Data
    dynamic data = IOFunctions.readFile(
      "${IOHelper.pathNotes}/${widget.filename}",
    );

    DlgNote.saveNote = saveNote;
    DlgNote.editTitle = editTitle;
    DlgNote.deleteNote = deleteNote;

    data = jsonDecode(data);
    tData = data;

    cont.text = data['data'];

    // Editor
    var edit = Expanded(
      child: TextField(
        scrollPhysics: const NeverScrollableScrollPhysics(),
        controller: cont,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Type here...",
          isDense: true,
        ),
        style: const TextStyle(fontSize: 20),
        maxLines: null,
      ),
    );

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 5, right: 5),
        child: edit,
      ),
    );
  }

  // Save Note File
  saveNote() {
    tData['data'] = cont.text;
    var data = jsonEncode(tData);
    var filename = "${IOHelper.pathNotes}/${widget.filename}";

    IOFunctions.writeFile(filename, data);
  }

  // Edit Title
  editTitle() {
    showDialog(
      context: context,
      builder: ((context) {
        // Controller
        var c = TextEditingController(
          text: tData['title'],
        );

        // Editor
        var title = TextField(
          controller: c,
          decoration: const InputDecoration(labelText: "Note Title"),
          onSubmitted: (value) {
            tData['title'] = value;
            var data = jsonEncode(tData);
            var filename = "${IOHelper.pathNotes}/${widget.filename}";
            IOFunctions.writeFile(filename, data);
            Home.title = value;
            Home.refresh();
            Navigator.pop(context);
          },
        );

        // Alert Dialog
        var alert = AlertDialog(
          scrollable: true,
          // Title
          title: const Text("Note"),

          // Editor
          content: title,

          // Actions
          actions: [
            // Save Info Button
            ElevatedButton(
              onPressed: () {
                tData['title'] = c.text;
                var data = jsonEncode(tData);
                var filename = "${IOHelper.pathNotes}/${widget.filename}";
                IOFunctions.writeFile(filename, data);
                Home.title = c.text;
                Home.refresh();
                Navigator.pop(context);
              },
              child: const Text("Save Info"),
            ),

            // Cancel
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );

        // Return alert
        return alert;
      }),
    );
  }

  // Delete Note
  deleteNote() {
    showDialog(
        context: context,
        builder: (context) {
          // Alert Dialog
          var alert = AlertDialog(
            scrollable: true,
            // Title
            title: const Text("Note"),
            // Message
            content: const Text("Are you sure you want to delete this note?"),
            // Actions
            actions: [
              // Yes Button
              ElevatedButton(
                onPressed: () {
                  var filename = "${IOHelper.pathNotes}/${widget.filename}";

                  IOFunctions.deleteFile(filename);

                  Home.curTab = 1;
                  Home.title = "Notes";
                  Home.curPage = const Notes();
                  Home.refresh();

                  Navigator.pop(context);
                },
                child: const Text("Yes"),
              ),

              // No Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No"),
              ),
            ],
          );

          // Return Alert
          return alert;
        });
  }

  // End of the line
}
