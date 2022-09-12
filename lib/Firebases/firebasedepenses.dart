// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deri/variables.dart';

class Depenses {
  final String motif;
  final DateTime date;
  final String ordre;
  final int montant;
  final String type;
  final String idD;
  String? idProjet;

  Depenses({
    required this.motif,
    required this.date,
    required this.ordre,
    required this.type,
    required this.montant,
    required this.idD,
    this.idProjet,
  });

  save() async {
    try {
      await depenseCollections.doc(idD).set(toMap());
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }

  factory Depenses.fromMap(Map<String, dynamic> map) => Depenses(
        motif: map['motif'],
        date: (map['date'] as Timestamp).toDate(),
        ordre: map['ordre'],
        type: map['type'],
        montant: map['montant'],
        idD: map['idD'],
        idProjet: map['idProjet'],
      );

  // Depenses from firebase;

  factory Depenses.fromFireStore(
          DocumentSnapshot<Map<String, dynamic>> documentSnapshot) =>
      Depenses.fromMap(documentSnapshot.data()!);

// List des depenses venant de firebases;

  static Stream<List<Depenses>>? depensesFiretoresProjet(puid) {
    try {
      final data = depenseCollections
          .where("idProjet", isNull: false)
          .where("idProjet", isEqualTo: puid)
          .snapshots()
          .map((snapshots) {
        return snapshots.docs.map((snapshot) {
          return Depenses.fromMap(snapshot.data());
        }).toList();
      });
      // print(data);
      return data;
    } catch (e) {
      print("Error $e");
    }
    return null;
  }

  static Stream<List<Depenses>>? depensesFiretoresOther() {
    try {
      final data = depenseCollections
          .where("idProjet", isNull: true)
          .orderBy("date")
          .snapshots()
          .map((snapshots) {
        return snapshots.docs.map((snapshot) {
          return Depenses.fromMap(snapshot.data());
        }).toList();
      });
      // print(data);
      return data;
    } catch (e) {
      // print("Error $e");
    }
    return null;
  }

  toMap() => {
        "motif": motif,
        "date": Timestamp.fromDate(date),
        "ordre": ordre,
        "type": type,
        "montant": montant,
        "idD": idD,
        'idProjet': idProjet,
      };

  static Stream<List<Depenses>> depensesPeriode(
          DateTime dateDebut, DateTime dateFin) =>
      FirebaseFirestore.instance
          .collection("Depenses")
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(dateDebut))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(dateFin))
          .where("idProjet", isNull: true)
          .orderBy("date", descending: true)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Depenses.fromMap(e.data())).toList());
}

// classe pour les dépenses liées aux projets.
class DepensesProjet {
  String idProjet;
  String idDepense;
  DateTime dateTime;

  DepensesProjet({
    required this.idDepense,
    required this.idProjet,
    required this.dateTime,
  });

  toMap() => {
        'idDepense': idDepense,
        'idProjet': idProjet,
        'dateTime': dateTime,
      };
  factory DepensesProjet.fromMap(Map<String, dynamic> map) => DepensesProjet(
      idDepense: map['idDepense'],
      idProjet: map['idProjet'],
      dateTime: (map['dateTime'] as Timestamp).toDate());

  save() async {
    await FirebaseFirestore.instance
        .collection("DepensesProjet")
        .doc(idProjet)
        .set(toMap());
  }

// deoenses péridique

  //
  static Stream<List<DepensesProjet>> depensesProjets() =>
      FirebaseFirestore.instance
          .collection("DepensesProjet")
          .orderBy("dateTime")
          .snapshots()
          .map((event) =>
              event.docs.map((e) => DepensesProjet.fromMap(e.data())).toList());
}

