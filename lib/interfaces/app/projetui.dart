import 'package:deri/interfaces/View/detailprojet.dart';
import 'package:deri/interfaces/adds/addprojet.dart';
import 'package:deri/models/projet.dart';
import 'package:deri/variables.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
// import 'package:readmore/readmore.dart';

class ProjetUi extends StatefulWidget {
  const ProjetUi({Key? key}) : super(key: key);

  @override
  State<ProjetUi> createState() => _ProjetUiState();
}

class _ProjetUiState extends State<ProjetUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: taille(context).width < 640
              ? taille(context).width * 0.040
              : taille(context).width * 0.075,
          vertical: 25,
        ),
        child: StreamBuilder<List<Projet>>(
            stream: Projet.projets,
            builder: (context, snapshot) {
              final listProjet = snapshot.data;
              // debugPrint(listProjet.toString());

              return (snapshot.hasData && snapshot.data!.isEmpty)
                  ? Center(
                      child: Text("Aucun Projet enrégistré ", style: styletext))
                  : (snapshot.hasData && snapshot.data!.isNotEmpty)
                      ? ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return expension(listProjet![index], context);
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(
                              height: 2.0,
                              thickness: 1.0,
                            );
                          },
                          itemCount: snapshot.data!.length,
                        )
                      : snapshot.hasError
                          ? Center(
                              child: Text(snapshot.error.toString()),
                            )
                          : Center(
                              child: spinkit(context),
                            );
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          "Add Project",
          style: styletext.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              child: const ProjetAdd(
                idProjetPere: '',
              ),
              type: PageTransitionType.bottomToTop,
              duration: const Duration(
                milliseconds: 400,
              ),
              reverseDuration: const Duration(
                milliseconds: 400,
              ),
            ),
          );
        },
        icon: const Icon(Icons.business_center),
      ),
    );
  }
}

Widget expension(Projet projet, BuildContext context) {
  return Container(
    padding: taille(context).width < 640
        ? const EdgeInsets.all(15)
        : const EdgeInsets.all(50),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: DetailProjet(project: projet),
            type: PageTransitionType.bottomToTop,
            duration: const Duration(milliseconds: 350),
          ),
        );
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: (projet.images == null || projet.images!.isEmpty)
                ? Image.asset(
                    "assets/logo.png",
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    projet.images!,
                    loadingBuilder: (context, child, loadingProgress) {
                      return loadingProgress != null
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : child;
                    },
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    flex: 5,
                    child: Text(projet.titreProjet,
                        maxLines: 3,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        style: styletitle.copyWith(
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700,
                            fontSize: 16))),
                const Flexible(
                  flex: 1,
                  child: Icon(Icons.arrow_forward_ios, size: 35),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
  // return ExpansionTile(
  //   title: Text(
  //     projet.titreProjet,
  //     maxLines: 2,
  //     overflow: TextOverflow.ellipsis,
  //     style: styletext.copyWith(
  //       fontWeight: FontWeight.bold,
  //     ),
  //   ),
  //   textColor: Colors.blueGrey.shade300,
  //   leading: CircleAvatar(
  //     backgroundColor: Colors.blueGrey.shade300,
  //     child: Image.asset(
  //       "assets/projetrun.png",
  //       fit: BoxFit.contain,
  //     ),
  //   ),
  //   children: [
  //     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //       ElevatedButton.icon(
  //         onPressed: () {
  //           Navigator.push(
  //             context,
  //             PageTransition(
  //               child: DetailProjet(project: projet),
  //               type: PageTransitionType.bottomToTop,
  //               duration: const Duration(milliseconds: 350),
  //             ),
  //           );
  //         },
  //         style: ElevatedButton.styleFrom(
  //           padding: taille(context).width < 640
  //               ? const EdgeInsets.all(15)
  //               : const EdgeInsets.all(20),
  //           shape: RoundedRectangleBorder(
  //             borderRadius: taille(context).width < 640
  //                 ? BorderRadius.circular(25)
  //                 : BorderRadius.circular(20),
  //           ),
  //         ),
  //         icon: const Icon(Icons.arrow_forward_ios),
  //         label: Text(
  //           'show More',
  //           style: styletext,
  //         ),
  //       ),
  //     ]),
  //     Container(
  //       margin: EdgeInsets.symmetric(
  //         horizontal: taille(context).width * 0.03,
  //         vertical: 10,
  //       ),
  //       padding: const EdgeInsets.all(8),
  //       child: ReadMoreText(
  //         projet.descriptionProjet,
  //         trimCollapsedText: 'read more',
  //         trimExpandedText: "show less",
  //         trimLines: 10,
  //         trimMode: TrimMode.Line,
  //         colorClickableText: Colors.blue,
  //         style: styletext,
  //       ),
  //     )
  //   ],
  // );
}
