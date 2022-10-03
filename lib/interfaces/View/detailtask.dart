import 'package:cached_network_image/cached_network_image.dart';
import 'package:deri/Firebases/firebaseusers.dart';
import 'package:deri/interfaces/adds/addsoustask.dart';
import 'package:deri/interfaces/app/splash.dart';
// import 'package:deri/models/user.dart';
import 'package:deri/variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:deri/models/task.dart";
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DetailTask extends StatefulWidget {
  final Task task;
  const DetailTask({Key? key, required this.task}) : super(key: key);

  @override
  State<DetailTask> createState() => _DetailTaslState();
}

class _DetailTaslState extends State<DetailTask> {
  @override
  void initState() {
    listUser();
    super.initState();
    setState(() {
      idUser = widget.task.userId;
    });
  }

  double valueProgress = 0.65;
  bool showEditUserButton = kIsWeb ? false : true;
  String idUser = "";
  bool reloadNam = true;
  List<UserApp> list = [];
  void listUser() async {
    var liste = await UserApp.futureUser();
    setState(() {
      list = liste!;
    });
    if (kDebugMode) {
      print(list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserApp>(
        stream: UserApp.getOneUserStream(authentication.currentUser!.uid),
        builder: (context, snapshot) {
          return (!snapshot.hasError && snapshot.hasData)
              ? Scaffold(
                  appBar: AppBar(),
                  body: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Center(
                      child: Container(
                        width: estGrand(context) ? 600 : taille(context).width,
                        decoration: !estGrand(context)
                            ? null
                            : BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.blueGrey.shade100)),
                        padding: const EdgeInsets.only(
                            bottom: 50, right: 8, left: 10),
                        margin: EdgeInsets.symmetric(
                            horizontal: estGrand(context) ? 30 : 10,
                            vertical: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.task.titleTask,
                              style: styletitle.copyWith(
                                letterSpacing: 3,
                                fontSize: 18,
                              ),
                            ),

                            traithorizontal(),
                            spacervertical(10),
                            MouseRegion(
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: showEditUserButton
                                        ? BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Colors.blueGrey.shade200,
                                                width: 5),
                                          )
                                        : null,
                                    width: 500,
                                    height: estGrand(context) ? 200 : 300,
                                  ),
                                  Container(
                                    width: 500,
                                    height: estGrand(context) ? 200 : 300,
                                    padding: const EdgeInsets.all(3),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Wrap(
                                          alignment: WrapAlignment.spaceEvenly,
                                          children: [
                                            Align(
                                              alignment: !estGrand(context)
                                                  ? Alignment.center
                                                  : Alignment.centerLeft,
                                              child: FutureBuilder<UserApp>(
                                                  future: UserApp.getOneUser(
                                                      idUser),
                                                  builder: (context, snapshot) {
                                                    return CircleAvatar(
                                                      // padding: const EdgeInsets.all(8),
                                                      // decoration: const BoxDecoration(
                                                      //     shape: BoxShape.circle,
                                                      //     color: Colors.blueAccent),
                                                      backgroundColor:
                                                          Colors.blue[50],
                                                      radius: 90,
                                                      child: (snapshot
                                                                  .hasData &&
                                                              !snapshot
                                                                  .hasError &&
                                                              snapshot.data!
                                                                      .profile !=
                                                                  null)
                                                          ? ClipOval(
                                                              child:
                                                                  Image.network(
                                                                snapshot.data!
                                                                    .profile!,
                                                                fit: BoxFit
                                                                    .cover,
                                                                width: double
                                                                    .infinity,
                                                                height: double
                                                                    .infinity,
                                                              ),
                                                            )
                                                          : const Center(
                                                              child: Icon(
                                                                  Icons.person,
                                                                  size: 150),
                                                            ),
                                                    );
                                                  }),
                                            ),
                                            const SizedBox(
                                              width: 30,
                                            ),
                                            (reloadNam)
                                                ? FutureBuilder<UserApp>(
                                                    future: UserApp.getOneUser(
                                                        idUser),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasError) {
                                                        return Expanded(
                                                            child: texter(
                                                                "Aucun Utilisateur selectionné"));
                                                      } else {
                                                        return snapshot.hasData
                                                            ? Expanded(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Text(
                                                                      snapshot
                                                                          .data!
                                                                          .name,
                                                                      style: styletext.copyWith(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              15),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                    Text(
                                                                        snapshot
                                                                            .data!
                                                                            .email,
                                                                        style: styletext
                                                                            .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis),
                                                                  ],
                                                                ),
                                                              )
                                                            : const CircularProgressIndicator(
                                                                strokeWidth:
                                                                    1.0,
                                                              );
                                                      }
                                                    })
                                                : const SizedBox.shrink(),
                                            spacerheight(20),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  showEditUserButton
                                      ? Positioned(
                                          right: 0.0,
                                          top: 0.0,
                                          child: snapshot.data!.isadmin!
                                              ? ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.blueGrey
                                                                  .shade200,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 15,
                                                                  horizontal:
                                                                      8),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          )),
                                                  onPressed: () async {
                                                    setUser(context, list,
                                                        widget.task,
                                                        validUser: idUser);
                                                    setState(() {
                                                      reloadNam = false;
                                                    });
                                                    await Future.delayed(
                                                        const Duration(
                                                            microseconds: 50));
                                                    setState(() {
                                                      reloadNam = true;
                                                    });
                                                  },
                                                  icon: const Icon(Icons.edit),
                                                  label: texter('user'),
                                                )
                                              : Container(),
                                        )
                                      : const SizedBox.shrink()
                                ],
                              ),
                              onExit: (event) {
                                setState(() {
                                  showEditUserButton = false;
                                });
                              },
                              onEnter: (event) {
                                setState(() {
                                  showEditUserButton = true;
                                });
                              },
                            ),
                            spacerheight(30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Progress : ",
                                  style: styletext.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                StreamBuilder<Task>(
                                    stream: Task.onTaskstream(
                                        widget.task.idProjetPere.toString(),
                                        widget.task.idTask.toString()),
                                    builder: (context, snapshot) {
                                      // print(snapshot.data!.idTask);
                                      return snapshot.hasError
                                          ? texter('Error for get status')
                                          : (snapshot.hasData &&
                                                  snapshot.data!.statusTask
                                                      .isNotEmpty)
                                              ? Expanded(
                                                  child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20),
                                                  child: LinearPercentIndicator(
                                                    backgroundColor:
                                                        Colors.blue.shade50,
                                                    progressColor:
                                                        Colors.green.shade400,
                                                    percent: snapshot
                                                            .data!.pourcentage /
                                                        100,
                                                    lineHeight: 20,
                                                    center: texter(snapshot
                                                        .data!.pourcentage
                                                        .toStringAsFixed(2)),
                                                  ),
                                                ))
                                              : Expanded(
                                                  child: spinkit(context));
                                    }),
                                IconButton(
                                    onPressed: () {
                                      setStatue(context, widget.task);
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.edit))
                              ],
                            ),
                            // spacervertical(20),
                            // StreamBuilder<Task>(
                            //     stream: Task.onTaskstream(
                            //         widget.task.idProjetPere.toString(),
                            //         widget.task.idTask.toString()),
                            //     builder: (context, snapshot) {
                            //       if (snapshot.hasData) {
                            //         return CircularPercentIndicator(
                            //           radius: 45,
                            //           percent: snapshot.data!.pourcentage / 100,
                            //           progressColor: Colors.green,
                            //           lineWidth: 8,
                            //           center: texter(
                            //               '${snapshot.data!.pourcentage}%'),
                            //         );
                            //       } else if (snapshot.hasError) {
                            //         return texter(snapshot.error.toString());
                            //       } else {
                            //         return const CircularProgressIndicator();
                            //       }
                            //     }),
                            spacervertical(30),
                            // Row(
                            //   children: [
                            //     Text(
                            //       "Sous Taches",
                            //       style: styletext.copyWith(
                            //           fontSize: 16,
                            //           fontWeight: FontWeight.w800),
                            //     ),
                            //   ],
                            // ),
                            // spacerheight(10),
                            StreamBuilder<List<SousTask>>(
                                stream: SousTask.soutask(
                                    taskid: widget.task.idTask.toString(),
                                    idProjet:
                                        widget.task.idProjetPere.toString()),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data!.isNotEmpty) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        final data = snapshot.data![index];
                                        return taskView(sousTask: data);
                                        // return ListTile(
                                        //   onTap: () {
                                        //     showDialog(
                                        //         context: context,
                                        //         builder: (context) {
                                        //           return SimpleDialog(
                                        //             children: [
                                        //               TextButton(
                                        //                 onPressed: () {
                                        //                   Navigator.pop(
                                        //                       context);
                                        //                 },
                                        //                 child: texter('Cancel'),
                                        //               ),
                                        //               TextButton(
                                        //                 onPressed: () {
                                        //                   data.delete();
                                        //                   Navigator.of(context)
                                        //                       .pop();
                                        //                   setState(() {});
                                        //                 },
                                        //                 child: texter('Delete'),
                                        //               ),
                                        //               TextButton(
                                        //                 onPressed: () {
                                        //                   Navigator.pop(
                                        //                       context);
                                        //                   setStatuesub(
                                        //                       context, data);
                                        //                 },
                                        //                 child: texter(
                                        //                     'Set Statue'),
                                        //               ),
                                        //             ],
                                        //           );
                                        //         });
                                        //   },
                                        //   title: texter(data.titre),
                                        //   subtitle: texter(data.statut),
                                        //   trailing: data.statut == "end"
                                        //       ? const Icon(Icons.check,
                                        //           size: 30, color: Colors.green)
                                        //       : data.statut == "running"
                                        //           ? const Icon(
                                        //               Icons.run_circle_outlined,
                                        //               size: 30,
                                        //               color: Colors.orange,
                                        //             )
                                        //           : const Icon(
                                        //               Icons.start,
                                        //               size: 30,
                                        //               color: Colors.blue,
                                        //             ),
                                        // );
                                      },
                                    );
                                  } else if (snapshot.hasData &&
                                      snapshot.data!.isEmpty) {
                                    return Text("no subtask for this task",
                                        style: styletitle);
                                  } else if (snapshot.hasError) {
                                    return Text(snapshot.error.toString());
                                  } else {
                                    return const LinearProgressIndicator();
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  floatingActionButton: FloatingActionButton.extended(
                    backgroundColor: bleu,
                    onPressed: () {
                      Navigator.of(context).push(PageTransition(
                          child: AddSouTask(task: widget.task),
                          type: PageTransitionType.fade));
                    },
                    label: texter("add sub task"),
                  ),
                )
              : snapshot.hasError
                  ? Scaffold(
                      appBar: AppBar(),
                      body: Center(
                          child: Text(
                        snapshot.error.toString(),
                        style: styletext.copyWith(
                          color: Colors.red,
                        ),
                      )),
                    )
                  : const SpalshSCreen();
        });
  }

