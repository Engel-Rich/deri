// ignore_for_file: avoid_print

// import 'package:date_time_picker/date_time_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:deri/Firebases/firebaseusers.dart';
import 'package:deri/interfaces/View/detailtask.dart';
// import 'package:deri/interfaces/View/detailtask.dart';
import 'package:deri/interfaces/adds/addtask.dart';
import 'package:deri/interfaces/app/splash.dart';
import 'package:deri/models/projet.dart';
import 'package:deri/models/task.dart';
import 'package:deri/models/widgetchange.dart';
// import 'package:deri/models/user.dart';
import 'package:deri/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

// import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import 'package:percent_indicator/percent_indicator.dart';

// import 'package:percent_indicator/percent_indicator.dart';

class DetailProjet extends StatefulWidget {
  final Projet project;
  const DetailProjet({Key? key, required this.project}) : super(key: key);

  @override
  State<DetailProjet> createState() => _DetailProjetState();
}

class _DetailProjetState extends State<DetailProjet> {
  final controller = Get.put(DetailProjetController());

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
  Color bleu = const Color.fromRGBO(6, 57, 112, 0.80);
  @override
  void initState() {
    controller.changeWiget(getlistSoustask());
    // listUser();
    super.initState();
    // listTask();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserApp>(
        stream: UserApp.getOneUserStream(authentication.currentUser!.uid),
        builder: (context, snapuser) {
          if ((!snapuser.hasError && snapuser.hasData)) {
            return Scaffold(
              backgroundColor:
                  !Get.isDarkMode ? Colors.grey[350] : Colors.grey[900],
              body: Column(
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      minHeight: 100,
                      maxHeight: 180,
                      minWidth: double.infinity,
                    ),
                    padding:
                        const EdgeInsets.only(top: 30, left: 20, right: 15),
                    decoration: BoxDecoration(
                        color: bleu,
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(30))),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            estPlusGrand(context)
                                ? const SizedBox.shrink()
                                : InkWell(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: CircleAvatar(
                                      backgroundColor: !Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      child: Icon(Icons.arrow_back,
                                          size: 30,
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                          ],
                        ),
                        Text(
                          widget.project.titreProjet,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: styletext.copyWith(
                            letterSpacing: 3,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // les choses que j'ai enlevé.
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
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buttonsSelected(() {
                            controller.changeWiget(getlistSoustask());
                            setState(() {
                              actuelwidget = 1;
                            });
                          }, 'In Progress', 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.5, vertical: 10),
                            child: VerticalDivider(
                              thickness: 3,
                              color: bleu,
                            ),
                          ),
                          buttonsSelected(() {
                            setState(() {
                              actuelwidget = 2;
                            });
                            controller.changeWiget(getlistSoustaskUser());
                          }, "Assigned", 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.5, vertical: 10),
                            child: VerticalDivider(
                              thickness: 3,
                              color: bleu,
                            ),
                          ),
                          buttonsSelected(() {
                            setState(() {
                              actuelwidget = 3;
                            });
                            controller.changeWiget(getlistSoustaskEnd());
                          }, "Completed", 3),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(() => controller.curentWidget.value),
                  )
                  // trait,
                  // StreamBuilder<List<Task>>(
                  //     stream: Task.tasks(widget.project.idProjet),
                  //     builder: (context, snapshot) {
                  //       return snapshot.hasError
                  //           ? texter(snapshot.error.toString())
                  //           : snapshot.hasData
                  //               ? snapshot.data!.isNotEmpty
                  //                   ? ListView.builder(
                  //                       shrinkWrap: true,
                  //                       physics:
                  //                           const NeverScrollableScrollPhysics(),
                  //                       itemCount: snapshot.data!.length,
                  //                       itemBuilder: (context, index) {
                  //                         return Padding(
                  //                           padding:
                  //                               const EdgeInsets.all(8.0),
                  //                           child: Container(
                  //                             decoration: BoxDecoration(
                  //                               borderRadius:
                  //                                   BorderRadius.circular(20),
                  //                               border: Border.all(
                  //                                 width: 1,
                  //                                 color: Colors
                  //                                     .blueGrey.shade300,
                  //                               ),
                  //                             ),
                  //                             child: ListTile(
                  //                               leading: Stack(
                  //                                 children: [
                  //                                   CircularPercentIndicator(
                  //                                       progressColor:
                  //                                           Colors.green,
                  //                                       backgroundColor:
                  //                                           Colors.amber
                  //                                               .shade100,
                  //                                       percent: snapshot
                  //                                               .data![index]
                  //                                               .pourcentage /
                  //                                           100,
                  //                                       radius: 27),
                  //                                   snapshot.data![index]
                  //                                           .userId.isNotEmpty
                  //                                       ? Padding(
                  //                                           padding:
                  //                                               const EdgeInsets
                  //                                                   .all(6),
                  //                                           child: StreamBuilder<
                  //                                                   UserApp>(
                  //                                               stream: UserApp
                  //                                                   .getOneUserStream(snapshot
                  //                                                       .data![
                  //                                                           index]
                  //                                                       .userId),
                  //                                               builder:
                  //                                                   (context,
                  //                                                       snapu) {
                  //                                                 return (!snapu.hasError &&
                  //                                                         snapu
                  //                                                             .hasData &&
                  //                                                         snapu.data!.profile !=
                  //                                                             null)
                  //                                                     ? CircleAvatar(
                  //                                                         backgroundColor:
                  //                                                             Colors.blue[50],
                  //                                                         backgroundImage:
                  //                                                             NetworkImage(snapu.data!.profile!),
                  //                                                       )
                  //                                                     : CircleAvatar(
                  //                                                         backgroundColor:
                  //                                                             Colors.blue[50],
                  //                                                         backgroundImage:
                  //                                                             const AssetImage("assets/taskview.png"),
                  //                                                       );
                  //                                               }),
                  //                                         )
                  //                                       : CircleAvatar(
                  //                                           backgroundColor:
                  //                                               Colors
                  //                                                   .blue[50],
                  //                                           backgroundImage:
                  //                                               const AssetImage(
                  //                                                   "assets/taskview.png"),
                  //                                         ),
                  //                                 ],
                  //                               ),
                  //                               title: Text(
                  //                                 snapshot
                  //                                     .data![index].titleTask,
                  //                                 style: styletitle,
                  //                                 overflow:
                  //                                     TextOverflow.ellipsis,
                  //                               ),
                  //                               subtitle: FutureBuilder<
                  //                                       UserApp>(
                  //                                   future:
                  //                                       UserApp.getOneUser(
                  //                                           snapshot
                  //                                               .data![index]
                  //                                               .userId),
                  //                                   builder: (context, snap) {
                  //                                     return (snap.hasData &&
                  //                                             snap.data!
                  //                                                     .userid !=
                  //                                                 null)
                  //                                         ? Text(
                  //                                             snap.data!.name,
                  //                                             style:
                  //                                                 styletitle,
                  //                                           )
                  //                                         : snap.hasError
                  //                                             ? texter(
                  //                                                 "administrator")
                  //                                             : const SizedBox(
                  //                                                 height: 8,
                  //                                                 width: 8,
                  //                                                 child:
                  //                                                     LinearProgressIndicator(),
                  //                                               );
                  //                                   }),
                  //                               trailing: (!snapuser.hasError &&
                  //                                       snapuser.hasData &&
                  //                                       !snapuser.data!
                  //                                           .fournisseur! &&
                  //                                       (snapuser.data!
                  //                                                   .userid ==
                  //                                               snapshot
                  //                                                   .data![
                  //                                                       index]
                  //                                                   .userId ||
                  //                                           snapuser.data!
                  //                                               .isadmin!))
                  //                                   ? PopupMenuButton(
                  //                                       onSelected: (item) {
                  //                                       if (item == 1) {
                  //                                         deleteTask(
                  //                                           context,
                  //                                           snapshot
                  //                                               .data![index],
                  //                                         );
                  //                                         Task.tasks(widget
                  //                                             .project
                  //                                             .idProjet);
                  //                                         setState(() {});
                  //                                       }
                  //                                       if (item == 2) {
                  //                                         setStatue(
                  //                                             context,
                  //                                             snapshot.data![
                  //                                                 index]);
                  //                                         Task.tasks(widget
                  //                                             .project
                  //                                             .idProjet);
                  //                                         setState(() {});
                  //                                       }
                  //                                       if (item == 3) {
                  //                                         Navigator.push(
                  //                                             context,
                  //                                             PageTransition(
                  //                                                 child: DetailTasl(
                  //                                                     task: snapshot.data![
                  //                                                         index]),
                  //                                                 type: PageTransitionType
                  //                                                     .fade));
                  //                                       }
                  //                                     }, itemBuilder:
                  //                                           (context) {
                  //                                       if (true) {
                  //                                         return [
                  //                                           PopupMenuItem(
                  //                                             value: 3,
                  //                                             child: texter(
                  //                                                 "Setting of task"),
                  //                                           ),
                  //                                           PopupMenuItem(
                  //                                             value: 1,
                  //                                             child: texter(
                  //                                                 "delete"),
                  //                                           ),
                  //                                           PopupMenuItem(
                  //                                             value: 2,
                  //                                             child: texter(
                  //                                                 "Set Statue"),
                  //                                           )
                  //                                         ];
                  //                                       }
                  //                                       // } else if (Users
                  //                                       //         .userSession.userId ==
                  //                                       //     snapshot.data![index]
                  //                                       //         .userId) {
                  //                                       //   return [
                  //                                       //     PopupMenuItem(
                  //                                       //       value: 2,
                  //                                       //       child: texter(
                  //                                       //           "Set Statue"),
                  //                                       //     )
                  //                                       //   ];
                  //                                       // } else {
                  //                                       //   return [];
                  //                                       // }
                  //                                     })
                  //                                   : const SizedBox.shrink(),
                  //                             ),
                  //                           ),
                  //                         );
                  //                       },
                  //                     )
                  //                   : Row(
                  //                       children: [
                  //                         Text(
                  //                           'no atsk for the project',
                  //                           style: styletitle.copyWith(
                  //                             color: Colors.amber,
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     )
                  //               : const SizedBox.shrink();
                  //     }),
                ],
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
                                // la modal bottom sheet
                              },
                            )
                          ],
                        ),
            );
          } else {
            return snapuser.hasError
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
          }
        });
  }

  int actuelwidget = 1;
  buttonsSelected(Function()? onPressed, String name, int valnum) =>
      ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            padding: const EdgeInsets.all(15),
            backgroundColor:
                actuelwidget == valnum ? Colors.blue.shade400 : bleu),
        child: Text(
          name,
          style: styletext.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
      );

