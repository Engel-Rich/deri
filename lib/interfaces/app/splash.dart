import 'package:deri/variables.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpalshSCreen extends StatefulWidget {
  const SpalshSCreen({Key? key}) : super(key: key);

  @override
  State<SpalshSCreen> createState() => _SpalshSCreenState();
}

class _SpalshSCreenState extends State<SpalshSCreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Center(
        child: spinkit(context),
      ),
    );
  }
}
