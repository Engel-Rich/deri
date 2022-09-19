// ignore_for_file: avoid_print

// import 'package:date_time_picker/date_time_picker.dart';
import 'package:deri/Firebases/firebaseusers.dart';
import 'package:deri/interfaces/View/detailtask.dart';
import 'package:deri/interfaces/adds/addtask.dart';
import 'package:deri/interfaces/app/splash.dart';
import 'package:deri/models/projet.dart';
import 'package:deri/models/task.dart';
// import 'package:deri/models/user.dart';
import 'package:deri/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import 'package:percent_indicator/percent_indicator.dart';

class DetailProjet extends StatefulWidget {
  final Projet project;
  const DetailProjet({Key? key, required this.project}) : super(key: key);

  @override
  State<DetailProjet> createState() => _DetailProjetState();
}

class _DetailProjetState extends State<DetailProjet> {
  // final _formkey = GlobalKey<FormState>();
  // final TextEditingController _controllertitle = TextEditingController();
  // final TextEditingController _controllerdate = TextEditingController();
  // List<Users> list = [];
  // void listUser() async {
  //   var liste = await Users.userList();
  //   setState(() {
  //     list = liste!;
  //   });
  //   print(list);
  // }

  double valueProgress = 0.65;
  Widget trait = const Padding(
    padding: EdgeInsets.only(right: 15.0, left: 15.0, bottom: 25.0),
    child: SizedBox(
      height: 10,
      child: Center(
        child: Divider(),
      ),
    ),
  );
  var dataTask = <Task>[];
  // listTask() async {
  //   dataTask = await Task.tasks(widget.project.idProjet);
  // }

