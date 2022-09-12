// ignore_for_file: avoid_print

import 'package:date_time_picker/date_time_picker.dart';
import 'package:deri/models/agenda.dart';
import 'package:deri/services/notification.dart';
import 'package:deri/variables.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AgendaUI extends StatefulWidget {
  const AgendaUI({Key? key}) : super(key: key);

  @override
  State<AgendaUI> createState() => _AgendaUIState();
}

class _AgendaUIState extends State<AgendaUI> {
  TextEditingController titleController = TextEditingController();
  TextEditingController jourController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController heurController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String date = "";
  String heure = "";
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Agenda>>(
          stream: Agenda.agendas(),
          builder: (context, AsyncSnapshot<List<Agenda>> snapshot) {
            if (snapshot.hasData) {
              List<Agenda>? agenda = snapshot.data;
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () async {
                  await Agenda.agendas();
                  setState(() {});
                },
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: ListView.builder(
                      itemCount: agenda!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Card(
                              child: ListTile(
                                  onTap: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Column(
                                              children: [
                                                Text(
                                                  agenda[index].title,
                                                  textAlign: TextAlign.center,
                                                  style: styletext.copyWith(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 70,
                                                  child: Center(
                                                    child: Text(
                                                      "date : ${agenda[index].jour}",
                                                      style: styletext.copyWith(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 40,
                                                  child: Center(
                                                    child: Divider(
                                                      height: 2,
                                                      thickness: 1,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            content: Text(
                                              agenda[index].description ??
                                                  'Aucune description pour cet évenement',
                                              style: styletext,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(8),
                                            actions: [
                                              TextButton(
                                                onPressed: () {},
                                                child: Text(
                                                  'Modifie',
                                                  style: styletext,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  try {
                                                    agenda[index].delete();
                                                    NotificationApi.swoNotification(
                                                        title:
                                                            agenda[index].title,
                                                        body:
                                                            "Vous aves supprime avec succés l'évènement ${agenda[index].description}",
                                                        payload: '2');
                                                  } catch (e) {
                                                    print(
                                                        "Erreur de supression $e");
                                                  }
                                                },
                                                child: Text(
                                                  'Delete',
                                                  style: styletext,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Quit',
                                                  style: styletext,
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  title: Text(
                                    agenda[index].title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: styletext.copyWith(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Icon(Icons.watch_later),
                                      Text(DateFormat("dd MM y")
                                          .format(agenda[index].jour)),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                    ],
                                  ))),
                        );
                      }),
                ),
              );
            } else {
              return Center(
                child: spinkit(context),
              );
            }
          }),

      //Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add Even', style: styletext),
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Column(
                    children: [
                      Text(
                        'Ajouter un evenement',
                        style: styletext.copyWith(
                            fontSize: 17, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(
                        height: 2,
                        thickness: 1,
                      ),
                    ],
                  ),
                  content: Form(
                    key: _formkey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: TextFormField(
                              validator: (val) {
                                if (val!.trim().isEmpty) {
                                  return 'Titre vide';
                                }
                                return null;
                              },
                              controller: titleController,
                              style: styletext.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                              autocorrect: true,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: 3,
                              minLines: 1,
                              decoration: InputDecoration(
                                icon: const CircleAvatar(
                                  child: Icon(
                                    Icons.article,
                                  ),
                                ),
                                hintText: 'entrer le titre de l\'article',
                                contentPadding: const EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: TextFormField(
                              maxLines: 3,
                              minLines: 1,
                              validator: (val) {
                                return null;
                              },
                              controller: descController,
                              autocorrect: true,
                              textCapitalization: TextCapitalization.sentences,
                              style: styletext,
                              decoration: InputDecoration(
                                icon: const CircleAvatar(
                                  child: Icon(
                                    Icons.description,
                                  ),
                                ),
                                hintText:
                                    'entrer la description  de l\'article',
                                contentPadding: const EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),

                          // selectionner la date
                          DateTimePicker(
                            controller: jourController,
                            type: DateTimePickerType.dateTimeSeparate,
                            dateMask: 'd MMM, yyyy',
                            // initialValue: DateTime.now().toString(),
                            dateHintText: DateFormat.yMd()
                                .format(DateTime.now())
                                .toString(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                            // icon: const CircleAvatar(
                            //   child: Icon(
                            //     Icons.date_range,
                            //   ),
                            // ),
                            dateLabelText: 'Date',
                            timeLabelText: "Hour",
                            style: styletext,
                            validator: (val) {
                              if (val!.trim().isEmpty) {
                                return 'veiller choisir la date';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              debugPrint(val);
                              setState(() {
                                date = val;
                              });
                              debugPrint('date : $date');
                            },
                          ),
                          // heure selecttion
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 15),
                          //   child: DateTimePicker(
                          //     controller: heurController,
                          //     type: DateTimePickerType.time,
                          //     icon: const CircleAvatar(
                          //       child: Icon(
                          //         Icons.watch_later_sharp,
                          //       ),
                          //     ),
                          //     dateLabelText: 'Date',
                          //     timeLabelText: "Hour",
                          //     style: styletext,
                          //     timeHintText:
                          //         DateFormat.Hms().format(DateTime.now()),
                          //     // initialValue: TimeOfDay.now().toString(),
                          //     firstDate: DateTime.now(),
                          //     lastDate: DateTime(2100),
                          //     validator: (val) {
                          //       if (val!.trim().isEmpty) {
                          //         // return 'veillez choisir la l\'heure';
                          //         setState(() {
                          //           heurController.text =
                          //               DateFormat.Hm().format(DateTime.now());
                          //         });
                          //       }
                          //       return null;
                          //     },
                          //     onChanged: (val) {
                          //       setState(() {
                          //         heure = val;
                          //       });
                          //       debugPrint('Heure : $heure');
                          //     },
                          //   ),
                          // ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _formkey.currentState!.reset();
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Annuler',
                                      style: styletext,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                                child: Center(
                                  child:
                                      VerticalDivider(width: 2, thickness: 1),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formkey.currentState!.validate()) {
                                        Agenda agenda = Agenda(
                                          idAgenda: DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString(),
                                          title: titleController.text,
                                          jour: DateTime.parse(
                                              jourController.text),
                                          description: descController.text,
                                        );
                                        debugPrint(
                                            'title: ${agenda.title}, description : ${agenda.description}, jour : ${agenda.jour} ');
                                        try {
                                          agenda.createAgendas();
                                        } catch (e) {
                                          print('Erreur de sauvegarde $e');
                                        }
                                        NotificationApi.swoNotification(
                                            title: agenda.title,
                                            body: agenda.description,
                                            payload: '2');
                                        setState(() {
                                          _formkey.currentState!.reset();
                                        });

                                        Navigator.pop(context);
                                      } else {
                                        NotificationApi.swoNotification(
                                            id: 0,
                                            title: "Ajout de l'agenda",
                                            body:
                                                'Erreur d\'ajout de l\'agenda  toutes les informations ne sont pas remplies',
                                            payload: 'succes.abs');
                                        Fluttertoast.showToast(
                                          msg:
                                              "Veillez Vérifier les informations",
                                          toastLength: Toast.LENGTH_LONG,
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    )),
                                    child: Text(
                                      'Ajouter',
                                      style: styletext,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        icon: const Icon(Icons.add_sharp),
        backgroundColor: Colors.blueGrey.shade300,
      ),
    );
  }
}
