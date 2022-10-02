// ignore_for_file: avoid_print

import 'package:deri/Firebases/firebasedepenses.dart';
// import 'package:deri/interfaces/depenses/depenseprojetUi.dart';
// import 'package:deri/models/depense.dart';
// import 'package:deri/models/depenseprojet.dart';
import 'package:deri/models/projet.dart';
import 'package:deri/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';

class DepenseAdd extends StatefulWidget {
  const DepenseAdd({Key? key}) : super(key: key);

  @override
  State<DepenseAdd> createState() => _DepenseAddState();
}

TextEditingController montantController = TextEditingController();
TextEditingController motifController = TextEditingController();
final depensekey = GlobalKey<FormState>();

class _DepenseAddState extends State<DepenseAdd> {
  @override
  int currentstepe = 0;

  List<Map<String, dynamic>> typeDep = [
    {"name": 'Project', "select": false},
    {"name": 'Opressional', "select": false},
    {"name": "Other", "select": false},
  ];

  tapped(int step) => setState(() => currentstepe = step);
  continues() => currentstepe < 2 ? setState(() => currentstepe += 1) : null;
  cancel() => currentstepe > 0 ? setState(() => currentstepe -= 1) : null;
  String ordervalue = '';
  String typeValue = "";
  int idprojet = 0;

  Projet selectedProjet = Projet(
      idProjet: '0',
      titreProjet: "",
      descriptionProjet: "",
      dateDebut: DateTime.now(),
      dateFin: DateTime.now(),
      // estimationBudget: 0,
      // statuProjet: "",
      fornisseurFont: "");

