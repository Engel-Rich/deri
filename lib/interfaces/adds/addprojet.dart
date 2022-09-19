// ignore_for_file: avoid_print

import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:deri/Firebases/firebaseusers.dart';
import 'package:deri/interfaces/app/application.dart';
import 'package:deri/models/projet.dart';
import 'package:deri/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class ProjetAdd extends StatefulWidget {
  final String idProjetPere;
  const ProjetAdd({Key? key, required this.idProjetPere}) : super(key: key);

  @override
  State<ProjetAdd> createState() => _ProjetAddState();
}

class _ProjetAddState extends State<ProjetAdd> {
  final _fromkey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController estimationController = TextEditingController();
  TextEditingController descritionController = TextEditingController();
  TextEditingController dateDebutController = TextEditingController();
  TextEditingController dateFinController = TextEditingController();
  String? fournisseur;
  bool loading = false;
  double paddingTop = 15;
  int idProjet = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
        title: Text(
          'Ajouter un projet',
          style: styletext,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: taille(context).width * 0.05,
          ),
          child: Form(
            key: _fromkey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      "Enter les information Dunouveau Projet",
                      style: styletext.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),

                  // le titre ou le nom du projet

                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: TextFormField(
                      maxLines: 2,
                      minLines: 1,
                      controller: titleController,
                      validator: (value) {
                        return value!.trim().isEmpty ? "title is empty" : null;
                      },
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "title or name of project",
                        hintStyle: styletext,
                        icon: const CircleAvatar(
                          child: Icon(
                            Icons.title,
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

                  // second textField la description du projet,

                  Padding(
                    padding: EdgeInsets.only(top: paddingTop),
                    child: TextFormField(
                      maxLines: 4,
                      minLines: 1,
                      controller: descritionController,
                      validator: (value) {
                        return value!.trim().isEmpty
                            ? "description is empty"
                            : null;
                      },
                      decoration: InputDecoration(
                        hintText: "descripton of project",
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

                  // textForField for auther estimation financière du projet,

                  Padding(
                    padding: EdgeInsets.only(top: paddingTop),
                    child: TextFormField(
                      controller: estimationController,
                      validator: (value) {
                        return value!.trim().isEmpty
                            ? "entrer une estimation du projet"
                            : null;
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        hintText: "estimation financière",
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

                  // date du commencement du projet

                  Padding(
                    padding: EdgeInsets.only(top: paddingTop),
                    child: DateTimePicker(
                      controller: dateDebutController,
                      validator: (value) {
                        return value!.trim().isEmpty
                            ? "entrer la dete de début du projet"
                            : null;
                      },
                      type: DateTimePickerType.date,
                      icon: const CircleAvatar(
                        child: Icon(
                          Icons.watch_later_sharp,
                        ),
                      ),
                      dateLabelText: 'Date de debut',
                      timeLabelText: "Hour",
                      style: styletext,
                      timeHintText: DateFormat.Hms().format(DateTime.now()),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      onChanged: (val) {
                        print(val);
                      },
                    ),
                  ),

                  // auther date de fin du projet

                  Padding(
                    padding: EdgeInsets.only(top: paddingTop),
                    child: DateTimePicker(
                      controller: dateFinController,
                      validator: (value) {
                        return value!.trim().isEmpty
                            ? "la date de fin ne peut ètre vide"
                            : null;
                      },
                      type: DateTimePickerType.date,
                      icon: const CircleAvatar(
                        child: Icon(
                          Icons.watch_later_sharp,
                        ),
                      ),
                      dateLabelText: 'Date de fin',
                      style: styletext,
                      timeHintText: DateFormat.Hms().format(DateTime.now()),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      onChanged: (val) {
                        print(val);
                      },
                    ),
                  ),

                  // selection du fournisseur
                  spacerheight(10),
                  Text(
                    "Suplier : $fournisseur",
                    style: styletext.copyWith(
                        fontSize: 16,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w800),
                  ),
                  StreamBuilder<List<UserApp>>(
                      stream: UserApp.fournisseurList(),
                      builder: (context, snapshot) {
                        return TextButton.icon(
                          onPressed: () {
                            (snapshot.hasData)
                                ? showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        title: Text(
                                          "Select suplier",
                                          style: styletext.copyWith(
                                            fontSize: 16,
                                            letterSpacing: 3,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        children: snapshot.data!
                                            .map(
                                              (e) => e.fournisseur == true
                                                  ? Wrap(
                                                      children: [
                                                        TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                fournisseur =
                                                                    e.name;
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                texter(e.name)),
                                                      ],
                                                    )
                                                  : Container(),
                                            )
                                            .toList(),
                                      );
                                    })
                                : Fluttertoast.showToast(
                                    msg: "No supliers avaibles");
                          },
                          icon: const Icon(Icons.support_outlined, size: 30),
                          label: Text(
                            "Selecd the suplier",
                            style: styletext.copyWith(
                                fontSize: 16, letterSpacing: 3),
                          ),
                        );
                      }),
                  // StreamBuilder<List<UserApp>>(
                  //     stream: UserApp.fournisseurList(),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasError) {
                  //         return Text(
                  //           'Error when get Fournissers',
                  //           style: styletext.copyWith(color: Colors.deepOrange),
                  //         );
                  //       } else if (snapshot.hasData &&
                  //           (snapshot.data != null &&
                  //               snapshot.data!.isNotEmpty)) {
                  //         return Padding(
                  //           padding: EdgeInsets.only(top: paddingTop),
                  //           child: DropdownButton<String>(
                  //               borderRadius: BorderRadius.circular(15),
                  //               hint: texter("select incom provider"),
                  //               isExpanded: true,
                  //               value: fournisseur,
                  //               // icon: const CircleAvatar(
                  //               //     child: Icon(Icons.business_outlined)),
                  //               items: snapshot.data!
                  //                   .map((UserApp userApp) =>
                  //                       DropdownMenuItem<String>(
                  //                         value: userApp.name,
                  //                         child: texter(userApp.name),
                  //                       ))
                  //                   .toList(),
                  //               onChanged: (val) {
                  //                 setState(() {
                  //                   fournisseur = val!;
                  //                 });
                  //               }),
                  //         );
                  //       } else if (snapshot.hasData &&
                  //           snapshot.data != null &&
                  //           snapshot.data!.isEmpty) {
                  //         return Text("Aucun founissuer disponible",
                  //             style:
                  //                 styletext.copyWith(color: Colors.deepOrange));
                  //       } else {
                  //         return const LinearProgressIndicator();
                  //       }
                  //     }),

                  // bouton de validation du projet,
                  (image != null && image!.path.isNotEmpty)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(image!,
                                  fit: BoxFit.cover, width: double.infinity)),
                        )
                      : const SizedBox.shrink(),
                  TextButton.icon(
                      onPressed: sendImage,
                      icon: const Icon(Icons.image),
                      label: Text("select Image for the project",
                          style: styletext)),

                  Padding(
                    padding: EdgeInsets.only(top: paddingTop * 3),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: taille(context).width * 0.05),
                      width: double.infinity,
                      height: 57,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            idProjet = DateTime.now().microsecondsSinceEpoch;
                          });
                          print(idProjet);
                          if (_fromkey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            var debut =
                                DateTime.parse(dateDebutController.text);
                            var fin = DateTime.parse(dateFinController.text);

                            debugPrint(
                                "Comparaison des dates : ${debut.compareTo(fin)}");
                            if (debut.compareTo(fin) < 0) {
                              final projet = Projet(
                                fornisseurFont: fournisseur!,
                                idProjet: DateTime.now()
                                    .microsecondsSinceEpoch
                                    .toString(),
                                titreProjet: titleController.text,
                                descriptionProjet: descritionController.text,
                                dateDebut:
                                    DateTime.parse(dateDebutController.text),
                                dateFin: DateTime.parse(dateFinController.text),
                                estimationBudget:
                                    int.parse(estimationController.text),
                                statuProjet: status[0],
                              );
                              projet.voir();
                              try {
                                await projet.save(image).then((value) {
                                  setState(() {
                                    loading = false;
                                    _fromkey.currentState!.reset();
                                  });
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      child: const Application(page: 0),
                                      type: PageTransitionType.bottomToTop,
                                    ),
                                  );
                                  debugPrint("Sauvegarde réussite ");
                                });
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: texter("'Projet Sauvegardé'"),
                                  ),
                                );
                              } catch (e) {
                                debugPrint(
                                    "Erreur d'enrégistrement la date de debut doit ètre plus en avant  $e");
                                setState(() {
                                  loading = false;
                                });
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(
                                //     content: texter(
                                //         "Vérifier votre connexion internet"),
                                //   ),
                                // );
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg:
                                    "date of begin is before or egual to date of end project please rectifie",
                                timeInSecForIosWeb: 2,
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red.withOpacity(0.7),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: texter("'Erreur de Sauvegarde'"),
                                ),
                              );
                              setState(() {
                                loading = false;
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Ajouter",
                              style: styletext.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            loading
                                ? const SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : const SizedBox(
                                    height: 0.0,
                                    width: 0.0,
                                  ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool imagview = false;
  File? image;
  sendImage() {
    ImagePicker picker = ImagePicker();

    // String imegeUrl = "";
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Selectionnez un Image",
              style:
                  styletext.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            content: (!imagview)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await picker
                              .pickImage(source: ImageSource.camera)
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                image = File(value.path);
                                imagview = true;
                              });
                              Navigator.of(context).pop();
                              sendImage();
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.camera,
                          size: 30,
                          color: Color.fromRGBO(40, 173, 193, 1),
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      IconButton(
                        onPressed: () async {
                          await picker
                              .pickImage(source: ImageSource.gallery)
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                image = File(value.path);
                                imagview = true;
                              });
                              Navigator.of(context).pop();
                              sendImage();
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.photo,
                          size: 30,
                          color: Color.fromRGBO(40, 173, 193, 1),
                        ),
                      )
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(image!)),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      image = null;
                      imagview = false;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("Annuler",
                      style: styletext.copyWith(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              (!imagview)
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: () {
                        setState(() {
                          imagview = false;
                        });
                        Navigator.of(context).pop();
                        sendImage();
                      },
                      child: Text("Changer",
                          style: styletext.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600))),
              (imagview)
                  ? TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Valider",
                          style: styletext.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600)))
                  : Container()
            ],
          );
        });
  }
}
