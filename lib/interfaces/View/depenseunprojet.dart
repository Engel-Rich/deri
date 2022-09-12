import 'package:deri/Firebases/firebasedepenses.dart';
import 'package:deri/interfaces/View/pdfview.dart';
import 'package:deri/models/projet.dart';
import 'package:deri/variables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class DepensesUnProjet extends StatefulWidget {
  final Projet projet;
  const DepensesUnProjet({Key? key, required this.projet}) : super(key: key);

  @override
  State<DepensesUnProjet> createState() => _DepensesUnProjetState();
}

class _DepensesUnProjetState extends State<DepensesUnProjet> {
  List<Depenses>? depensesList;
  depense(Stream<List<Depenses>> depense) async {
    depensesList = [];
    var list = <Depenses>[];
    await for (var value in depense) {
      list = value;
      for (var val in value) {
        setState(() {
          depensesList!.add(val);
        });
        print(val.toMap());
      }
    }
  }

  @override
  void initState() {
    depense(Depenses.depensesFiretoresProjet(widget.projet.idProjet)!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
              child: Text(widget.projet.titreProjet, style: styletitle),
            ),
            StreamBuilder<List<Depenses>>(
                stream:
                    Depenses.depensesFiretoresProjet(widget.projet.idProjet),
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
                                  physics: const NeverScrollableScrollPhysics(),
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
                                    style:
                                        styletitle.copyWith(color: Colors.blue),
                                  ),
                                )
                          : Center(
                              child: spinkit(context),
                            );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // for (var val in depensesList!) {
          //   print(val.toMap());
          // }
          print(widget.projet.titreProjet);
          Navigator.of(context).push(
            PageTransition(
                child: PdfView(
                  list: depensesList!,
                  date:
                      'Repport depenses for the project: ${widget.projet.titreProjet}',
                ),
                type: PageTransitionType.fade),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.picture_as_pdf),
      ),
    );
  }
}