// display one task or subtask

  Widget taskView({Task? task, SousTask? sousTask}) {
    return StreamBuilder<UserApp>(
        stream: sousTask == null
            ? UserApp.getOneUserStream(task!.userId)
            : UserApp.getOneUserStream(sousTask.userRespo),
        builder: (context, snapshot) {
          // snapshot.printError(info: 'Erreur des users :');
          snapshot.printInfo();
          return
              // snapshot.hasError
              //     ? texter(snapshot.error.toString())
              //     :
              InkWell(
            onTap: () {
              if (task != null) {
                Navigator.of(context).push(PageTransition(
                    child: DetailTask(task: task),
                    type: PageTransitionType.fade));
              }
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Flexible(
                    flex: 7,
                    child: ListTile(
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue.shade400),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: (snapshot.hasData &&
                                  snapshot.data!.profile != null &&
                                  snapshot.data!.profile!.isNotEmpty)
                              ? CachedNetworkImage(
                                  imageUrl: snapshot.data!.profile!,
                                  placeholder: (context, url) {
                                    return spinkit(context);
                                  },
                                  fit: BoxFit.cover,
                                )
                              : const Center(
                                  child: Icon(Icons.person,
                                      size: 45, color: Colors.white)),
                        ),
                      ),
                      title: Text(
                        sousTask == null ? task!.titleTask : sousTask.titre,
                        style: styletitle,
                      ),
                      subtitle: Text('snapshot.data!.name',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: styletext),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: CircularPercentIndicator(
                      radius: 28,
                      backgroundColor: ((sousTask == null &&
                                  task!.pourcentage == 100) ||
                              (sousTask != null && sousTask.pourcentage == 100))
                          ? Colors.green
                          : Colors.blue.shade400,
                      progressColor: bleu,
                      center: ((sousTask == null && task!.pourcentage == 100) ||
                              (sousTask != null && sousTask.pourcentage == 100))
                          ? const Icon(
                              Icons.check_circle,
                              size: 30,
                              color: Colors.green,
                            )
                          : Text(
                              sousTask == null
                                  ? "${task!.pourcentage.toInt()}%"
                                  : "${sousTask.pourcentage.toInt()}%",
                              style: styletext.copyWith(
                                  letterSpacing: 0.5,
                                  color: bleu,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

// liste des sous taches pour l'utilisateur.

  soutaskList({String? iduser, bool? end}) {
    // bool forUser = iduser != null;
    return StreamBuilder<List<Task>>(
        stream: Task.tasks(widget.project.idProjet),
        builder: (context, AsyncSnapshot<List<Task>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: texter(snapshot.error.toString()),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: texter('Aucune Donnée'),
            );
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final task = snapshot.data![index];

              return StreamBuilder<List<SousTask>>(
                  stream: SousTask.soutask(
                      taskid: task.idTask.toString(),
                      idProjet: task.idProjetPere.toString()),
                  builder: (context, snapshotTask) {
                    if (!snapshotTask.hasData || snapshotTask.data!.isEmpty) {
                      if (end == null) {
                        if (iduser == null) {
                          return taskView(task: task);
                        } else {
                          if ((iduser == task.userId)) {
                            return taskView(task: task);
                          } else {
                            return Center(
                              child: ListTile(
                                title: Text(
                                  "No task for you in this project",
                                  style: styletitle.copyWith(
                                      fontSize: 16,
                                      letterSpacing: 4,
                                      color: bleu),
                                ),
                              ),
                            );
                          }
                        }
                      } else {
                        if (task.pourcentage == 100) {
                          return taskView(task: task);
                        } else {
                          return const SizedBox.shrink();
                        }
                      }
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: texter(''),
                      );
                    }
                    return StreamBuilder<UserApp>(
                        stream: UserApp.getOneUserStream(task.userId),
                        builder: (context, snapshot) {
                          return Card(
                            elevation: 40.0,
                            color: Colors.blue.shade100,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: ExpansionTile(
                              textColor:
                                  Get.isDarkMode ? Colors.white : Colors.black,
                              iconColor:
                                  Get.isDarkMode ? Colors.white : Colors.black,
                              subtitle: texter('${task.pourcentage} %'),
                              leading: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue.shade400),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: (snapshot.hasData &&
                                          snapshot.data!.profile != null &&
                                          snapshot.data!.profile!.isNotEmpty)
                                      ? CachedNetworkImage(
                                          imageUrl: snapshot.data!.profile!,
                                          placeholder: (context, url) {
                                            return spinkit(context);
                                          },
                                          fit: BoxFit.cover,
                                        )
                                      : const Center(
                                          child: Icon(Icons.person,
                                              size: 45, color: Colors.white)),
                                ),
                              ),
                              childrenPadding: const EdgeInsets.all(10),
                              title: Text(
                                task.titleTask,
                                style: styletitle,
                                maxLines: 2,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(PageTransition(
                                      child: DetailTask(task: task),
                                      type: PageTransitionType.fade));
                                },
                                icon: const Icon(
                                  Icons.mode_edit_outline,
                                  size: 40,
                                ),
                              ),
                              children:
                                  snapshotTask.data!.map((SousTask sousTaski) {
                                if (end != null &&
                                    sousTaski.pourcentage == 100) {
                                  return taskView(sousTask: sousTaski);
                                } else {
                                  return iduser == null
                                      ? taskView(sousTask: sousTaski)
                                      : (iduser.trim() == task.userId.trim())
                                          ? taskView(sousTask: sousTaski)
                                          : Center(
                                              child: Text(
                                                "Tu n'a aucune tâche dans ce projets",
                                                style: styletitle.copyWith(
                                                    fontSize: 30,
                                                    letterSpacing: 4,
                                                    color: bleu),
                                              ),
                                            );
                                }
                              }).toList(),
                            ),
                          );
                        });
                  });
            },
          );
        });
  }

