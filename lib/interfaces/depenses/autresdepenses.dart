// import 'package:date_time_picker/date_time_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:deri/Firebases/firebasedepenses.dart';
import 'package:deri/interfaces/View/pdfview.dart';
import 'package:deri/interfaces/adds/adddepanse.dart';
// import 'package:deri/models/depense.dart';
import 'package:deri/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class AutresDepenses extends StatefulWidget {
  const AutresDepenses({Key? key}) : super(key: key);

  @override
  State<AutresDepenses> createState() => _AutresDepensesState();
}

class _AutresDepensesState extends State<AutresDepenses> {
  TextEditingController dateDebutDebutController = TextEditingController();
  TextEditingController dateFinController = TextEditingController();
  final periodKey = GlobalKey<FormState>();
  List<Depenses>? depensesList;
  depense(Stream<List<Depenses>> depense) async {
    depensesList = [];
    var list = <Depenses>[];
    await for (var value in depense) {
      list = value;
      for (var val in value) {
        setState(() {
          depensesList!.add(val);
          print(val.toMap());
        });
      }
    }
  }

  selectDate() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Choice Periode", style: styletitle),
            titlePadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            actions: [
              Row(children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        depenses = Depenses.depensesFiretoresOther();
                        time = 'All';
                      });
                      Navigator.pop(context);
                    },
                    child: texter("All"))
              ]),
              Row(children: [
                TextButton(
                    onPressed: () {
                      final dateDebut =
                          DateTime.now().subtract(const Duration(days: 7));
                      setState(() {
                        depenses =
                            Depenses.depensesPeriode(dateDebut, DateTime.now());
                        time =
                            "${DateFormat("d MM y").format(dateDebut)} - ${DateFormat("d MM y").format(DateTime.now())} ";
                      });
                      depense(depenses!);
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: texter("One week Since"))
              ]),
              Row(children: [
                TextButton(
                    onPressed: () {
                      final dateDebut =
                          DateTime.now().subtract(const Duration(days: 14));
                      setState(() {
                        depenses =
                            Depenses.depensesPeriode(dateDebut, DateTime.now());
                        time =
                            "${DateFormat("d MM y").format(dateDebut)} - ${DateFormat("d MM y").format(DateTime.now())} ";
                      });
                      depense(depenses!);
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: texter("two week Since"))
              ]),
              Row(children: [
                TextButton(
                    onPressed: () {
                      final dateDebut =
                          DateTime.now().subtract(const Duration(days: 30));
                      setState(() {
                        depenses =
                            Depenses.depensesPeriode(dateDebut, DateTime.now());
                        time =
                            "${DateFormat("d MM y").format(dateDebut)} - ${DateFormat("d MM y").format(DateTime.now())} ";
                      });
                      depense(depenses!);
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: texter("One Months Since"))
              ]),
              Row(children: [
                TextButton(
                    onPressed: () {
                      final dateDebut =
                          DateTime.now().subtract(const Duration(days: 61));

                      setState(() {
                        depenses =
                            Depenses.depensesPeriode(dateDebut, DateTime.now());
                        time =
                            "${DateFormat("d MM y").format(dateDebut)} - ${DateFormat("d MM y").format(DateTime.now())} ";
                      });
                      depense(depenses!);
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: texter("two Months Since"))
              ]),
              Row(children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Choice Periode", style: styletitle),
                              titlePadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              content: SizedBox(
                                height: 150,
                                child: Form(
                                  key: periodKey,
                                  child: Column(
                                    children: [
                                      DateTimePicker(
                                        type: DateTimePickerType.date,
                                        style: styletext,
                                        firstDate: DateTime(2000),
                                        controller: dateDebutDebutController,
                                        dateHintText: 'Select de start date',
                                        validator: (val) {
                                          return val!.trim().isEmpty
                                              ? "please select required first date"
                                              : null;
                                        },
                                        lastDate: DateTime(3000),
                                      ),
                                      //
                                      DateTimePicker(
                                        type: DateTimePickerType.date,
                                        style: styletext,
                                        firstDate: DateTime(2000),
                                        controller: dateFinController,
                                        dateHintText: "Select de end date",
                                        validator: (val) {
                                          return val!.trim().isEmpty
                                              ? "please select required end date"
                                              : null;
                                        },
                                        lastDate: DateTime(3000),
                                      ),
                                      // DateTimePicker(),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          if (periodKey.currentState!
                                              .validate()) {
                                            final debut = DateTime.parse(
                                                dateDebutDebutController.text);
                                            final fin = DateTime.parse(
                                                dateFinController.text);
                                            if (debut.compareTo(fin) <= 0) {
                                              setState(() {
                                                depenses =
                                                    Depenses.depensesPeriode(
                                                        debut, fin);
                                                time =
                                                    "${DateFormat("d MM y").format(debut)} - ${DateFormat("d MM y").format(fin)} ";
                                              });
                                              setState(() {
                                                dateDebutDebutController
                                                    .clear();
                                                dateFinController.clear();
                                                periodKey.currentState!.reset();
                                              });
                                              depense(depenses!);
                                              setState(() {});
                                              Navigator.of(context).pop();
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Please verifie the dates");
                                            }
                                          }
                                        },
                                        child: texter("Validate"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            dateDebutDebutController.clear();
                                            dateFinController.clear();
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: texter("Cancel"),
                                      )
                                    ]),
                              ],
                            );
                          });
                    },
                    child: texter("Personal selection"))
              ]),
            ],
          );
        });
  }
  // Future<List<Depense>> liste = Depense.depensesProposales();

  TextEditingController controllerDebut = TextEditingController();
  TextEditingController controllerFin = TextEditingController();
  Stream<List<Depenses>>? depenses;

  @override
  void initState() {
    super.initState();
    depenses = Depenses.depensesFiretoresOther();
    depense(depenses!);
    setState(() {});
  }

  int total = 0;
  String time = "All";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            selectDate();
                          },
                          child: texter('Periode')),
                      texter(time),
                    ],
                  ),
                ),
                StreamBuilder<List<Depenses>>(
                    stream: depenses,
                    builder: (context, AsyncSnapshot<List<Depenses>> snapshot) {
                      final data = snapshot.data;
                      return snapshot.hasError
                          ? Center(
                              child: Text(
                              snapshot.error.toString(),
                              style: styletitle.copyWith(
                                color: Colors.red,
                              ),
                            ))
                          : snapshot.hasData
                              ? snapshot.data!.isNotEmpty
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            title: Text(
                                              data![index].motif,
                                              style: styletitle,
                                            ),
                                            subtitle: Text(
                                                DateFormat("E d MMM yyyy H:m")
                                                    .format(data[index].date),
                                                style: styletext),
                                            trailing: Text(
                                              '${data[index].montant} F',
                                              style: styletitle,
                                            ),
                                            style: ListTileStyle.list,
                                            shape: const RoundedRectangleBorder(
                                              side: BorderSide(),
                                            ),
                                          ),
                                        );
                                      })
                                  : Center(
                                      child: Text(
                                        'No Datas !',
                                        style: styletitle.copyWith(
                                            color: Colors.blue),
                                      ),
                                    )
                              : Center(
                                  child: spinkit(context),
                                );
                    }),
              ],
            ),
          ),
        ),
        floatingActionButton: SpeedDial(
          buttonSize: const Size(60.0, 60.0),
          childrenButtonSize: const Size(60.0, 60.0),
          animatedIcon: AnimatedIcons.event_add,
          overlayColor: Colors.black,
          overlayOpacity: 0.4,
          label: Text(
            'Action',
            style: styletext,
          ),
          backgroundColor: Colors.blueGrey.shade500,
          children: [
            SpeedDialChild(
                label: 'Print',
                child: const Icon(
                  Icons.picture_as_pdf,
                  size: 30,
                ),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                labelStyle: styletext,
                onTap: () {
                  for (var val in depensesList!) {
                    print(val.toMap());
                  }
                  Navigator.of(context).push(PageTransition(
                      child:
                          PdfView(list: depensesList!, date: "Report to $time"),
                      type: PageTransitionType.fade));
                }),
            SpeedDialChild(
              label: 'Add Depenses',
              child: const Icon(
                Icons.add,
                size: 30,
              ),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.orange,
              labelStyle: styletext,
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const DepenseAdd(),
                        type: PageTransitionType.bottomToTop));
              },
            ),
          ],
        ));
  }
}

