import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deri/variables.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/ui/firebase_sorted_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Projet {
  final String idProjet;

  final String titreProjet;
  final String descriptionProjet;
  final DateTime dateDebut;
  final DateTime dateFin;
  // final int estimationBudget;
  final double pourcentage;
  String fornisseurFont;
  String? images;
  var statuProjet = status[0];
  Projet({
    required this.idProjet,
    required this.titreProjet,
    required this.descriptionProjet,
    required this.dateDebut,
    required this.dateFin,
    // required this.estimationBudget,
    // required this.statuProjet,
    required this.fornisseurFont,
    this.images,
    this.pourcentage = 0.0,
  });

  factory Projet.fromMap(Map<String, dynamic> map) => Projet(
        idProjet: map['idProjet'],
        titreProjet: map['titreProjet'],
        descriptionProjet: map['descriptionProjet'],
        dateDebut: (map['dateDebut'] as Timestamp).toDate(),
        dateFin: (map['dateFin'] as Timestamp).toDate(),
        // estimationBudget: map['estimationBudget'],
        // statuProjet: map['statuProjet'],
        images: map['images'],
        pourcentage: map['pourcentage'],
        fornisseurFont: map['fornisseurFont'],
      );
  void voir() {
    debugPrint('''
  idProjet: $idProjet,
  titre Projet : $titreProjet,
  descriptionProjet : $descriptionProjet,
  dateDebut : $dateDebut,
  dateFin : $dateFin,  
  "statuProjet" : $statuProjet
  images : $images
  fornisseurFont: $fornisseurFont
''');
  }

  toMap() => {
        'idProjet': idProjet,
        'titreProjet': titreProjet,
        'descriptionProjet': descriptionProjet,
        "dateDebut": dateDebut,
        'dateFin': dateFin,
        // 'estimationBudget': estimationBudget,
        'statuProjet': statuProjet,
        "images": images,
        'pourcentage': pourcentage,
        // "fornisseurFont": fornisseurFont
      };
  // Future<void> save() async {
  //   final connection = await DatabaseOnline.instance.connection();
  //   await connection.query("""INSERT INTO Projets(
  //     idProjet,idProjetPere,titreProjet,descriptionProjet,dateDebut,dateFin,estimationBudget,statuProjet
  //   )VALUES(?,?,?,?,?,?,?,?);""", [
  //     idProjet,
  //     idProjetPere,
  //     titreProjet,
  //     descriptionProjet,
  //     dateDebut,
  //     dateFin,
  //     estimationBudget,
  //     statuProjet!
  //   ]).then((value) {
  //     debugPrint("le retour de la sauvegarde est est $value");
  //   });
  // }
  save(File? file) async {
    final ref = FirebaseStorage.instance.ref("Project");
    if (file == null) {
      images = "";
      await projetCollections.doc(idProjet.toString()).set(toMap());
    } else {
      try {
        ref.child(idProjet).putFile(file).whenComplete(() async {
          images = await ref.child(idProjet).getDownloadURL();
          voir();
          await projetCollections.doc(idProjet.toString()).set(toMap());
        });
      } catch (e) {
        // print(e.toString());
      }
    }
  }

  // static Stream<List<Projet>> get projetsfournisseur => projetCollections
  //     .where("fornisseurFont",
  //         isEqualTo: authentication.currentUser!.displayName)
  //     .snapshots()
  //     .map((snapshot) => snapshot.docs
  //         .map((projet) => Projet.fromMap(projet.data()))
  //         .toList());
  static Stream<Projet> oneProjet(String puid) => projetCollections
      .doc(puid)
      .snapshots()
      .map((event) => Projet.fromMap(event.data()!));

  static Stream<List<Projet>> get projets =>
      projetCollections.snapshots().map((snapshot) => snapshot.docs
          .map((projet) => Projet.fromMap(projet.data()))
          .toList());

  // static Future<List<Projet>> projets() async {
  //   final List<Projet> list = [];
  //   final connection = await DatabaseOnline.instance.connection();
  //   await connection.query(
  //       "SELECT* FROM Projets where idProjetPere = ? ORDER BY idProjet DESC",
  //       [0]).then((connRsult) {
  //     // print('le resulta de la requette de selectionz: $connRsult');
  //     for (var projet in connRsult) {
  //       final projets = Projet(
  //         idProjet: projet['idProjet'],
  //         idProjetPere: projet['idProjetPere'],
  //         titreProjet: projet['titreProjet'].toString(),
  //         descriptionProjet: projet['descriptionProjet'].toString(),
  //         dateDebut: projet['dateDebut'].toString(),
  //         dateFin: projet['dateFin'].toString(),
  //         estimationBudget: projet['estimationBudget'],
  //         statuProjet: projet['statuProjet'].toString(),
  //       );
  //       list.add(projets);
  //     }
  //   });

  //   return list;
  // }
}