// Task for connected User.
  taskUsers(String idUser) {
    return StreamBuilder<List<Task>>(
        stream: Task.tasks(widget.project.idProjet),
        builder: (context, AsyncSnapshot<List<Task>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: texter(snapshot.error.toString()),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: texter('Aucune Donnée'),
            );
          }
          return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final task = snapshot.data![index];
                return StreamBuilder<List<SousTask>>(
                    stream: SousTask.soutask(
                        taskid: task.idTask.toString(),
                        idProjet: task.idProjetPere.toString()),
                    builder: (context, snapshotTask) {
                      if (!snapshotTask.hasData || snapshotTask.data!.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: texter(snapshot.error.toString()),
                        );
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshotTask.data!.length,
                          itemBuilder: (context, index) {
                            if (snapshotTask.data![index].userRespo == idUser) {
                              return taskView(task: task);
                            } else {
                              return const SizedBox.shrink();
                            }
                          });
                    });
              });
        });
  }

// task terminate
  taskend() {
    return StreamBuilder<List<Task>>(
        stream: Task.tasks(widget.project.idProjet),
        builder: (context, AsyncSnapshot<List<Task>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: texter(snapshot.error.toString()),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: texter('Aucune Donnée'),
            );
          }
          return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final task = snapshot.data![index];
                return task.pourcentage == 100
                    ? taskView(task: task)
                    : const SizedBox.shrink();
                // return StreamBuilder<List<SousTask>>(
                //     stream: SousTask.soutask(
                //         taskid: task.idTask.toString(),
                //         idProjet: task.idProjetPere.toString()),
                //     builder: (context, snapshotTask) {
                //       if (!snapshotTask.hasData || snapshotTask.data!.isEmpty) {
                //         return const SizedBox.shrink();
                //       }
                //       if (snapshot.hasError) {
                //         return Center(
                //           child: texter(snapshot.error.toString()),
                //         );
                //       }
                //       return ListView.builder(
                //           shrinkWrap: true,
                //           physics: const NeverScrollableScrollPhysics(),
                //           itemCount: snapshotTask.data!.length,
                //           itemBuilder: (context, index) {
                //             if (snapshotTask.data![index].userRespo == idUser) {
                //               return taskView(task: task);
                //             } else {
                //               return const SizedBox.shrink();
                //             }
                //           });
                //     });
              });
        });
  }

  Container getlistSoustask() => Container(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: soutaskList(),
        ),
      );
  Container getlistSoustaskEnd() => Container(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: taskend(),
        ),
      );

