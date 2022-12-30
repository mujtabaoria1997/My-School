import 'package:flutter/material.dart';

class AboutMOria extends StatefulWidget {
  const AboutMOria({super.key});

  @override
  State<AboutMOria> createState() => _AboutMOriaState();
}

class _AboutMOriaState extends State<AboutMOria> {
  @override
  Widget build(BuildContext context) {
    // Field 1 M.Oria Soft
    var f1 = Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      child: const Text(
        "M.Oria Soft",
        style: TextStyle(fontSize: 35),
      ),
    );

    // Field 2 About M.Oria Soft
    var f2 = Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      child: const Text('''
    M.Oria Soft is a tech company started in 2018.
    Served more than 100 Customers with Mobile Apps,
    Web Apps, Desktop Softwares and Web-Based Databases.
    M.Oria Soft proud to help it's Customers and 
    Developers reach their goals and will always ready
    to help.

    Contact us: 
    Email: mujtabaoria1997@gmail.com
    Phone: +93789256457  
    WhatsApp: +93789256457
    

'''),
    );

    // All Fields
    var col = Column(
      children: [
        // M.Oria Soft
        f1,

        // About
        f2,
      ],
    );

    return SingleChildScrollView(
      child: col,
    );
  }
}
