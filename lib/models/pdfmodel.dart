import 'dart:typed_data';

import 'package:deri/Firebases/firebasedepenses.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfModel {
  List<Depenses>? depenses;
  String? dateDepenses;
  PdfModel({this.dateDepenses, this.depenses});
  Future<Uint8List> buildPdf() async {
    final Document pdf = Document();
    final image = MemoryImage(
        (await rootBundle.load("assets/logo.png")).buffer.asUint8List());
    final data = depenses!
        .map((dep) =>
            [dep.motif, dep.montant, DateFormat("dd MM y").format(dep.date)])
        .toList();
    pdf.addPage(
      MultiPage(
        build: (context) => [
          Image(
            image,
            height: 150,
            width: 100,
          ),
          Center(child: Wrap(children: [Text("$dateDepenses")])),
          SizedBox(height: 30.0),
          Table.fromTextArray(
            headers: ["Motif", "Montant", "Date"],
            data: data,
            headerAlignment: Alignment.center,
            headerCellDecoration: const BoxDecoration(color: PdfColors.grey300),
          )
        ],
      ),
    );
    return pdf.save();
  }
}
