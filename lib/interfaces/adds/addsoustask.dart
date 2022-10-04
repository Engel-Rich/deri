// import 'package:date_time_picker/date_time_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:deri/models/task.dart';
import 'package:deri/variables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';
// import 'package:path/path.dart';

class AddSouTask extends StatefulWidget {
  final Task task;
  const AddSouTask({Key? key, required this.task}) : super(key: key);

  @override
  State<AddSouTask> createState() => _AddSouTaskState();
}

class _AddSouTaskState extends State<AddSouTask> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _controllertitle = TextEditingController();
  final TextEditingController _controllerdate = TextEditingController();
  int poid = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Text(
                  'add task for the project',
                  style: styletitle,
                ),
                const SizedBox(
                  height: 30,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(),
                    ),
                  ),
                ),
                spacerheight(40),
                TextFormField(
                  validator: (val) {
                    return val!.trim().isEmpty
                        ? "title of task required "
                        : null;
                  },
                  controller: _controllertitle,
                  minLines: 1,
                  maxLines: 3,
                  style: styletext,
                  decoration: InputDecoration(
                    hintText: 'title of task',
                    hintStyle: styletext,
                    icon: const Icon(Icons.title),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 1.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                // Row(
                //   children: [
                //     Text("Value", style: styletitle),
                //   ],
                // ),
                // spacerheight(10),
                // RadioListTile(
                //     title: texter('Normal like auther subtask'),
                //     selected: true,
                //     value: 1,
                //     groupValue: poid,
                //     onChanged: (int? val) => setState(() {
                //           poid = val!;
                //         })),
                // RadioListTile(
                //     title: texter('Medium'),
                //     selected: true,
                //     value: 2,
                //     groupValue: poid,
                //     onChanged: (int? val) => setState(() {
                //           poid = val!;
                //         })),
                // RadioListTile(
                //     title: texter('Height'),
                //     selected: true,
                //     value: 3,
                //     groupValue: poid,
                //     onChanged: (int? val) => setState(() {
                //           poid = val!;
                //         })),
                DateTimePicker(
                  controller: _controllerdate,
                  validator: (value) {
                    return value!.trim().isEmpty
                        ? (DateTime.parse(value)
                                    .compareTo(widget.task.limiteTask) <
                                0)
                            ? 'The date can be greater than task date '
                            : "date required"
                        : null;
                  },
                  type: DateTimePickerType.date,
                  icon: const Icon(
                    Icons.watch_later_sharp,
                  ),
                  dateLabelText: DateFormat.yMEd().format(DateTime.now()),
                  dateHintText: "Date of limit",
                  timeLabelText: "Hour",
                  style: styletext,
                  timeHintText: DateFormat.Hms().format(DateTime.now()),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        final soustask = SousTask(
                          limite: DateTime.parse(_controllerdate.text),
                          userRespo: authentication.currentUser!.uid,
                          id: DateTime.now().microsecondsSinceEpoch.toString(),
                          idProjet: widget.task.idProjetPere.toString(),
                          importance: poid,
                          taskid: widget.task.idTask.toString(),
                          titre: _controllertitle.text,
                        );
                        try {
                          soustask.save();
                          Navigator.pop(context);
                          setState(() {
                            _controllertitle.clear();
                            _formkey.currentState!.reset();
                          });
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     action: SnackBarAction(
                          //         label: 'Cancel', onPressed: () {}),
                          //     content: Text("Task added succesful",
                          //         style: styletext),
                          //   ),
                          // );
                        } catch (e) {
                          debugPrint('Erreur d\'ajout de la tache : $e');
                        }
                      }
                    },
                    label: Text(
                      'Vallide a sub task',
                      style: styletext,
                    ),
                  ),
                ),
                spacerheight(20),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: Text(
                      'Cancel and go gack',
                      style: styletext,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
