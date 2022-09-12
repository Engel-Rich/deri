import 'package:deri/Firebases/firebaseusers.dart';
import 'package:deri/interfaces/adds/addsoustask.dart';
// import 'package:deri/models/user.dart';
import 'package:deri/variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:deri/models/task.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DetailTasl extends StatefulWidget {
  final Task task;
  const DetailTasl({Key? key, required this.task}) : super(key: key);

  @override
  State<DetailTasl> createState() => _DetailTaslState();
}

class _DetailTaslState extends State<DetailTasl> {
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
    return Scaffold(
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
                    border: Border.all(color: Colors.blueGrey.shade100)),
            padding: const EdgeInsets.only(bottom: 50, right: 8, left: 10),
            margin: EdgeInsets.symmetric(
                horizontal: estGrand(context) ? 30 : 10, vertical: 50),
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
                spacervertical(20),
                traithorizontal(),
                spacervertical(10),
                MouseRegion(
                  child: Stack(
                    children: [
                      Container(
                        decoration: showEditUserButton
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.blueGrey.shade200, width: 5),
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
                              borderRadius: BorderRadius.circular(20)),
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
                                      future: UserApp.getOneUser(idUser),
                                      builder: (context, snapshot) {
                                        return CircleAvatar(
                                          // padding: const EdgeInsets.all(8),
                                          // decoration: const BoxDecoration(
                                          //     shape: BoxShape.circle,
                                          //     color: Colors.blueAccent),
                                          backgroundColor: Colors.blue[50],
                                          radius: 90,
                                          child: (snapshot.hasData &&
                                                  !snapshot.hasError &&
                                                  snapshot.data!.profile !=
                                                      null)
                                              ? ClipOval(
                                                  child: Image.network(
                                                    snapshot.data!.profile!,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                )
                                              : const Center(
                                                  child: Icon(Icons.person,
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
                                        future: UserApp.getOneUser(idUser),
                                        builder: (context, snapshot) {
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
                                                          snapshot.data!.name,
                                                          style: styletext
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 15),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        Text(
                                                            snapshot
                                                                .data!.email,
                                                            style: styletext
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ],
                                                    ),
                                                  )
                                                : const CircularProgressIndicator(
                                                    strokeWidth: 1.0,
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
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blueGrey.shade200,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                                onPressed: () async {
                                  setUser(context, list, widget.task,
                                      validUser: idUser);
                                  setState(() {
                                    reloadNam = false;
                                  });
                                  await Future.delayed(
                                      const Duration(microseconds: 50));
                                  setState(() {
                                    reloadNam = true;
                                  });
                                },
                                icon: const Icon(Icons.edit),
                                label: texter('user'),
                              ),
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
                spacerheight(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Status : ",
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
                                      snapshot.data!.statusTask.isNotEmpty)
                                  ? Text(
                                      "${snapshot.data!.statusTask} ",
                                      style: styletext.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.blue[800]),
                                    )
                                  : const Expanded(
                                      child: LinearProgressIndicator());
                        }),
                    IconButton(
                        onPressed: () {
                          setStatue(context, widget.task);
                          setState(() {});
                        },
                        icon: const Icon(Icons.edit))
                  ],
                ),
                spacervertical(20),
                StreamBuilder<Task>(
                    stream: Task.onTaskstream(
                        widget.task.idProjetPere.toString(),
                        widget.task.idTask.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CircularPercentIndicator(
                          radius: 45,
                          percent: snapshot.data!.pourcentage / 100,
                          progressColor: Colors.green,
                          lineWidth: 8,
                          center: texter('${snapshot.data!.pourcentage}%'),
                        );
                      } else if (snapshot.hasError) {
                        return texter(snapshot.error.toString());
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
                spacervertical(30),
                Row(
                  children: [
                    Text(
                      "Sous Taches",
                      style: styletext.copyWith(
                          fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                spacerheight(10),
                StreamBuilder<List<SousTask>>(
                    stream: SousTask.soutask(
                        taskid: widget.task.idTask.toString(),
                        idProjet: widget.task.idProjetPere.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final data = snapshot.data![index];
                            return ListTile(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: texter('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              data.delete();
                                              Navigator.of(context).pop();
                                              setState(() {});
                                            },
                                            child: texter('Delete'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              setStatuesub(context, data);
                                            },
                                            child: texter('Set Statue'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              title: texter(data.titre),
                              subtitle: texter(data.statut),
                              trailing: data.statut == "end"
                                  ? const Icon(Icons.check,
                                      size: 30, color: Colors.green)
                                  : data.statut == "running"
                                      ? const Icon(
                                          Icons.run_circle_outlined,
                                          size: 30,
                                          color: Colors.orange,
                                        )
                                      : const Icon(
                                          Icons.start,
                                          size: 30,
                                          color: Colors.blue,
                                        ),
                            );
                          },
                        );
                      } else if (snapshot.hasData && snapshot.data!.isEmpty) {
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
        backgroundColor: Colors.blue[800],
        onPressed: () {
          Navigator.of(context).push(PageTransition(
              child: AddSouTask(task: widget.task),
              type: PageTransitionType.fade));
        },
        label: texter("add sub task"),
      ),
    );
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

  // change User Function

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
                .map((user) => ListTile(
                      title: Text(user.name, style: styletitle),
                      subtitle: texter(user.email),
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      trailing: (validUser != null && validUser == user.userid)
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
                    ))
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
}
