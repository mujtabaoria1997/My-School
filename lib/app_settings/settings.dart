import 'package:flutter/material.dart';
import 'package:myschool/app_settings/about.dart';
import 'package:myschool/home.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    // About
    var about = aboutMOria();

    // Column
    var col = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // About Dialog
        about,
      ],
    );

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: col,
    );
  }

  // About Dialog
  Widget aboutMOria() {
    // Material Button
    var mat = MaterialButton(
      height: 60,
      minWidth: MediaQuery.of(context).size.width,
      onPressed: () {
        Home.curTab = 5;
        Home.curPage = const AboutMOria();
        Home.title = "About M.Oria Soft";
        Home.refresh();
      },
      child: const Text(
        "About M.Oria Soft",
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );

    // Return Column
    return Column(
      children: [
        // Material Button
        mat,

        // Divider
        const Divider(
          color: Colors.grey,
          height: 8,
        )
      ],
    );
  }

  // End of the Line
}
