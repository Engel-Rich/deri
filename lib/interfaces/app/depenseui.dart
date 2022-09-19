import 'package:deri/interfaces/depenses/autresdepenses.dart';
// import 'package:deri/interfaces/depenses/depenseadmin.dart';
import 'package:deri/interfaces/depenses/depenseprojetUi.dart';
import 'package:flutter/material.dart';
// import 'package:deri/variables.dart';

class DepenseUi extends StatefulWidget {
  const DepenseUi({Key? key}) : super(key: key);

  @override
  State<DepenseUi> createState() => _DepenseUiState();
}

class _DepenseUiState extends State<DepenseUi> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: const Duration(milliseconds: 700),
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox.shrink(),
          bottom: const TabBar(
              physics: BouncingScrollPhysics(),
              indicator: BoxDecoration(   
                color: Colors.blue,
              ),
              // indicatorWeight: 5,
              tabs: [
                Tab(
                  // icon: Icon(Icons.business),
                  text: "Project",
                ),
                Tab(
                  // icon: Icon(Icons.admin_panel_settings_sharp),
                  text: "Oppresinnal",
                ),
              ]),
          // elevation: 0.0,
          // backgroundColor: Colors.blueGrey.shade400,
        ),
        body: const TabBarView(
          children: [
            DepensesProjetUI(),
            AutresDepenses(),
            // DepensesAdmin(),
          ],
        ),
      ),
    );
  }
}
