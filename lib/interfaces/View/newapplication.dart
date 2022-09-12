import 'package:deri/interfaces/adds/parametres.dart';

import 'package:deri/interfaces/app/agendaui.dart';
import 'package:deri/interfaces/app/depenseui.dart';
import 'package:deri/interfaces/app/projetui.dart';

import "package:flutter/material.dart";

class NewApplication extends StatefulWidget {
  const NewApplication({Key? key}) : super(key: key);

  @override
  State<NewApplication> createState() => _NewApplicationState();
}

class _NewApplicationState extends State<NewApplication> {
  int selectedindex = 0;
  List uiList = <Widget>[
    const ProjetUi(),
    const DepenseUi(),
    const AgendaUI(),
    const Parametre(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            indicatorColor: Colors.blue.shade400,
            backgroundColor: Colors.blueGrey.shade200,
            leading: Column(
              children: const [
                SizedBox(
                  height: 8,
                ),
                CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.person),
                ),
              ],
            ),
            minWidth: 100.0,
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.home), label: Text('Business')),
              NavigationRailDestination(
                  icon: Icon(Icons.money), label: Text('Depenses')),
              NavigationRailDestination(
                  icon: Icon(Icons.view_agenda), label: Text('Agenda')),
              NavigationRailDestination(
                  icon: Icon(Icons.settings), label: Text('Settings')),
            ],
            selectedIndex: selectedindex,
            onDestinationSelected: (index) {
              setState(() {
                selectedindex = index;
              });
            },
          ),
          Expanded(child: uiList[selectedindex]),
        ],
      ),
    );
  }
}
