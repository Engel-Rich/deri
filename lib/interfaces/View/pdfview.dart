import 'package:deri/Firebases/firebasedepenses.dart';
import 'package:deri/models/pdfmodel.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PdfView extends StatefulWidget {
  final List<Depenses> list;
  final String date;

  const PdfView({Key? key, required this.list, required this.date})
      : super(key: key);

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PdfPreview(build: (context) {
        return PdfModel(depenses: widget.list, dateDepenses: widget.date)
            .buildPdf();
      }),
    );
  }
}
