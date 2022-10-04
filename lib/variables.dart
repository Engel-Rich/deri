import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:deri/Firebases/firebasedepenses.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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

bool estGrand(BuildContext context) =>
    taille(context).width > 640 && taille(context).width < 848;
bool estPlusGrand(BuildContext context) => taille(context).width > 848;

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
getSnack(
  String message, {
  String? title = "Save Error",
  Color color = Colors.deepOrange,
  Widget icon = const Icon(
    Icons.error,
    color: Colors.red,
  ),
}) =>
    Get.snackbar(
      title!,
      message,
      titleText: Text(title, style: styletitle),
      messageText: Text(message, style: styletext),
      icon: icon,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 5),
      isDismissible: true,
      backgroundColor: color,
      dismissDirection: DismissDirection.horizontal,
    );
Color bleu = const Color.fromRGBO(6, 57, 112, 0.80);
List<String> listnom = ['Raison', "Amont", "Date", "Type"];
Widget showDepenses(List<Depenses> list) {
  return DataTable(
    dataRowHeight: 60,
    showBottomBorder: true,
    border: TableBorder.all(width: 1.5, color: bleu),
    headingRowColor:
        MaterialStateColor.resolveWith((states) => Colors.blue.shade300),
    columns: listnom
        .map(
          (name) => DataColumn(
            label: Text(
              name,
              style: styletitle,
            ),
          ),
        )
        .toList(),
    rows: list
        .map(
          (depense) => DataRow(
            cells: detaiDep(depense)
                .map((elm) =>
                    DataCell(Text(elm, style: styletext, softWrap: true)))
                .toList(),
          ),
        )
        .toList(),
  );
}

List<String> detaiDep(Depenses depenses) => [
      depenses.motif,
      depenses.montant.toString(),
      DateFormat("EE d MM y").format(depenses.date),
      depenses.type
    ];
// final emo = "🐒💁👌🎍😍🦊👨";

// final iosclientId =
//     "940324675493-9dkc3ju1gv8cospr9sgh0osuqn851pvk.apps.googleusercontent.com";
// final webclient =
//     '940324675493-mtfe0otngofjjjeou6hobaqr75lgtaat.apps.googleusercontent.com';
