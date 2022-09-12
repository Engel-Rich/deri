// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:deri/databases/databaonline.dart';
// import 'package:deri/models/depense.dart';
// import 'package:deri/models/projet.dart';
// import 'package:intl/intl.dart';

// class DepenseProjet {
//   final Projet projet;
//   final Depense depense;

//   DepenseProjet({required this.depense, required this.projet});

//   isertion() async {
//     final connection = await DatabaseOnline.instance.connection();
//     await connection.query(
//         "INSERT INTO DepensesProjet(idProjet, idDepense) Values(?,?)",
//         [projet.idProjet, depense.idDepense]);
//   }

//   static Future<List<DepenseProjet>> dapensesProjet() async {
//     List<DepenseProjet> list = [];
//     final connection = await DatabaseOnline.instance.connection();
//     await connection
//         .query(
//             "SELECT * FROM Projets INNER JOIN DepensesProjet ON DepensesProjet.idProjet = Projets.idProjet INNER JOIN Depense ON DepensesProjet.idDepense = Depense.idDepense ORDER BY Depense.dateDepense DESC ")
//         .then((value) {
//       for (var depenses in value) {
//         final projet = Projet(
//           idProjet: depenses['idProjet'],
//           titreProjet: depenses['titreProjet'].toString(),
//           descriptionProjet: depenses['descriptionProjet'].toString(),
//           dateDebut: (depenses['dateDebut'] as Timestamp).toDate(),
//           dateFin: (depenses['dateFin'] as Timestamp).toDate(),
//           estimationBudget: depenses['estimationBudget'],
//           statuProjet: depenses['statuProjet'].toString(),
//         );
//         // projet.voir();
//         final depense = Depense(
//           motifDepense: depenses['motifDepense'].toString(),
//           dateDepense: DateFormat.yMMMEd().format(depenses['dateDepense']),
//           ordreDepense: depenses['ordreDepense'].toString(),
//           typeDepense: depenses['typeDepense'].toString(),
//           montantDepense: depenses['montantDepense'],
//           idDepense: depenses['idDepense'],
//         );
//         depense.voir();
//         list.add(DepenseProjet(depense: depense, projet: projet));
//       }
//     });
//     return list;
//   }
// }
