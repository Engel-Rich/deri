// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:deri/databases/databaonline.dart';
import 'package:deri/variables.dart';

class Agenda {
  String idAgenda;
  final String title;
  final String? description;
  final DateTime jour;
  final bool ispass;
  final int rappel;

  Agenda({
    required this.idAgenda,
    required this.title,
    this.ispass = false,
    this.description,
    required this.jour,
    this.rappel = 1,
  });

  factory Agenda.fromMap(Map<String, dynamic> agenda) => Agenda(
      idAgenda: agenda['idAgenda'],
      title: agenda['title'],
      jour: (agenda['jour'] as Timestamp).toDate(),
      description: agenda['description'],
      rappel: agenda['rappel'],
      ispass: agenda["ispass"]);

  Map<String, dynamic> toMap() => {
        'idAgenda': idAgenda,
        'title': title,
        'jour': Timestamp.fromDate(jour),
        'description': description,
        'ispass': ispass,
        "rappel": rappel,
      };

  // stream agenda list for spécifique date
  static Stream<List<Agenda>> agendaSpecific(Timestamp timestamp) =>
      agendaCollections
          .where("jour", isEqualTo: timestamp)
          .where("jour", isLessThanOrEqualTo: timestamp)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Agenda.fromMap(e.data())).toList());

  // for all
  static Stream<List<Agenda>> agendas() {
    return agendaCollections.orderBy("jour", descending: true).snapshots().map(
        (event) => event.docs.map((e) => Agenda.fromMap(e.data())).toList());
    // final list = <Agenda>[];
    // final con = await DatabaseOnline.instance.connection();
    // await con.query("Select * From Agenda").then((value) {
    //   for (var agent in value) {
    //     final agenda = Agenda(
    //       title: agent['title'].toString(),
    //       jour: agent['jour'].toString(),
    //       heure: agent['heure'].toString(),
    //       idAgenda: agent['idAgenda'],
    //       description: agent['description'].toString(),
    //     );
    //     list.add(agenda);
    //   }
    // });
    // con.close();
    // return list;
  }

  createAgendas() async {
    await agendaCollections.doc(idAgenda).set(toMap());
    // final con = await DatabaseOnline.instance.connection();
    // await con.query(
    //     "INSERT INTO Agenda(title,jour,heure,idAgenda,description)VALUES(?,?,?,?,?);",
    //     [title, jour, heure, idAgenda, description]).then(
    //   (value) => print('la valeur de retour de la sauvegarde est $value'),
    // );
  }

  delete() async {
    await agendaCollections.doc(idAgenda).delete();
    // final con = await DatabaseOnline.instance.connection();
    // await con.query("DELETE FROM Agenda Where idAgenda = ?", [idAgenda]).then(
    //   (value) => print('la valeur de retour de la supression est $value'),
    // );
  }

  // createAgenda({
  //   required String title,
  //   required String heure,
  //   required String jour,
  //   String? description,
  // }) {
  //   return Agenda(idAgenda: idAgenda, title: title, jour: jour, heure: heure);
  // }
}
