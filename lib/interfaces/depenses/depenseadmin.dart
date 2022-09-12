import 'package:deri/interfaces/adds/adddepanse.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../variables.dart';

class DepensesAdmin extends StatefulWidget {
  const DepensesAdmin({Key? key}) : super(key: key);

  @override
  State<DepensesAdmin> createState() => _DepensesAdminState();
}

class _DepensesAdminState extends State<DepensesAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
                child: const DepenseAdd(),
                type: PageTransitionType.bottomToTop),
          );
        },
        label: texter('Add Project'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blueGrey.shade400,
      ),
    );
  }
}
