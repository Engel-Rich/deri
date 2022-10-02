import 'package:cached_network_image/cached_network_image.dart';
import 'package:deri/interfaces/View/detailprojet.dart';
import 'package:deri/interfaces/adds/addprojet.dart';
import 'package:deri/models/projet.dart';
import 'package:deri/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProjetUi extends StatefulWidget {
  const ProjetUi({Key? key}) : super(key: key);

  @override
  State<ProjetUi> createState() => _ProjetUiState();
}

class _ProjetUiState extends State<ProjetUi>
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
            stream: Projet.projets,
            builder: (context, snapshot) {
              final listProjet = snapshot.data;

              return (snapshot.hasData && snapshot.data!.isEmpty)
                  ? Center(
                      child: Text("Aucun Projet enrégistré ", style: styletext))
                  : (snapshot.hasData && snapshot.data!.isNotEmpty)
                      ? ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return expensionF(listProjet![index], context);
                          },
                          // separatorBuilder: (context, index) {
                          //   return const Divider(
                          //     height: 2.0,
                          //     thickness: 1.0,
                          //   );
                          // },
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
            ),
          );
        },
        icon: const Icon(Icons.business_center),
      ),
    );
  }
}

Widget expensionF(Projet projet, BuildContext context) {
  return InkWell(
    onTap: () => Navigator.of(context).push(PageTransition(
        child: DetailProjet(project: projet),
        type: PageTransitionType.leftToRight)),
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: 150,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(6, 57, 112, 0.80),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.blue.shade400,
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(1, 1))
          ]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${projet.pourcentage.toStringAsFixed(2)} % ",
                style: styletext.copyWith(
                    fontWeight: FontWeight.w600, color: Colors.white),
              ),
              SizedBox(
                width: 70,
                child: LinearPercentIndicator(
                  percent: projet.pourcentage / 100,
                  progressColor: Colors.green,
                  backgroundColor: Colors.blue.shade50,
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_circle_right,
                    size: 24,
                    color: Colors.white,
                  ))
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  flex: 4,
                  child: Text(
                    projet.titreProjet,
                    style: styletitle.copyWith(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  )),
              Flexible(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blueGrey[50]),
                  height: 55,
                  width: 55,
                  child:
                      (projet.images == null || projet.images!.trim().isEmpty)
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
                                  : CachedNetworkImage(
                                      imageUrl: projet.images!,
                                      placeholder: (context, text) => Center(
                                        child: SpinKitSpinningLines(
                                            // controller: _controller,
                                            color: Colors.red.shade400),
                                      ),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                            ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "détails",
                style: styletext.copyWith(
                    fontWeight: FontWeight.w500, color: Colors.white),
              ),
              const Icon(
                Icons.forward,
                color: Colors.white,
                size: 15,
              )
            ],
          )
        ],
      ),
    ),
  );
}

Widget expension(Projet projet, BuildContext context) {
  return Container(
    padding: taille(context).width < 640
        ? const EdgeInsets.symmetric(vertical: 4, horizontal: 8)
        : const EdgeInsets.all(50),
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
