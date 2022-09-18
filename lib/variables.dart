import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:google_fonts/google_fonts.dart';

Size taille(BuildContext context) => MediaQuery.of(context).size;

var styletext = GoogleFonts.poppins(fontSize: 14, letterSpacing: 1.5);

final status = {
  0: "attente",
  1: "en_cours",
  2: "termine",
};
TextStyle styletitle = styletext.copyWith(
  fontSize: 16,
  fontWeight: FontWeight.w900,
);
Widget texter(String text) => Text(text, style: styletext);

bool estGrand(BuildContext context) => taille(context).width > 640;

Widget spacervertical(double taille) => SizedBox(height: taille);

Widget traithorizontal() => const Divider(thickness: 1);

final depenseorder = [0, 1];

final orderFinances = ['Incom', 'Expense'];

spinkit(BuildContext context) => SpinKitSpinningLines(
      color: Colors.blue.shade300,
      size: taille(context).width > 640 ? 150 : 70,
      // itemBuilder: (BuildContext context, int index) {
      //   return DecoratedBox(
      //     decoration: BoxDecoration(
      //       color: index.isEven
      //           ? Colors.red
      //           : const Color.fromARGB(255, 76, 84, 175),
      //     ),
      //   );
      // },
    );
bouttonBack(context, {double? taille = 24}) => IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        size: taille,
        color: Colors.blueAccent.shade700,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
spacerheight(double h) => SizedBox(height: h);

final authentication = FirebaseAuth.instance;
final userCollection = FirebaseFirestore.instance.collection('Users');
final depenseCollections = FirebaseFirestore.instance.collection('Depenses');
final projetCollections = FirebaseFirestore.instance.collection('Projet');
final agendaCollections = FirebaseFirestore.instance.collection('Agenda');
CollectionReference<Map<String, dynamic>> taskCollection(String idprojet) =>
    FirebaseFirestore.instance
        .collection('Projet')
        .doc(idprojet)
        .collection("Task");
final emo = "🐒💁👌🎍😍🦊👨";

final iosclientId =
    "940324675493-9dkc3ju1gv8cospr9sgh0osuqn851pvk.apps.googleusercontent.com";
final webclient =
    '940324675493-mtfe0otngofjjjeou6hobaqr75lgtaat.apps.googleusercontent.com';
