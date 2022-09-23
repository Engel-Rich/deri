import 'package:deri/interfaces/View/detailprojet.dart';
import 'package:deri/interfaces/adds/addprojet.dart';
import 'package:deri/models/projet.dart';
import 'package:deri/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

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
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return maxUiprojet(context, snapshot.data![index]);
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
          "Add",
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

Widget maxUiprojet(BuildContext context, Projet projet) => Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(5),
          height: taille(context).height * 0.7,
          width: 260,
          decoration: BoxDecoration(
            image: (projet.images != null && projet.images!.isNotEmpty)
                ? DecorationImage(
                    image: NetworkImage(projet.images!), fit: BoxFit.cover)
                : const DecorationImage(
                    image: AssetImage('assets/projet.jpg'), fit: BoxFit.cover),
            color: Colors.blue.shade300,
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20), bottom: Radius.circular(10)),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(8),
          height: taille(context).height * 0.7,
          width: 260,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.25, 0.40, 0.60, 0.75, 1],
              colors: [
                Colors.black.withOpacity(.8),
                Colors.black.withOpacity(.6),
                Colors.black.withOpacity(.3),
                Colors.white.withOpacity(.5),
                Colors.white,
              ],
            ),
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20), bottom: Radius.circular(10)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                  radius: 25,
                  child:
                      Icon(Icons.calendar_today, color: Colors.white, size: 30),
                ),
                title: Text(
                  "To ${DateFormat("EE d MMM y").format(projet.dateDebut)} ",
                  style: styletitle.copyWith(
                      color: Colors.white, letterSpacing: 1),
                ),
                subtitle: Text(
                  "At ${DateFormat("EE d MMM y").format(projet.dateFin)}",
                  style: styletext.copyWith(
                      color: Colors.white,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600),
                ),
              ),
              spacerheight(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: CircularPercentIndicator(
                      radius: 24,
                      backgroundColor: Colors.orangeAccent,
                      percent: projet.pourcentage / 100,
                      progressColor: Colors.green,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "Progress : ${projet.pourcentage.toStringAsFixed(2)}  %",
                    style: styletitle.copyWith(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(
                height: 25.0,
              ),
              Text(
                projet.titreProjet,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: styletext.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    wordSpacing: 1.5),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  projet.descriptionProjet,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: styletext.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );

// expension
Widget expension(Projet projet, BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(2),
        focusColor: Colors.green,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.blueGrey)),
        subtitle: LinearPercentIndicator(
          progressColor: Colors.green.shade800,
          animateFromLastPercent: true,
          backgroundColor: Colors.amberAccent.shade100,
          percent: projet.pourcentage / 100,
          center: Text(
            "${projet.pourcentage} %",
            style: styletext.copyWith(fontSize: 5, fontWeight: FontWeight.bold),
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
                    "assets/projet.jpg",
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
                          errorBuilder: (context, error, stackTrace) {
                            return Text(
                              'Error',
                              style:
                                  styletext.copyWith(color: Colors.redAccent),
                            );
                          },
                          fit: BoxFit.cover,
                          width: double.infinity,
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
