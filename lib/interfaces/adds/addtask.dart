import 'package:date_time_picker/date_time_picker.dart';
import 'package:deri/models/projet.dart';
import 'package:deri/models/task.dart';
import 'package:deri/variables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  final Projet projet;
  const AddTask({Key? key, required this.projet}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _controllertitle = TextEditingController();
  final TextEditingController _controllerdate = TextEditingController();
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
                  height: 15.0,
                ),
                DateTimePicker(
                    controller: _controllerdate,
                    validator: (value) {
                      return value!.trim().isEmpty ? "date required" : null;
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
                    lastDate: widget.projet.dateFin),
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
                        final task = Task(
                          idTask: DateTime.now().millisecondsSinceEpoch,
                          idProjetPere: int.parse(widget.projet.idProjet),
                          titleTask: _controllertitle.text,
                          limiteTask: DateTime.parse(_controllerdate.text),
                          statusTask: status[0]!,
                          userId: " ",
                        );
                        try {
                          task.saveTask();
                          setState(() {
                            _formkey.currentState!.reset();
                          });
                          Navigator.pop(context);
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              action: SnackBarAction(
                                  label: 'Cancel', onPressed: () {}),
                              content: Text("Task added succesful",
                                  style: styletext),
                            ),
                          );
                        } catch (e) {
                          debugPrint('Erreur d\'ajout de la tache : $e');
                        }
                      }
                    },
                    label: Text(
                      'Vallide a task for the project',
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
  }
}
