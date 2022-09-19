import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:deri/interfaces/adds/add_good_task.dart';
import 'package:deri/models/agenda.dart';
import 'package:deri/variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../services/notification.dart';

class AgendaGood extends StatefulWidget {
  const AgendaGood({Key? key}) : super(key: key);

  @override
  State<AgendaGood> createState() => _AgendaGoodState();
}

class _AgendaGoodState extends State<AgendaGood> {
  voitask(Agenda agenda) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: [
                Text(
                  agenda.title,
                  textAlign: TextAlign.center,
                  style: styletext.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 70,
                  child: Center(
                    child: Text(
                      "Date : ${DateFormat('E d MMM y').format(agenda.jour)}",
                      style: styletext.copyWith(
                          color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                  child: Center(
                    child: Divider(
                      height: 2,
                      thickness: 1,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              agenda.description ?? 'Aucune description pour cet évenement',
              style: styletext,
            ),
            contentPadding: const EdgeInsets.all(8),
            actions: [
              TextButton(
                onPressed: () {},
                child: Text(
                  'Modifie',
                  style: styletext,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  try {
                    agenda.delete();
                    NotificationApi.swoNotification(
                        title: agenda.title,
                        body:
                            "Vous aves supprime avec succés l'évènement ${agenda.description}",
                        payload: '2');
                  } catch (e) {
                    print("Erreur de supression $e");
                  }
                },
                child: Text(
                  'Delete',
                  style: styletext,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Quit',
                  style: styletext,
                ),
              ),
            ],
          );
        });
  }

  // My varriables

  DateTime selectedDate = DateTime.now();
  Stream<List<Agenda>>? agendalist;

  @override
  void initState() {
    agendalist = Agenda.agendas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  subAppbar(),
                  boutton(),
                ],
              ),
              dateBar(),
              StreamBuilder<List<Agenda>>(
                  stream: agendalist,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Agenda>> snapshot) {
                    if (snapshot.hasData &&
                        !snapshot.hasError &&
                        snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final agenda = snapshot.data![index];
                            if (agenda.jour.compareTo(selectedDate) <= 0) {
                              if (agenda.jour.compareTo(DateTime.now()) < 0) {
                                agenda.delete();
                              }
                              return Container(
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  onTap: () => voitask(agenda),
                                  isThreeLine: true,
                                  title: Text(agenda.title,
                                      style: styletitle.copyWith(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18,
                                      ),
                                      overflow: TextOverflow.ellipsis),
                                  subtitle: Text(agenda.description!,
                                      maxLines: 2,
                                      style: styletext.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          });
                    } else if (snapshot.hasError) {
                      // print(snapshot.error);
                      return Center(
                        child: texter(snapshot.error.toString()),
                      );
                    } else {
                      return Center(
                        child: texter("No data"),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  //  les fonctions retounant les wigets

  boutton() => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextButton.icon(
          onPressed: () => Get.to(const AddGoodAgenda()),
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          label: Text(
            'Add',
            style: styletext.copyWith(color: Colors.white),
          ),
        ),
      );

  // Date Bar
  dateBar() => SizedBox(
        height: 110,
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 8),
          child: DatePicker(
            DateTime.now(),
            height: 95,
            width: 65,
            initialSelectedDate: DateTime.now(),
            selectionColor: Theme.of(context).primaryColor,
            selectedTextColor: Colors.white,
            onDateChange: (date) {
              setState(() {
                selectedDate = date;
              });
            },
            dateTextStyle:
                styletext.copyWith(fontSize: 16, color: Colors.grey[600]),
            dayTextStyle:
                styletext.copyWith(fontSize: 16, color: Colors.grey[800]),
            monthTextStyle:
                styletext.copyWith(fontSize: 16, color: Colors.grey[800]),
          ),
        ),
      );
// date et bouton

  subAppbar() => SizedBox(
        height: 48,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat("d MMMM y").format(selectedDate),
                style: styletitle.copyWith(color: Colors.grey[400])),
            Text("Today", style: styletitle)
          ],
        ),
      );
}
