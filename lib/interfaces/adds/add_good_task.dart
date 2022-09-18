import 'package:deri/models/agenda.dart';
import 'package:deri/services/notification.dart';
import 'package:deri/variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddGoodAgenda extends StatefulWidget {
  const AddGoodAgenda({Key? key}) : super(key: key);

  @override
  State<AddGoodAgenda> createState() => _AddGoodAgendaState();
}

class _AddGoodAgendaState extends State<AddGoodAgenda> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController remindController = TextEditingController();
  List<int> rappelList = [1, 3, 2, 7, 10, 14];
  DateTime dateTimeSelect = DateTime.now();
  int rappel = 1;
  bool loading = false;
  String time = DateFormat('H:m').format(DateTime.now());
  getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickerDate != null) {
      setState(() {
        dateTimeSelect = pickerDate;
        dateController.text = DateFormat.yMEd().format(dateTimeSelect);
      });
    }
  }

  getTimeFromUser() async {
    var timeSel = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (timeSel != null) {
      setState(() {
        time = timeSel.format(context);
      });
    }
  }

  getSnack(
    String message, {
    String? title = "Save Error",
    Color color = Colors.deepOrange,
    Widget icon = const Icon(
      Icons.error,
      color: Colors.red,
    ),
  }) =>
      Get.snackbar(
        title!,
        message,
        titleText: Text(title, style: styletitle),
        messageText: Text(message, style: styletext),
        icon: icon,
        snackStyle: SnackStyle.FLOATING,
        duration: const Duration(seconds: 5),
        isDismissible: true,
        backgroundColor: color,
        dismissDirection: DismissDirection.horizontal,
      );
  validate() {
    if (titleController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty) {
      // var seltime = TimeOfDay(
      //     hour: int.parse(time.split(":")[0]),
      //     minute: int.parse(time.split(":")[1]));
      if (dateTimeSelect.isAfter(DateTime.now())) {
        Agenda agenda = Agenda(
            ispass: false,
            rappel: rappel,
            idAgenda: DateTime.now().microsecondsSinceEpoch.toString(),
            title: titleController.text.trim(),
            jour: dateTimeSelect,
            description: descriptionController.text.trim());
        try {
          agenda.createAgendas();
          getSnack(
            titleController.text,
            color: const Color.fromARGB(255, 118, 231, 125).withOpacity(01),
            title: "Save Correctly",
            icon: const Icon(Icons.check_circle_outline_sharp),
          );
          NotificationApi.swoNotification(
              title: 'Ajout de l\'agenda',
              body:
                  "Vous aves Ajouté avec succés l'évènement ${titleController.text}",
              payload: '2');
          setState(() {
            loading = false;
            titleController.clear();
            descriptionController.clear();
            dateController.clear();
            remindController.clear();
          });

          Navigator.pop(context);
        } catch (e) {
          getSnack(e.toString());
        } finally {
          setState(() {
            loading = false;
          });
        }
      } else {
        getSnack('plese verify the date of task');
        setState(() {
          loading = false;
        });
      }
    } else {
      getSnack(" please suplie the title and the description of task");
      setState(() {
        loading = false;
      });
    }
  }

// voilà la foncyion build
  @override
  Widget build(BuildContext context) {
    return loading
        ? spinkit(context)
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: bouttonBack(context, taille: 30),
            ),
            body: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add New Task",
                    style: styletitle.copyWith(
                        letterSpacing: 7, wordSpacing: 5, fontSize: 20),
                  ),
                  spacerheight(30),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: MyTextField(
                      title: "Title",
                      hint: "Enter the Title",
                      controller: titleController,
                    ),
                  ),
                  MyTextField(
                    title: "Description",
                    hint: "Enter the Description",
                    controller: descriptionController,
                    maxLine: 3,
                  ),
                  MyTextField(
                    title: 'Date',
                    hint: DateFormat.yMEd().format(dateTimeSelect),
                    controller: dateController,
                    widget: IconButton(
                      onPressed: () {
                        getDateFromUser();
                      },
                      icon: const Icon(Icons.calendar_today_outlined,
                          color: Colors.grey),
                    ),
                  ),
                  // MyTextField(
                  //   title: 'Time',
                  //   hint: time,
                  //   widget: IconButton(
                  //     onPressed: () {
                  //       getTimeFromUser();
                  //     },
                  //     icon:
                  //         const Icon(Icons.watch_later_outlined, color: Colors.grey),
                  //   ),
                  // ),
                  MyTextField(
                    title: "Remind",
                    controller: remindController,
                    hint: '$rappel days early',
                    widget: DropdownButton<int>(
                        onChanged: (val) {
                          setState(() {
                            rappel = val!;
                            setState(() {
                              remindController.text =
                                  '${val.toString()} days early';
                            });
                          });
                        },
                        value: rappel,
                        elevation: 4,
                        iconSize: 30,
                        icon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.grey),
                        underline: Container(height: 0.0),
                        items:
                            rappelList.map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              '$value',
                              style: styletext,
                            ),
                          );
                        }).toList()),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        boutton(),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          );
  }

  boutton() => Container(
        margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextButton(
            onPressed: () {
              setState(() {
                loading = true;
              });
              validate();
            },
            child: Text(
              'Create Task',
              style: styletext.copyWith(color: Colors.white),
            )),
      );
}

class MyTextField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final int? maxLine;
  const MyTextField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.maxLine = 1,
      this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      height: maxLine == 1 ? 90 : 120,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: styletitle),
        Container(
          margin: const EdgeInsets.only(top: 3),
          padding: const EdgeInsets.only(bottom: 3, left: 10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget != null,
                    controller: controller,
                    maxLines: maxLine,
                    style: styletext,
                    autofocus: false,
                    textAlign: TextAlign.justify,
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    decoration: InputDecoration(
                      hintStyle: styletext,
                      border: InputBorder.none,
                      hintText: hint,
                    ),
                  ),
                ),
                widget == null ? Container() : widget!,
              ],
            ),
          ),
        )
      ]),
    );
  }
}