//  Column(
//         children: [
//           SizedBox(
//             height: 50,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     showDialog(
//                         context: context,
//                         builder: (context) {
//                           return AlertDialog(
//                             title: Text('Select Période', style: styletitle),
//                             content: Form(
//                               key: _keyForm,
//                               child: Column(
//                                 children: [
//                                   DateTimePicker(
//                                     controller: controllerDebut,
//                                     validator: (val) {
//                                       return val!.trim().isEmpty
//                                           ? "please suplie date sart"
//                                           : null;
//                                     },
//                                     dateMask: 'd MMM, yyyy',
//                                     dateHintText: 'Selecter Start periode',
//                                     type: DateTimePickerType.date,
//                                     icon: texter("Start"),
//                                     lastDate: DateTime(2100),
//                                     firstDate: DateTime(2018),
//                                     dateLabelText: 'Date',
//                                     timeLabelText: "Hour",
//                                     style: styletext,
//                                   ),
//                                   DateTimePicker(
//                                     controller: controllerFin,
//                                     validator: (val) {
//                                       return val!.trim().isEmpty
//                                           ? "please suplie date End"
//                                           : null;
//                                     },
//                                     dateMask: 'd MMM, yyyy',
//                                     dateHintText: 'Selecter Start periode',
//                                     icon: texter("Start"),
//                                     type: DateTimePickerType.date,
//                                     lastDate: DateTime(2100),
//                                     firstDate: DateTime(2018),
//                                     dateLabelText: 'Date',
//                                     timeLabelText: "Hour",
//                                     style: styletext,
//                                   )
//                                 ],
//                               ),
//                             ),
//                             actions: [
//                               TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                     controllerDebut.clear;
//                                     controllerFin.clear;
//                                     _keyForm.currentState!.reset;
//                                     setState(() {});
//                                   },
//                                   child: texter("Cancel")),
//                               TextButton(
//                                 onPressed: () {
//                                   if (_keyForm.currentState!.validate()) {
//                                     final debut = DateFormat("yyyy-MM-dd")
//                                         .format(DateTime.parse(
//                                             controllerDebut.text));
//                                     final fin = DateFormat('yyyy-MM-dd').format(
//                                         DateTime.parse(controllerFin.text));
//                                     if (DateTime.parse(controllerDebut.text)
//                                             .compareTo(DateTime.parse(
//                                                 controllerFin.text)) <=
//                                         0) {
//                                       setState(() {
//                                         liste = Depense.depensesPeriodique(
//                                             debut, fin);
//                                         controllerDebut.clear;
//                                         controllerFin.clear;
//                                         _keyForm.currentState!.reset;
//                                       });
//                                       Navigator.of(context).pop();
//                                       setState(() {});
//                                     } else {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(
//                                         SnackBar(
//                                           content:
//                                               texter('correct suplie dates'),
//                                         ),
//                                       );
//                                     }
//                                   }
//                                 },
//                                 child: texter("Valide"),
//                               )
//                             ],
//                           );
//                         });
//                   },
//                   child: texter("Select périod"),
//                 ),
//                 TextButton(
//                   child: texter("Total : $total"),
//                   onPressed: () {
//                     setState(() {});
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<Depense>>(
//                 future: liste,
//                 builder: (context, snapshot) {
//                   total = 0;
//                   if (snapshot.hasData) {
//                     for (var dep in snapshot.data!) {
//                       total += dep.montantDepense;
//                     }
//                     return ListView.builder(
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: RefreshIndicator(
//                             onRefresh: () async {
//                               await Depense.depensesProposales();
//                               setState(() {});
//                             },
//                             child: ListTile(
//                               onTap: () {},
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15),
//                                   side: const BorderSide(color: Colors.blue)),
//                               style: ListTileStyle.drawer,
//                               leading: CircleAvatar(
//                                 child: Text(snapshot.data![index].motifDepense
//                                     .trim()[0]),
//                               ),
//                               subtitle:
//                                   texter(snapshot.data![index].dateDepense),
//                               title: Text(snapshot.data![index].motifDepense,
//                                   style: styletitle),
//                               trailing: Text(
//                                 snapshot.data![index].montantDepense
//                                     .toString()
//                                     .trim(),
//                                 style: styletitle,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                       itemCount: snapshot.data!.length,
//                     );
//                   } else if (snapshot.hasError) {
//                     return Center(
//                       child: Text(
//                         'Connection Error',
//                         style: styletitle.copyWith(color: Colors.red),
//                       ),
//                     );
//                   } else {
//                     return Center(child: spinkit(context));
//                   }
//                 }),
//           ),
//         ],
//       ),