  @override
  void initState() {
    // listUser();
    super.initState();
    // listTask();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserApp>(
        stream: UserApp.getOneUserStream(authentication.currentUser!.uid),
        builder: (context, snapuser) {
          return (!snapuser.hasError && snapuser.hasData)
              ? Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.blueGrey.shade300,
                    title: Text(
                      widget.project.titreProjet,
                      style: styletext.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // actions: [
                    //   Center(
                    //     child: IconButton(
                    //       hoverColor: Colors.blueGrey.shade400,
                    //       color: Colors.blueGrey,
                    //       onPressed: () {
                    //         Task.tasks(widget.project.idProjet);
                    //         setState(() {});
                    //       },
                    //       icon: const Icon(
                    //         Icons.refresh,
                    //         size: 30,
                    //       ),
                    //     ),
                    //   )
                    // ],
                    // leading: IconButton(
                    //   icon: const Icon(Icons.close, color: Colors.blue),
                    //   iconSize: 25,
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    // ),
                    elevation: 0.0,
                  ),
                  body: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: taille(context).width < 640
                          ? taille(context).width * 0.040
                          : taille(context).width * 0.075,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              widget.project.titreProjet,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: styletext.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          spacerheight(15),
                          StreamBuilder<Projet>(
                              stream: Projet.oneProjet(widget.project.idProjet),
                              builder: (context, snapshot) {
                                return (snapshot.hasData &&
                                        snapshot.data!.idProjet.isNotEmpty)
                                    ? LinearPercentIndicator(
                                        curve: Curves.bounceInOut,
                                        center: Text(
                                            '${snapshot.data!.pourcentage} %',
                                            style: styletitle),
                                        progressColor: Colors.green,
                                        backgroundColor: Colors.amber.shade100,
                                        lineHeight: 25,
                                        percent:
                                            snapshot.data!.pourcentage / 100,
                                      )
                                    : snapshot.hasError
                                        ? texter(snapshot.error.toString())
                                        : const CircularProgressIndicator();
                              }),

                          // trait,
                          spacerheight(15),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "Description Of Projet",
                                  style: styletext.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Row(
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //     ),
                          //   ],
                          // )
                          // Row
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              widget.project.descriptionProjet,
                              style: styletext.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 20,
                              child: Center(
                                child: Divider(),
                              ),
                            ),
                          ),
                          //Building of Project task
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Text(
                                  "Task Of Projet",
                                  style: styletext.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // trait,
                          StreamBuilder<List<Task>>(
                              stream: Task.tasks(widget.project.idProjet),
                              builder: (context, snapshot) {
                                return snapshot.hasError
                                    ? texter(snapshot.error.toString())
                                    : snapshot.hasData
                                        ? snapshot.data!.isNotEmpty
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    snapshot.data!.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        border: Border.all(
                                                          width: 1,
                                                          color: Colors.blueGrey
                                                              .shade300,
                                                        ),
                                                      ),
                                                      child: ListTile(
                                                        leading: Stack(
                                                          children: [
                                                            CircularPercentIndicator(
                                                                progressColor:
                                                                    Colors
                                                                        .green,
                                                                backgroundColor:
                                                                    Colors.amber
                                                                        .shade100,
                                                                percent: snapshot
                                                                        .data![
                                                                            index]
                                                                        .pourcentage /
                                                                    100,
                                                                radius: 27),
                                                            snapshot
                                                                    .data![
                                                                        index]
                                                                    .userId
                                                                    .isNotEmpty
                                                                ? Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(6),
                                                                    child: StreamBuilder<
                                                                            UserApp>(
                                                                        stream: UserApp.getOneUserStream(snapshot
                                                                            .data![
                                                                                index]
                                                                            .userId),
                                                                        builder:
                                                                            (context,
                                                                                snapu) {
                                                                          return (!snapu.hasError && snapu.hasData && snapu.data!.profile != null)
                                                                              ? CircleAvatar(
                                                                                  backgroundColor: Colors.blue[50],
                                                                                  backgroundImage: NetworkImage(snapu.data!.profile!),
                                                                                )
                                                                              : CircleAvatar(
                                                                                  backgroundColor: Colors.blue[50],
                                                                                  backgroundImage: const AssetImage("assets/taskview.png"),
                                                                                );
                                                                        }),
                                                                  )
                                                                : CircleAvatar(
                                                                    backgroundColor:
                                                                        Colors.blue[
                                                                            50],
                                                                    backgroundImage:
                                                                        const AssetImage(
                                                                            "assets/taskview.png"),
                                                                  ),
                                                          ],
                                                        ),
                                                        title: Text(
                                                          snapshot.data![index]
                                                              .titleTask,
                                                          style: styletitle,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        subtitle: FutureBuilder<
                                                                UserApp>(
                                                            future: UserApp
                                                                .getOneUser(
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .userId),
                                                            builder: (context,
                                                                snap) {
                                                              return (snap.hasData &&
                                                                      snap.data!
                                                                              .userid !=
                                                                          null)
                                                                  ? Text(
                                                                      snap.data!
                                                                          .name,
                                                                      style:
                                                                          styletitle,
                                                                    )
                                                                  : snap
                                                                          .hasError
                                                                      ? texter(
                                                                          "administrator")
                                                                      : const SizedBox(
                                                                          height:
                                                                              8,
                                                                          width:
                                                                              8,
                                                                          child:
                                                                              LinearProgressIndicator(),
                                                                        );
                                                            }),
                                                        trailing: (!snapuser
                                                                    .hasError &&
                                                                snapuser
                                                                    .hasData &&
                                                                !snapuser.data!
                                                                    .fournisseur! &&
                                                                (snapuser.data!
                                                                            .userid ==
                                                                        snapshot
                                                                            .data![
                                                                                index]
                                                                            .userId ||
                                                                    snapuser
                                                                        .data!
                                                                        .isadmin!))
                                                            ? PopupMenuButton(
                                                                onSelected:
                                                                    (item) {
                                                                if (item == 1) {
                                                                  deleteTask(
                                                                    context,
                                                                    snapshot.data![
                                                                        index],
                                                                  );
                                                                  Task.tasks(widget
                                                                      .project
                                                                      .idProjet);
                                                                  setState(
                                                                      () {});
                                                                }
                                                                if (item == 2) {
                                                                  setStatue(
                                                                      context,
                                                                      snapshot.data![
                                                                          index]);
                                                                  Task.tasks(widget
                                                                      .project
                                                                      .idProjet);
                                                                  setState(
                                                                      () {});
                                                                }
                                                                if (item == 3) {
                                                                  Navigator.push(
                                                                      context,
                                                                      PageTransition(
                                                                          child:
                                                                              DetailTasl(task: snapshot.data![index]),
                                                                          type: PageTransitionType.fade));
                                                                }
                                                              }, itemBuilder:
                                                                    (context) {
                                                                if (true) {
                                                                  return [
                                                                    PopupMenuItem(
                                                                      value: 3,
                                                                      child: texter(
                                                                          "Setting of task"),
                                                                    ),
                                                                    PopupMenuItem(
                                                                      value: 1,
                                                                      child: texter(
                                                                          "delete"),
                                                                    ),
                                                                    PopupMenuItem(
                                                                      value: 2,
                                                                      child: texter(
                                                                          "Set Statue"),
                                                                    )
                                                                  ];
                                                                }
                                                                // } else if (Users
                                                                //         .userSession.userId ==
                                                                //     snapshot.data![index]
                                                                //         .userId) {
                                                                //   return [
                                                                //     PopupMenuItem(
                                                                //       value: 2,
                                                                //       child: texter(
                                                                //           "Set Statue"),
                                                                //     )
                                                                //   ];
                                                                // } else {
                                                                //   return [];
                                                                // }
                                                              })
                                                            : const SizedBox
                                                                .shrink(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : Row(
                                                children: [
                                                  Text(
                                                    'no atsk for the project',
                                                    style: styletitle.copyWith(
                                                      color: Colors.amber,
                                                    ),
                                                  ),
                                                ],
                                              )
                                        : const SizedBox.shrink();
                              }),
                          spacerheight(50)
                        ],
                      ),
                    ),
                  ),
                  floatingActionButton:
                      (snapuser.data!.fournisseur! || !snapuser.data!.isadmin!)
                          ? null
                          : SpeedDial(
                              buttonSize: const Size(60.0, 60.0),
                              childrenButtonSize: const Size(60.0, 60.0),
                              animatedIcon: AnimatedIcons.event_add,
                              overlayColor: Colors.black,
                              overlayOpacity: 0.4,
                              label: Text(
                                'Add',
                                style: styletext,
                              ),
                              backgroundColor: Colors.blueGrey.shade500,
                              children: [
                                // SpeedDialChild(
                                //   onTap: () {
                                //     Navigator.push(
                                //       context,
                                //       PageTransition(
                                //         child: ProjetAdd(idProjetPere: widget.project.idProjet),
                                //         type: PageTransitionType.fade,
                                //       ),
                                //     );
                                //   },
                                //   label: 'Add Part',
                                //   child: const Icon(
                                //     Icons.add_business_outlined,
                                //     size: 30,
                                //   ),
                                //   backgroundColor: Colors.indigo,
                                //   foregroundColor: Colors.orange,
                                //   labelStyle: styletext,
                                // ),
                                SpeedDialChild(
                                  label: 'Add Task',
                                  child: const Icon(
                                    Icons.task_alt,
                                    size: 30,
                                  ),
                                  backgroundColor: Colors.indigo,
                                  foregroundColor: Colors.orange,
                                  labelStyle: styletext,
                                  onTap: () {
                                    Navigator.of(context).push(PageTransition(
                                        child: AddTask(projet: widget.project),
                                        type: PageTransitionType.fade));
                                    // await showModalBottomSheet(
                                    //     shape: const RoundedRectangleBorder(
                                    //       borderRadius: BorderRadius.vertical(
                                    //         top: Radius.circular(20),
                                    //       ),
                                    //     ),
                                    //     // backgroundColor: Colors.blueGrey.shade100,
                                    //     context: context,
                                    //     builder: (context) {
                                    //       return Container(
                                    //         padding: EdgeInsets.symmetric(
                                    //           vertical: 20,
                                    //           horizontal: taille(context).width * 0.1,
                                    //         ),
                                    //         child: Form(
                                    //           key: _formkey,
                                    //           child: Column(
                                    //             children: [
                                    //               Text(
                                    //                 'Iformations of task',
                                    //                 style: styletitle,
                                    //               ),
                                    //               const SizedBox(
                                    //                 height: 30,
                                    //                 child: Center(
                                    //                   child: Padding(
                                    //                     padding: EdgeInsets.all(8.0),
                                    //                     child: Divider(),
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //               const SizedBox(
                                    //                 height: 15.0,
                                    //               ),
                                    //               TextFormField(
                                    //                 validator: (val) {
                                    //                   return val!.trim().isEmpty
                                    //                       ? "title of task required "
                                    //                       : null;
                                    //                 },
                                    //                 controller: _controllertitle,
                                    //                 minLines: 1,
                                    //                 maxLines: 3,
                                    //                 style: styletext,
                                    //                 decoration: InputDecoration(
                                    //                   hintText: 'title of task',
                                    //                   hintStyle: styletext,
                                    //                   icon: const Icon(Icons.title),
                                    //                   border: const UnderlineInputBorder(
                                    //                     borderSide: BorderSide(width: 1.0),
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //               const SizedBox(
                                    //                 height: 15.0,
                                    //               ),
                                    //               DateTimePicker(
                                    //                 controller: _controllerdate,
                                    //                 validator: (value) {
                                    //                   return value!.trim().isEmpty
                                    //                       ? "date required"
                                    //                       : null;
                                    //                 },
                                    //                 type: DateTimePickerType.date,
                                    //                 icon: const Icon(
                                    //                   Icons.watch_later_sharp,
                                    //                 ),
                                    //                 dateLabelText:
                                    //                     DateFormat.yMEd().format(DateTime.now()),
                                    //                 dateHintText: "Date of limit",
                                    //                 timeLabelText: "Hour",
                                    //                 style: styletext,
                                    //                 timeHintText:
                                    //                     DateFormat.Hms().format(DateTime.now()),
                                    //                 firstDate: DateTime.now(),
                                    //                 lastDate: DateTime(2100),
                                    //                 onChanged: (val) {
                                    //                   print(val);
                                    //                 },
                                    //               ),
                                    //               const SizedBox(
                                    //                 height: 20.0,
                                    //               ),
                                    //               Row(
                                    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //                 children: [
                                    //                   TextButton(
                                    //                     onPressed: () {
                                    //                       Navigator.pop(context);
                                    //                     },
                                    //                     child: Text(
                                    //                       'Cancel',
                                    //                       style: styletext,
                                    //                     ),
                                    //                   ),
                                    //                   TextButton(
                                    //                     onPressed: () {
                                    //                       if (_formkey.currentState!.validate()) {
                                    //                         final task = Task(
                                    //                           idTask: DateTime.now()
                                    //                               .millisecondsSinceEpoch,
                                    //                           idProjetPere:
                                    //                               int.parse(widget.project.idProjet),
                                    //                           titleTask: _controllertitle.text,
                                    //                           limiteTask: DateTime.parse(
                                    //                               _controllerdate.text),
                                    //                           statusTask: status[0]!,
                                    //                           userId: " ",
                                    //                         );
                                    //                         try {
                                    //                           task.saveTask();
                                    //                           setState(() {
                                    //                             _formkey.currentState!.reset();
                                    //                           });
                                    //                           Navigator.pop(context);
                                    //                           setState(() {});
                                    //                           ScaffoldMessenger.of(context)
                                    //                               .showSnackBar(
                                    //                             SnackBar(
                                    //                               action: SnackBarAction(
                                    //                                   label: 'Cancel',
                                    //                                   onPressed: () {}),
                                    //                               content: Text(
                                    //                                   "Task added succesful",
                                    //                                   style: styletext),
                                    //                             ),
                                    //                           );
                                    //                         } catch (e) {
                                    //                           debugPrint(
                                    //                               'Erreur d\'ajout de la tache : $e');
                                    //                         }
                                    //                       }
                                    //                     },
                                    //                     child: Text(
                                    //                       'Vallide',
                                    //                       style: styletext,
                                    //                     ),
                                    //                   ),
                                    //                 ],
                                    //               )
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       );
                                    //     });
                                  },
                                )
                              ],
                            ),
                )
              : snapuser.hasError
                  ? Scaffold(
                      appBar: AppBar(),
                      body: Center(
                          child: Text(
                        snapuser.error.toString(),
                        style: styletext.copyWith(
                          color: Colors.red,
                        ),
                      )),
                    )
                  : const SpalshSCreen();
        });
  }

  dropdown(
    BuildContext context,
    Task task,
  ) {
    UserApp? users;
    showDialog(
        context: context,
        builder: (cntx) {
          return AlertDialog(
            title: Column(
              children: [
                Text("Change User for this task", style: styletitle),
                const SizedBox(
                  height: 40,
                  child: Center(
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                )
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.all(10),
              child: StreamBuilder<List<UserApp>>(
                  stream: UserApp.userapps,
                  builder: (cntx, snapshot) {
                    return snapshot.hasData
                        ? Column(
                            children: snapshot.data!
                                .map(
                                  (e) => ListTile(
                                    onTap: () {
                                      task.upDateUser(e.userid!);
                                    },
                                    title: Text(e.name, style: styletext),
                                    subtitle: Text(e.email,
                                        style:
                                            styletext.copyWith(fontSize: 12)),
                                  ),
                                )
                                .toList(),
                          )
                        : spinkit(context);
                  }),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(cntx);
                },
                child: texter("annuler"),
              ),
              // TextButton(
              //   onPressed: () {
              //     if (users != null) {
              //       // print("idTask :${task.idTask}");
              //       task.upDateUser(users!.userId);
              //       setState(() {});
              //       users = null;
              //       Navigator.pop(context);
              //     } else {
              //       // print("nouser");
              //       users = null;
              //     }
              //   },
              //   child: texter("Valider"),
              // ),
            ],
          );
        });
  }

  setStatue(
    BuildContext context,
    Task task,
  ) {
    var list = <String>["waitting", "running", "end"];

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: [
                Text("Change Task status", style: styletitle),
                const SizedBox(
                  height: 40,
                  child: Center(
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                )
              ],
            ),
            actions: list
                .map(
                  (statut) => Container(
                    margin: const EdgeInsets.only(bottom: 2),
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        vertical: BorderSide(
                          width: 2,
                          color: task.statusTask == statut
                              ? Colors.green
                              : Colors.blue,
                        ),
                      ),
                    ),
                    child: ListTile(
                        title: Text(
                          statut,
                          style: styletitle,
                        ),
                        hoverColor: Colors.blueGrey.shade100,
                        leading: Icon(Icons.arrow_forward_ios,
                            color: task.statusTask == statut
                                ? Colors.green
                                : Colors.blue),
                        onTap: () {
                          task.setStatut(statut);
                          Navigator.pop(context);
                          setState(() {});
                        }),
                  ),
                )
                .toList(),
            //  [
            //   TextButton(
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //     child: texter("annuler"),
            //   ),
            //   TextButton(
            //     onPressed: () {
            //       task.setStatut(selected);
            //       Navigator.pop(context);
            //       setState(() {});
            //       print('status set success');
            //     },
            //     child: texter("Valider"),
            //   ),
            // ],
          );
        });
  }

  deleteTask(BuildContext context, Task task) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: [
                Text("Vouler vous Vraimment suprimer la tache??",
                    style: styletitle),
                const SizedBox(
                  height: 40,
                  child: Center(
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {},
                child: texter("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  task.delete();
                  Navigator.pop(context);
                  setState(() {});
                },
                child: texter("Delete"),
              ),
            ],
          );
        });
  }
}
