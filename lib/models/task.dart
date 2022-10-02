// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:deri/models/projet.dart';
import 'package:deri/variables.dart';
import 'package:flutter/material.dart';

class Task {
  final int idTask;
  final int idProjetPere;
  final DateTime limiteTask;
  final String titleTask;
  final String statusTask;
  final String userId;
  final int importance;
  double pourcentage;

  Task({
    required this.idTask,
    required this.idProjetPere,
    required this.titleTask,
    required this.limiteTask,
    this.statusTask = "waitting",
    required this.userId,
    this.importance = 1,
    this.pourcentage = 0.0,
  });
  usersColletion() => taskCollection(idProjetPere.toString())
      .doc(idTask.toString())
      .collection('Users');

  // set Projet progresse Val
  static setProjectVal(idProjetPere) async {
    int taille = 0;
    final projet = projetCollections.doc(idProjetPere.toString());
    await projetCollections
        .doc(idProjetPere.toString())
        .update({"pourcentage": 0.0});
    final List<DocumentSnapshot<Map<String, dynamic>>> list =
        await projetCollections
            .doc(idProjetPere.toString())
            .collection("Task")
            .get()
            .then((value) {
      taille = value.size;
      return value.docs.map((task) {
        final val = task.data()['pourcentage'] / taille;
        return task;
      }).toList();
    });
    for (var elm in list) {
      final val = elm.data()!['pourcentage'] / taille;
      print("value : $val");
      await projet.update({"pourcentage": FieldValue.increment(val)});
    }
  }

  saveTask() async {
    int taille = 0;
    final projet = projetCollections.doc(idProjetPere.toString());
    final collection = taskCollection(idProjetPere.toString());
    await collection.doc(idTask.toString()).set(toMap());
    setProjectVal(idProjetPere);
    // final connection = await DatabaseOnline.instance.connection();
    // await connection.query(
    //   "INSERT INTO Task(idTask,idProjetPere,titleTask,limiteTask,statusTask,userId) VALUES (?,?,?,?,?,?)",
    //   [idTask, idProjetPere, titleTask, limiteTask, statusTask, userId],
    // ).then((value) {
    //   connection.close();
    // });
  }

  toMap() => {
        "idTask": idTask,
        "idProjetPere": idProjetPere,
        "titleTask": titleTask,
        "limiteTask": limiteTask,
        "statusTask": statusTask,
        'userId': userId,
        "importance": importance,
        "pourcentage": pourcentage,
      };

  upDateUser(String iduser) async {
    await taskCollection(idProjetPere.toString())
        .doc(idTask.toString())
        .update({"userId": iduser});
    // final con = await DatabaseOnline.instance.connection();
    // await con.query("UPDATE Task SET userId = ? Where idTask= ? ",
    //     [iduser, idTask]).then((value) => con.close());
  }

  setStatut(String statut) async {
    final projet = projetCollections.doc(idProjetPere.toString());
    int taille = 0;
    double pourcentages = 0.0;
    await taskCollection(idProjetPere.toString())
        .doc(idTask.toString())
        .update({"statusTask": statut});
    if (statut == "end") {
      pourcentages = 100;
    } else {
      pourcentages = 0.0;
    }
    await taskCollection(idProjetPere.toString())
        .doc(idTask.toString())
        .update({"pourcentage": pourcentages});
    await projetCollections
        .doc(idProjetPere.toString())
        .update({"pourcentage": 0.0});
    final List<DocumentSnapshot<Map<String, dynamic>>> list =
        await projetCollections
            .doc(idProjetPere.toString())
            .collection("Task")
            .get()
            .then((value) {
      taille = value.size;
      print(taille);
      return value.docs.map((task) {
        return task;
      }).toList();
    });
    for (var elm in list) {
      final val = elm.data()!['pourcentage'] / taille;
      print("value : $val");
      await projet.update({"pourcentage": FieldValue.increment(val)});
    }

    // final con = await DatabaseOnline.instance.connection();
    // await con.query("UPDATE Task SET statusTask = ? Where idTask= ? ",
    //     [statut, idTask]).then((value) => con.close());
  }

  static Future<Task> onTask(String idper, String idTask) =>
      taskCollection(idper)
          .doc(idTask)
          .get()
          .then((elmt) => Task.froMap(elmt.data()!));
  static Stream<Task> onTaskstream(String idper, String idTask) =>
      taskCollection(idper)
          .doc(idTask)
          .snapshots()
          .map((elmnt) => Task.froMap(elmnt.data()!));
  // update(
  //     {required String tasktitleTask,
  //     required String tasklimiteTask,
  //     required String taskstatusTask}) async {
  //   final con = await DatabaseOnline.instance.connection();
  //   await con.query(
  //     "UPDATE Task SET titleTask = ?, limiteTask= ?, statusTask= ? WHERE idTask= ?",
  //     [
  //       tasktitleTask,
  //       tasklimiteTask,
  //       taskstatusTask,
  //       idTask,
  //     ],
  //   ).then((value) => con.close());
  // }

  // static Future<String> getStatu(int idtask) async {
  //   var statu = "";
  //   final con = await DatabaseOnline.instance.connection();
  //   await con
  //       .query("SELECT * FROM Task WHERE idTask = ?", [idtask]).then((value) {
  //     statu = value.first['statusTask'].toString();
  //     print('''idTask : $idtask  statut : $statu''');
  //     print(value);
  //     con.close();
  //   });
  //   return statu;
  // }

  delete() async {
    await taskCollection(idProjetPere.toString())
        .doc(idTask.toString())
        .delete();
    // final con = await DatabaseOnline.instance.connection();
    // await con.query("DELETE FROM Task WHERE idTask = ? ", [idTask]);
    // con.close();
  }
  //