  @override
  void initState() {
    // getProjet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stepper(
                onStepCancel: cancel,
                onStepContinue: continues,
                onStepTapped: (step) => tapped(step),
                currentStep: currentstepe,
                physics: const ScrollPhysics(),
                steps: [
                  Step(
                      title: texter('Select action Order'),
                      content: Column(
                        children: orderFinances.map((order) {
                          return RadioListTile<String>(
                              value: order,
                              groupValue: ordervalue,
                              title: texter(order),
                              onChanged: (val) {
                                setState(() {
                                  ordervalue = val!;
                                });
                              });
                        }).toList(),
                      ),
                      isActive: currentstepe >= 0,
                      state: (currentstepe != 0 && ordervalue == '')
                          ? StepState.error
                          : currentstepe == 0
                              ? StepState.editing
                              : StepState.complete),
                  Step(
                      title: texter('Select Depense Type'),
                      content: Column(
                        children: [
                          Wrap(
                            children: typeDep.map((type) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: ChoiceChip(
                                  label: texter(type['name']),
                                  selected: type["select"],
                                  selectedColor: Colors.blueAccent,
                                  tooltip: 'depenses for $type',
                                  onSelected: (val) {
                                    setState(() {
                                      typeDep = typeDep.map((choice) {
                                        return choice == type
                                            ? {
                                                'name': choice['name'],
                                                'select': val
                                              }
                                            : {
                                                'name': choice['name'],
                                                'select': false
                                              };
                                      }).toList();
                                      print(typeDep);
                                      typeValue = type['name'];
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                      isActive: currentstepe >= 0,
                      state: (currentstepe != 1 && typeValue == "")
                          ? StepState.error
                          : currentstepe == 1
                              ? StepState.editing
                              : StepState.complete),
                  Step(
                    title: texter('Enter authers required informations'),
                    content: Form(
                      key: depensekey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Wrap(
                              alignment: WrapAlignment.spaceAround,
                              children: [
                                typeValue == "Project"
                                    ? SizedBox(
                                        height: 50,
                                        width: 170,
                                        child: StreamBuilder<List<Projet>>(
                                            stream: Projet.projets,
                                            builder: (context, snapshot) {
                                              return ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (cntx) {
                                                        return (snapshot
                                                                    .hasData &&
                                                                snapshot.data!
                                                                    .isNotEmpty)
                                                            ? AlertDialog(
                                                                title: Text(
                                                                    "Select Project",
                                                                    style:
                                                                        styletitle),
                                                                actions: snapshot
                                                                    .data!
                                                                    .map(
                                                                        (projet) {
                                                                  return ListTile(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        selectedProjet =
                                                                            projet;
                                                                        Navigator.of(cntx)
                                                                            .pop();
                                                                      });
                                                                    },
                                                                    leading:
                                                                        Icon(
                                                                      Icons
                                                                          .arrow_forward_ios,
                                                                      size: 30,
                                                                      color: projet.idProjet ==
                                                                              selectedProjet
                                                                                  .idProjet
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .blue
                                                                              .shade900,
                                                                    ),
                                                                    title: Text(
                                                                        projet
                                                                            .titreProjet,
                                                                        style:
                                                                            styletitle),
                                                                    subtitle: Text(
                                                                        projet
                                                                            .descriptionProjet,
                                                                        style:
                                                                            styletext,
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis),
                                                                  );
                                                                }).toList(),
                                                                content:
                                                                    const SizedBox(
                                                                  height: 50,
                                                                  child: Center(
                                                                      child:
                                                                          Divider()),
                                                                ),
                                                              )
                                                            : snapshot.hasError
                                                                ? AlertDialog(
                                                                    content: Text(
                                                                        snapshot
                                                                            .error
                                                                            .toString()),
                                                                  )
                                                                : const CircularProgressIndicator();
                                                      });
                                                },
                                                child: texter(
                                                  selectedProjet.idProjet == '0'
                                                      ? "Select Project"
                                                      : "Change Project",
                                                ),
                                              );
                                            }),
                                      )
                                    : const SizedBox.shrink(),
                                const SizedBox(
                                  width: 50,
                                ),
                                (selectedProjet.idProjet != '0' &&
                                        typeValue == "Project")
                                    ? ListTile(
                                        leading: const Icon(Icons.check,
                                            size: 30, color: Colors.green),
                                        title: Text(selectedProjet.titreProjet,
                                            style: styletitle),
                                        subtitle: Text(
                                            selectedProjet.descriptionProjet,
                                            style: styletext,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis),
                                      )
                                    : typeValue == "Project"
                                        ? Text(
                                            "No Project Selected",
                                            style: styletitle.copyWith(
                                                color: Colors.redAccent),
                                          )
                                        : const SizedBox.shrink()
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: TextFormField(
                              controller: montantController,
                              validator: (value) {
                                return value!.trim().isEmpty
                                    ? "Amount of transaction is required"
                                    : null;
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                hintText: "Amount of transaction",
                                hintStyle: styletext,
                                icon: const CircleAvatar(
                                  child: Icon(
                                    Icons.monetization_on,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: TextFormField(
                              maxLines: 3,
                              minLines: 1,
                              controller: motifController,
                              validator: (value) {
                                return value!.trim().isEmpty
                                    ? "Motif of transaction is required"
                                    : null;
                              },
                              decoration: InputDecoration(
                                hintText: "Motif of transaction",
                                hintStyle: styletext,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                icon: const CircleAvatar(
                                  child: Icon(
                                    Icons.description,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isActive: currentstepe >= 0,
                    state: currentstepe != 2
                        ? StepState.indexed
                        : StepState.editing,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  height: 50,
                  width: estGrand(context)
                      ? taille(context).width * 0.6
                      : double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (ordervalue.trim().isNotEmpty &&
                          typeValue.trim().isNotEmpty) {
                        if (depensekey.currentState!.validate()) {
                          // final depense = Depense(
                          //   motifDepense: motifController.text,
                          //   dateDepense:
                          //       DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          //   ordreDepense: ordervalue,
                          //   typeDepense: typeValue,
                          //   montantDepense: int.parse(montantController.text),
                          //   idDepense: DateTime.now().millisecondsSinceEpoch,
                          // );
// Depense de firebase
                          final depensefire = Depenses(
                              motif: motifController.text,
                              date: DateTime.now(),
                              ordre: ordervalue,
                              type: typeValue,
                              montant: int.parse(montantController.text),
                              idD: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString());

                          // de firebase

                          if (typeValue == 'Project') {
                            if (selectedProjet.idProjet != '') {
                              // final depPro = DepenseProjet(
                              //     depense: depense, projet: selectedProjet);
                              depensefire.idProjet =
                                  selectedProjet.idProjet.toString();
                              try {
                                // depense.insertDepenses();
                                final depPro = DepensesProjet(
                                    dateTime: DateTime.now(),
                                    idDepense: depensefire.idD,
                                    idProjet: depensefire.idProjet!);
                                depensefire.save();
                                depPro.save();
                              } catch (e) {
                                snack("Erreur D'ajout de la depense");
                                print(e.toString());
                              }
                              // try {
                              //   depPro.isertion();
                              // } catch (e) {
                              //   print(e);
                              // }
                              snack("Depense Saved correctely");
                              setState(() {
                                montantController.clear();
                                motifController.clear();
                                typeValue = "";
                                depensekey.currentState!.reset();
                                ordervalue = "";
                              });
                              Navigator.of(context).pop();
                            } else {
                              snack(
                                  'Plase Select The Project Or change Type of transaction');
                            }
                          } else {
                            try {
                              // depense.insertDepenses();
                              depensefire.save();
                              snack("Depense Saved correctely");
                            } catch (e) {
                              print(e);
                              snack("Erreur d'Ajout");
                            }
                            setState(() {
                              montantController.clear();
                              motifController.clear();
                              typeValue = "";
                              depensekey.currentState!.reset();
                              ordervalue = "";
                            });
                            Navigator.pop(context);
                          }
                        } else {
                          snack(
                              "Please the motif ans amounts ares  required informations ");
                        }
                      } else {
                        snack(
                            "Plase Chek all informations Vérified Order and type of transaction");
                      }
                    },
                    child: Text(
                      'Valide transaction',
                      style: styletitle,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  snack(String texte) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: texter(texte),
      action: SnackBarAction(label: "Cancel", onPressed: () {}),
    ));
  }
}