// les taches des utilisateurs
  Container getlistSoustaskUser() => Container(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: taskUsers(authentication.currentUser!.uid),
        ),
      );

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
            // set status
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

// la speed dial

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

// set status

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

// les choses que j'ai enlevé
// spacerheight(15),
// StreamBuilder<Projet>(
//     stream: Projet.oneProjet(widget.project.idProjet),
//     builder: (context, snapshot) {
//       return (snapshot.hasData &&
//               snapshot.data!.idProjet.isNotEmpty)
//           ? LinearPercentIndicator(
//               curve: Curves.bounceInOut,
//               center: Text(
//                   '${snapshot.data!.pourcentage} %',
//                   style: styletitle),
//               progressColor: Colors.green,
//               backgroundColor: Colors.amber.shade100,
//               lineHeight: 25,
//               percent:
//                   snapshot.data!.pourcentage / 100,
//             )
//           : snapshot.hasError
//               ? texter(snapshot.error.toString())
//               : const CircularProgressIndicator();
//     }),

// // trait,
// spacerheight(15),
// Row(
//   children: [
//     Padding(
//       padding: const EdgeInsets.all(10),
//       child: Text(
//         "Description Of Projet",
//         style: styletext.copyWith(
//           fontWeight: FontWeight.bold,
//           fontSize: 20,
//         ),
//       ),
//     ),
//   ],
// ),

// Row(
//   children: [
//     Padding(
//       padding: const EdgeInsets.all(8.0),
//     ),
//   ],
// )
// Row

// la modal bottom sheet

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
