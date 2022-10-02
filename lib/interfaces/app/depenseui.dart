import 'package:deri/interfaces/depenses/autresdepenses.dart';
import 'package:deri/interfaces/depenses/depenseadmin.dart';
// import 'package:deri/interfaces/depenses/depenseadmin.dart';
import 'package:deri/interfaces/depenses/depenseprojetUi.dart';
import 'package:deri/variables.dart';
import 'package:flutter/material.dart';
// import 'package:deri/variables.dart';

class DepenseUi extends StatefulWidget {
  const DepenseUi({Key? key}) : super(key: key);

  @override
  State<DepenseUi> createState() => _DepenseUiState();
}

class _DepenseUiState extends State<DepenseUi>
    with SingleTickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   leading: const SizedBox.shrink(),
        //   bottom: const TabBar(
        //       physics: BouncingScrollPhysics(),
        //       indicator: BoxDecoration(
        //         color: Colors.blue,
        //       ),
        //       // indicatorWeight: 5,
        //       tabs: [
        //         Tab(
        //           // icon: Icon(Icons.business),
        //           text: "Project",
        //         ),
        //         Tab(
        //           // icon: Icon(Icons.admin_panel_settings_sharp),
        //           text: "Oppresinnal",
        //         ),
        //       ]),
        //   // elevation: 0.0,
        //   // backgroundColor: Colors.blueGrey.shade400,
        // ),
        body: Column(
      children: [
        TabBar(
          controller: controller,
          isScrollable: true,
          labelPadding: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(5),
          labelColor: Colors.blue,
          automaticIndicatorColorAdjustment: false,
          tabs: [
            Text(
              "Projet",
              textAlign: TextAlign.left,
              style: styletext.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              "Opressional",
              textAlign: TextAlign.right,
              style: styletext.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            controller: controller,
            children: const [DepensesProjetUI(), AutresDepenses()],
          ),
        )
      ],
    ));
  }
}
