import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class IOHelper {
  // Variables for both
  static dynamic appPath;
  static dynamic errMsg;
  static dynamic settings = {
    "tno": 0,
    "nno": 0,
  };

  // Timetable Variables
  static dynamic pathTimeTable;

  // Notes Variables
  static dynamic pathNotes;
}

class IOFunctions {
  // Check and Directories
  static Future getFolders() async {
    // Get Application Data Directory
    final directory = await getApplicationDocumentsDirectory();
    IOHelper.appPath = directory.path;

    // Check and Set Timetable Directory
    IOHelper.pathTimeTable = "${directory.path}/app_timetable";
    var pathTimeTables = Directory(IOHelper.pathTimeTable);
    if (pathTimeTables.existsSync() == false) {
      pathTimeTables.createSync();
    }

    // Check and Set Notes Directory
    IOHelper.pathNotes = "${directory.path}/app_note";
    var pathNotes = Directory(IOHelper.pathNotes);
    if (pathNotes.existsSync() == false) {
      pathNotes.createSync();
    }
  }

  // Write Data to File
  static writeFile(filename, data) {
    try {
      File(filename).writeAsStringSync(data);
      return true;
    } catch (e) {
      IOHelper.errMsg = "Write File: $e";
      return false;
    }
  }

  // Read Data From File
  static readFile(filename) {
    try {
      var data = File(filename).readAsStringSync();
      return data;
    } catch (e) {
      IOHelper.errMsg = "Read File: $e";
      return "";
    }
  }

  // Delete Data File
  static deleteFile(filename) {
    try {
      File(filename).deleteSync();
      return true;
    } catch (e) {
      IOHelper.errMsg = "Delete File: $e";
      return false;
    }
  }

  // Read Settings
  static readSettings() {
    try {
      var file = File(IOHelper.appPath + "/settings.dat");
      if (file.existsSync() == false) {
        return writeSettings();
      } else {
        dynamic data = file.readAsStringSync();
        data = jsonDecode(data);
        IOHelper.settings = data;
        return true;
      }
    } catch (e) {
      IOHelper.errMsg = e;
      return false;
    }
  }

  // Write Settings;
  static writeSettings() {
    try {
      dynamic data = IOHelper.settings;
      data = jsonEncode(data);
      var file = File(IOHelper.appPath + "/settings.dat");
      file.writeAsStringSync(data);
      return true;
    } catch (e) {
      IOHelper.errMsg = e;
      return false;
    }
  }

  // Get Timetables list
  static getTimeTables() {
    try {
      var pathTimeTable = Directory(IOHelper.pathTimeTable);
      var files = pathTimeTable.listSync();
      var lst = [];
      for (var i in files) {
        dynamic data = readFile(i.path);
        data = jsonDecode(data);
        data['filename'] = i.path.split("/").last;
        lst.add(data);
      }
      return lst;
    } catch (e) {
      IOHelper.errMsg = e;
      var lst = [];
      return lst;
    }
  }

  // Get Timetables list
  static getNotes() {
    try {
      var pathTimeTable = Directory(IOHelper.pathNotes);
      var files = pathTimeTable.listSync();
      var lst = [];
      for (var i in files) {
        dynamic data = readFile(i.path);
        data = jsonDecode(data);
        data['filename'] = i.path.split("/").last;
        lst.add(data);
      }
      return lst;
    } catch (e) {
      IOHelper.errMsg = e;
      var lst = [];
      return lst;
    }
  }

  // End of the Line
}
