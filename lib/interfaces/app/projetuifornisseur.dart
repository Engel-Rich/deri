import 'package:deri/interfaces/View/detailprojet.dart';
import 'package:deri/interfaces/adds/addprojet.dart';
import 'package:deri/models/projet.dart';
import 'package:deri/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProjetUiFournisseur extends StatefulWidget {
  const ProjetUiFournisseur({Key? key}) : super(key: key);

  @override
  State<ProjetUiFournisseur> createState() => _ProjetUiFournisseurState();
}

class _ProjetUiFournisseurState extends State<ProjetUiFournisseur>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: taille(context).width < 640
              ? taille(context).width * 0.020
              : taille(context).width * 0.075,
          vertical: 25,
        ),
        child: StreamBuilder<List<Projet>>(
            stream: Projet.projetsfournisseur,
            builder: (context, snapshot) {
              final listProjet = snapshot.data;
              return (snapshot.hasData && snapshot.data!.isEmpty)
                  ? Center(
                      child: Text("Aucun Projet enrégistré ", style: styletext))
                  : (snapshot.hasData && snapshot.data!.isNotEmpty)
                      ? ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return expension(listProjet![index], context);
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
      // floatingActionButton: FloatingActionButton.extended(
      //   label: Text(
      //     "Add Project",
      //     style: styletext.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
      //   ),
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       PageTransition(
      //         child: const ProjetAdd(
      //           idProjetPere: '',
      //         ),
      //         type: PageTransitionType.bottomToTop,
      //       ),
      //     );
      //   },
      //   icon: const Icon(Icons.business_center),
      // ),
    );
  }
}

Widget expension(Projet projet, BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(
      vertical: 15,
      horizontal: 30,
    ),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: DetailProjet(project: projet),
            type: PageTransitionType.bottomToTop,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.zero,
        child: ListTile(
          contentPadding: const EdgeInsets.all(2),
          subtitle: LinearPercentIndicator(
            progressColor: Colors.green.shade800,
            animateFromLastPercent: true,
            backgroundColor: Colors.amberAccent.shade100,
            percent: projet.pourcentage / 100,
            center: Text(
              "${projet.pourcentage} %",
              style:
                  styletext.copyWith(fontSize: 5, fontWeight: FontWeight.bold),
            ),
            lineHeight: 7.0,
          ),
          title: Text(projet.titreProjet,
              overflow: TextOverflow.ellipsis, style: styletitle),
          leading: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blueGrey[50]),
            height: 100,
            width: 55,
            child: (projet.images == null || projet.images!.trim().isEmpty)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      "assets/logo.png",
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: projet.images!.isEmpty
                        ? SpinKitSpinningLines(
                            // controller: _controller,
                            color: Colors.blueGrey.shade300)
                        : Image.network(
                            projet.images!,
                            loadingBuilder: (context, child, loadingProgress) {
                              return loadingProgress != null
                                  ? Center(
                                      child: SpinKitSpinningLines(
                                          // controller: _controller,
                                          color: Colors.blueGrey.shade300),
                                    )
                                  : child;
                            },
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                  ),
          ),
        ),
      ),

      // Column(
      //   children: [

      //     Padding(
      //       padding: const EdgeInsets.symmetric(vertical: 15.0),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: [
      //           Flexible(
      //               flex: 5,
      //               child: Text(projet.titreProjet,
      //                   maxLines: 3,
      //                   textAlign: TextAlign.justify,
      //                   overflow: TextOverflow.ellipsis,
      //                   style: styletitle.copyWith(
      //                       letterSpacing: 1.5,
      //                       fontWeight: FontWeight.w700,
      //                       fontSize: 16))),
      //           const Flexible(
      //             flex: 1,
      //             child: Icon(Icons.arrow_forward_ios, size: 35),
      //           )
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
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