// ends functions
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
                    decoration: const BoxDecoration(
                      border: Border.symmetric(
                        vertical: BorderSide(width: 2, color: Colors.blue),
                      ),
                    ),
                    child: ListTile(
                        title: texter(statut),
                        hoverColor: Colors.blueGrey.shade100,
                        leading: Icon(
                          Icons.arrow_forward_ios,
                          color: task.statusTask == statut
                              ? Colors.green
                              : Colors.blue,
                        ),
                        onTap: () {
                          if (statut.isNotEmpty) {
                            task.setStatut(statut);
                            Navigator.pop(context);
                            setState(() {});
                          } else {
                            Fluttertoast.showToast(
                                msg: "Selected task is null");
                          }
                        }),
                  ),
                )
                .toList(),
          );
        });
  }

  Color bleu = const Color.fromRGBO(6, 57, 112, 0.80);
  // change User Function
  Widget taskView({required SousTask sousTask}) {
    return StreamBuilder<UserApp>(
        stream: UserApp.getOneUserStream(sousTask.userRespo),
        builder: (context, snapshot) {
          // snapshot.printError(info: 'Erreur des users :');
          return
              // snapshot.hasError
              //     ? texter(snapshot.error.toString())
              //     :
              InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      children: [
                        TextButton(
                          onPressed: () {
                            sousTask.delete();
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          child: texter('Delete'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setStatuesub(context, sousTask);
                          },
                          child: texter('Set Statue'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setValuesub(context, sousTask);
                          },
                          child: texter('Set percent value'),
                        ),
                      ],
                    );
                  });
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
                        sousTask.titre,
                        style: styletitle,
                      ),
                      subtitle: Text(
                        'UserName',
                        style: styletext,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: CircularPercentIndicator(
                      radius: 28,
                      backgroundColor: sousTask.pourcentage == 100
                          ? Colors.green
                          : Colors.blue.shade400,
                      progressColor: bleu,
                      center: sousTask.pourcentage == 100
                          ? const Icon(
                              Icons.check_circle,
                              size: 30,
                              color: Colors.green,
                            )
                          : Text(
                              "${sousTask.pourcentage.toInt()}%",
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

  setUser(BuildContext context, List<UserApp> list, Task task,
      {String? validUser}) {
    showDialog(
        context: context,
        builder: (context) {
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
            actions: list
                .map((user) => !user.fournisseur!
                    ? ListTile(
                        title: Text(user.name, style: styletitle),
                        subtitle: texter(user.email),
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        trailing:
                            (validUser != null && validUser == user.userid)
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                : const SizedBox.shrink(),
                        onTap: () {
                          task.upDateUser(user.userid!);
                          setState(() {
                            idUser = user.userid!;
                          });
                          Navigator.pop(context);
                        },
                      )
                    : Container())
                .toList(),
          );
        });
  }

  setStatuesub(
    BuildContext context,
    SousTask task,
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
                          color: task.statut == statut
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
                            color: task.statut == statut
                                ? Colors.green
                                : Colors.blue),
                        onTap: () {
                          Navigator.pop(context);
                          task.setsSatut(statut);
                          setState(() {});
                        }),
                  ),
                )
                .toList(),
          );
        });
  }

  // set subtask Value;

  setValuesub(
    BuildContext context,
    SousTask task,
  ) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: [
                Text("Change task persent value", style: styletitle),
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
            content: Form(
              key: percentKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: percent,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'enter required percent value';
                      } else if (val.trim().length > 3 ||
                          double.parse(val) > 100) {
                        return "the value is not grether than 100";
                      } else {
                        return null;
                      }
                    },
                    style: styletext,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintStyle: styletext,
                      border: const UnderlineInputBorder(),
                      hintText: "enter percent value",
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: texter("Annuler")),
                      TextButton(
                          onPressed: () {
                            if (percentKey.currentState!.validate()) {
                              task.setspourcentage(
                                double.parse(percent.text.trim()),
                              );
                            }
                          },
                          child: texter("Vilad")),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  TextEditingController percent = TextEditingController();
  final percentKey = GlobalKey<FormFieldState>();
}
