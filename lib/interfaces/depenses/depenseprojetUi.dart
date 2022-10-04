// ignore_for_file: file_names
import 'package:deri/Firebases/firebasedepenses.dart';
import 'package:deri/interfaces/View/depenseunprojet.dart';
import 'package:deri/interfaces/adds/adddepanse.dart';
// import 'package:deri/services/notification.dart';
import 'package:deri/models/projet.dart';
// import 'package:deri/models/depenseprojet.dart';
// import 'package:deri/models/projet.dart';
import 'package:deri/variables.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class DepensesProjetUI extends StatefulWidget {
  const DepensesProjetUI({Key? key}) : super(key: key);

  @override
  State<DepensesProjetUI> createState() => _DepensesProjetUIState();
}

class _DepensesProjetUIState extends State<DepensesProjetUI> {
  // late List<DepenseProjet> depensesProjetUIList;
  getdepenses() async {
    // depensesProjetUIList = await DepenseProjet.dapensesProjet();
  }

  @override
  void initState() {
    super.initState();
    // NotificationApi.swoNotification(
    //   title: "depenses ui",
    //   body: "Voila le test",
    //   payload: "0",
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
        child: StreamBuilder<List<DepensesProjet>>(
            stream: DepensesProjet.depensesProjets(),
            builder: (context, AsyncSnapshot<List<DepensesProjet>> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                    style: styletitle.copyWith(
                      color: Colors.red,
                    ),
                  ),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      String puid = snapshot.data![index].idProjet;
                      print({"prject Id : $puid"});
                      return StreamBuilder<Projet>(
                        stream: Projet.oneProjet(puid),
                        builder: (context, snaps) {
                          if (snaps.hasError) {
                            return Text(
                              snaps.error.toString(),
                              style: styletext,
                            );
                          } else {
                            return (snaps.hasData)
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          side: BorderSide(
                                            color: Colors.blue.shade700,
                                          )),
                                      onTap: () {
                                        Navigator.of(context).push(
                                            PageTransition(
                                                child: DepensesUnProjet(
                                                    projet: snaps.data!),
                                                type: PageTransitionType.fade));
                                      },
                                      title: Text(
                                        snaps.data!.titreProjet,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      leading: const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 30),
                                    ),
                                  )
                                : const Opacity(
                                    opacity: 0.8,
                                    child: LinearProgressIndicator(),
                                  );
                          }
                        },
                      );
                    });
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No Datas !',
                    style: styletitle.copyWith(color: Colors.blue),
                  ),
                );
              } else {
                return Center(
                  child: spinkit(context),
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  child: const DepenseAdd(),
                  type: PageTransitionType.bottomToTop));
        },
        label: texter('Add Depense'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blueGrey.shade400,
      ),
    );
  }
}















  // body: FutureBuilder<List<DepenseProjet>>(
      //     future: DepenseProjet.dapensesProjet(),
      //     builder: (context, snapshot) {
      //       List<Projet> projetlist = <Projet>[];
      //       if (snapshot.hasData && snapshot.data!.isNotEmpty) {
      //         for (var dep in snapshot.data!) {
      //           if (projetlist.isEmpty) {
      //             projetlist.add(dep.projet);
      //           } else {
      //             for (var i = 0; i < projetlist.length; i++) {
      //               if (dep.projet.idProjet != projetlist[i].idProjet) {
      //                 projetlist.add(dep.projet);
      //               }
      //             }
      //           }
      //         }
      //       }
      //       return snapshot.hasError
      //           ? Center(
      //               child: Text("Database Connection Error",
      //                   style: styletitle.copyWith(color: Colors.red)),
      //             )
      //           : !snapshot.hasData
      //               ?  Center(
      //                   child: spinkit(context)
      //                 )
      //               : snapshot.data!.isEmpty
      //                   ? Center(
      //                       child: Text(
      //                           "Pas de dépenses Pour les projets pour le moment",
      //                           style: styletitle),
      //                     )
      //                   : ListView.builder(
      //                       itemCount: projetlist.length,
      //                       itemBuilder: (context, index) {
      //                         return Padding(
      //                           padding: const EdgeInsets.all(5.0),
      //                           child: ExpansionTile(
      //                             collapsedBackgroundColor:
      //                                 Colors.blueAccent.shade100,
      //                             leading: InkWell(
      //                               onTap: () {},
      //                               child: const CircleAvatar(
      //                                   child: Icon(Icons.picture_as_pdf)
      //                                   // Text(projetlist[index]
      //                                   //     .titreProjet
      //                                   //     .trim()[0]),
      //                                   ),
      //                             ),
      //                             title: Text(
      //                               projetlist[index].titreProjet,
      //                               style: styletitle,
      //                             ),
      //                             children: snapshot.data!.map((depro) {
      //                               return depro.projet == projetlist[index]
      //                                   ? Padding(
      //                                       padding: const EdgeInsets.all(8.0),
      //                                       child: ListTile(
      //                                         onTap: () {},
      //                                         shape: RoundedRectangleBorder(
      //                                             borderRadius:
      //                                                 BorderRadius.circular(15),
      //                                             side: const BorderSide(
      //                                                 color: Colors.blue)),
      //                                         style: ListTileStyle.drawer,
      //                                         leading: CircleAvatar(
      //                                           child: Text(snapshot
      //                                               .data![index]
      //                                               .depense
      //                                               .motifDepense
      //                                               .trim()[0]),
      //                                         ),
      //                                         subtitle: texter(snapshot
      //                                             .data![index]
      //                                             .depense
      //                                             .dateDepense),
      //                                         title: Text(
      //                                             snapshot.data![index].depense
      //                                                 .motifDepense,
      //                                             style: styletitle),
      //                                         trailing: Text(
      //                                           snapshot.data![index].depense
      //                                               .montantDepense
      //                                               .toString()
      //                                               .trim(),
      //                                           style: styletitle,
      //                                         ),
      //                                       ),
      //                                     )
      //                                   : const SizedBox.shrink();
      //                             }).toList(),
      //                           ),
      //                         );
      //                       });
      //     }),