  factory Task.froMap(Map<String, dynamic> list) => Task(
        idTask: list['idTask'],
        idProjetPere: list['idProjetPere'],
        titleTask: list['titleTask'],
        limiteTask: (list['limiteTask'] as Timestamp).toDate(),
        statusTask: list['statusTask'],
        userId: list['userId'],
        pourcentage: list['pourcentage'].toDouble(),
      );

  //
  static Stream<List<Task>> tasks(idPere) {
    return taskCollection(idPere)
        .snapshots()
        .map((event) => event.docs.map((e) => Task.froMap(e.data())).toList());
  }
}

//
// class sous taches.
//

class SousTask {
  final String titre;
  final int importance;
  final String id;
  String taskid;
  String idProjet;
  double pourcentage;
  final String? userRepo;
  final String statut;
  SousTask({
    required this.importance,
    required this.titre,
    required this.id,
    required this.taskid,
    required this.idProjet,
    this.userRepo,
    this.pourcentage = 0.0,
    this.statut = "waitting",
  });

  toMap() => {
        "titre": titre,
        "importance": importance,
        "id": id,
        'taskid': taskid,
        "idProjet": idProjet,
        "pourcentage": pourcentage,
        'statut': statut,
        'user': userRepo
      };
  factory SousTask.fromMap(Map<String, dynamic> map) => SousTask(
        idProjet: map['idProjet'],
        taskid: map['taskid'],
        importance: map['importance'],
        titre: map['titre'],
        id: map['id'],
        pourcentage: map['pourcentage'],
        userRepo: map['user'],
        statut: map['statut'],
      );

  save() async {
    int taille = 0;
    await taskCollection(idProjet)
        .doc(taskid)
        .collection("Soustaches")
        .doc(id)
        .set(toMap());
    await taskCollection(idProjet).doc(taskid).update({"pourcentage": 0.0});
    final List<DocumentSnapshot<Map<String, dynamic>>> list =
        await taskCollection(idProjet)
            .doc(taskid)
            .collection("Soustaches")
            .get()
            .then((value) {
      taille = value.size;
      return value.docs.map((elmt) {
        return elmt;
      }).toList();
    });
    for (var element in list) {
      final val = element.data()!['pourcentage'] / taille;
      await taskCollection(idProjet)
          .doc(taskid)
          .update({"pourcentage": FieldValue.increment(val)});

      taskCollection(idProjet).doc(taskid).get().then((value) async {
        if (value.data()!['pourcentage'] == 100) {
          await taskCollection(idProjet).doc(taskid).get().then((value) {
            final tks = Task.froMap(value.data()!);
            tks.setStatut('end');
          }); // update({"statut": 'end'});

        }
      });
    }
    Task.setProjectVal(idProjet);
  }

  delete() async {
    int taille = 0;
    await taskCollection(idProjet)
        .doc(taskid)
        .collection("Soustaches")
        .doc(id)
        .delete();
    await taskCollection(idProjet).doc(taskid).update({"pourcentage": 0.0});
    final List<DocumentSnapshot<Map<String, dynamic>>> list =
        await taskCollection(idProjet)
            .doc(taskid)
            .collection("Soustaches")
            .get()
            .then((value) {
      taille = value.size;
      return value.docs.map((elmt) {
        return elmt;
      }).toList();
    });
    for (var element in list) {
      final val = element.data()!['pourcentage'] / taille;
      if (element.data()!['pourcentage'] == 100) {
        await taskCollection(idProjet)
            .doc(taskid)
            .update({"pourcentage": FieldValue.increment(val)});
      }
      taskCollection(idProjet).doc(taskid).get().then((value) async {
        if (value.data()!['pourcentage'] == 100) {
          await taskCollection(idProjet).doc(taskid).update({"statut": 'end'});
        }
      });
    }
    Task.setProjectVal(idProjet);
  }

  voir() {
    debugPrint('''id : $id,
pourcentage : $pourcentage,
statut : $statut,
taskId: $taskid,
projetId : $idProjet
titre: $titre''');
  }

  setsSatut(String statutes) async {
    voir();
    int taille = 0;
    double pourcent = 0;
    if (statutes == "end") {
      pourcent = 100;
    } else if (statutes.trim() == 'running') {
      pourcent = 30;
    }
    await taskCollection(idProjet)
        .doc(taskid)
        .collection("Soustaches")
        .doc(id)
        .update({"statut": statutes, "pourcentage": pourcent});
    await taskCollection(idProjet).doc(taskid).update({"pourcentage": 0.0});
    final List<DocumentSnapshot<Map<String, dynamic>>> list =
        await taskCollection(idProjet)
            .doc(taskid)
            .collection("Soustaches")
            .get()
            .then((value) {
      taille = value.size;
      return value.docs.map((elmt) {
        return elmt;
      }).toList();
    });
    for (var element in list) {
      final val = element.data()!['pourcentage'] / taille;
      print(val);

      await taskCollection(idProjet)
          .doc(taskid)
          .update({"pourcentage": FieldValue.increment(val.toInt())});

      taskCollection(idProjet).doc(taskid).get().then((value) async {
        if (value.data()!['pourcentage'] == 100) {
          await taskCollection(idProjet).doc(taskid).update({"statut": 'end'});
        }
      });
    }
    Task.setProjectVal(idProjet);
  }

  static Stream<List<SousTask>> soutask(
          {required String taskid, required String idProjet}) =>
      taskCollection(idProjet)
          .doc(taskid)
          .collection("Soustaches")
          .snapshots()
          .map(
            (event) => event.docs
                .map(
                  (e) => SousTask.fromMap(e.data()),
                )
                .toList(),
          );

// liste des listes des taches ??

}
