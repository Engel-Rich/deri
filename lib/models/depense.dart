// import 'package:deri/databases/databaonline.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class Depense {
//     final String motifDepense;
//     final String dateDepense;
//     final String ordreDepense;
//     final int montantDepense;
//     final String typeDepense;
//     final int idDepense;

//     Depense({
//       required this.motifDepense,
//       required this.dateDepense,
//       required this.ordreDepense,
//       required this.typeDepense,
//       required this.montantDepense,
//       required this.idDepense,
//     });

//   insertDepenses() async {
//     final connection = await DatabaseOnline.instance.connection();
//     await connection.query(
//         "INSERT INTO Depense(idDepense,montantDepense,typeDepense,ordreDepense,dateDepense,motifDepense) VALUES (?,?,?,?,?,?)",
//         [
//           idDepense,
//           montantDepense,
//           typeDepense,
//           ordreDepense,
//           dateDepense,
//           motifDepense
//         ]);
//   }

//   voir() {
//     debugPrint("""
// idDepense : $idDepense,
// montantDepense: $montantDepense,
// typeDepense: $typeDepense,
// ordreDepense : $ordreDepense,
// dateDepense : $dateDepense,
// motifDepense: $motifDepense
// """);
//   }

//   static Future<List<Depense>?> depenses() async {
//     List<Depense> list = [];
//     final connection = await DatabaseOnline.instance.connection();
//     await connection
//         .query("SELECT * FROM Depenses order dateDepense;")
//         .then((value) {
//       for (var depense in value) {
//         final depensFromDb = Depense(
//           motifDepense: depense['motifDepense'].toString(),
//           dateDepense: DateFormat.yMMMEd().format(depense['dateDepense']),
//           ordreDepense: depense['ordreDepense'].toString(),
//           typeDepense: depense['typeDepense'].toString(),
//           montantDepense: depense['montantDepense'],
//           idDepense: depense['idDepense'],
//         );
//         list.add(depensFromDb);
//       }
//     });
//     return list;
//   }

//   static Future<List<Depense>> depensesProposales() async {
//     List<Depense> list = [];
//     final connection = await DatabaseOnline.instance.connection();
//     await connection.query(
//         "SELECT * FROM Depense WHERE typeDepense = ? OR typeDepense = ? ORDER BY dateDepense",
//         ["Opressional", "Other"]).then((value) {
//       for (var depenses in value) {
//         final depense = Depense(
//           motifDepense: depenses['motifDepense'].toString(),
//           dateDepense: DateFormat.yMMMEd().format(depenses['dateDepense']),
//           ordreDepense: depenses['ordreDepense'].toString(),
//           typeDepense: depenses['typeDepense'].toString(),
//           montantDepense: depenses['montantDepense'],
//           idDepense: depenses['idDepense'],
//         );
//         print(depenses['dateDepense']);
//         // depense.voir();
//         list.add(depense);
//       }
//     });
//     return list;
//   }

//   static Future<List<Depense>> depensesPeriodique(
//       String debut, String fin) async {
//     List<Depense> list = [];
//     final connection = await DatabaseOnline.instance.connection();
//     await connection.query(
//         "SELECT * FROM Depense WHERE (dateDepense BETWEEN ? AND  ?) AND (typeDepense = ? OR typeDepense = ?) ORDER BY dateDepense",
//         [debut, fin, "Opressional", "Other"]).then((value) {
//       for (var depenses in value) {
//         final depense = Depense(
//           motifDepense: depenses['motifDepense'].toString(),
//           dateDepense: DateFormat.yMMMEd().format(depenses['dateDepense']),
//           ordreDepense: depenses['ordreDepense'].toString(),
//           typeDepense: depenses['typeDepense'].toString(),
//           montantDepense: depenses['montantDepense'],
//           idDepense: depenses['idDepense'],
//         );
//         // depense.voir();

//         list.add(depense);
//       }
//     });
//     return list;
//   }

//   // end of class
// }
