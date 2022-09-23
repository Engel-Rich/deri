import 'package:deri/Firebases/firebaseusers.dart';
import 'package:deri/interfaces/View/newapplication.dart';

import 'package:deri/interfaces/adds/agendagood.dart';
import 'package:deri/interfaces/adds/parametres.dart';

import 'package:deri/interfaces/app/depenseui.dart';
import 'package:deri/interfaces/app/projetui.dart';
import 'package:deri/interfaces/app/projetuifornisseur.dart';
import 'package:deri/interfaces/app/splash.dart';
import 'package:deri/interfaces/app/theme.dart';
// import 'package:deri/interfaces/app/trsition.dart';

import 'package:deri/services/notification.dart';
import 'package:deri/services/notificationservices.dart';
// import 'package:deri/models/user.dart';

import 'package:deri/variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/Theme_services.dart';

class Application extends StatefulWidget {
  final int page;
  const Application({Key? key, required this.page}) : super(key: key);

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  int? selectedindex;
  UserApp? userApp;
  List uiList = <Widget>[
    const DepenseUi(),
    const ProjetUi(),
    const AgendaGood(),
  ];
  void listenNotification() =>
      NotificationApi.onNotifications.stream.listen((event) {
        // print("evenement $event");
      });
  final controller = Get.put(Themes());
  bool? dark;
  @override
  void initState() {
    NotificationServices().requestPermission();
    NotificationServices().getToken();
    NotificationServices().initInfos();
    dark = Get.isDarkMode;
    selectedindex = widget.page;
    NotificationApi.init();
    listenNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserApp>(
        stream: UserApp.getOneUserStream(authentication.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              bottomNavigationBar: taille(context).width < 640
                  ? !snapshot.data!.fournisseur!
                      ? BottomNavigationBar(
                          showSelectedLabels: false,
                          elevation: 0.0,
                          currentIndex: selectedindex!,
                          onTap: (index) {
                            setState(() {
                              selectedindex = index;
                            });
                          },
                          items: const [
                            BottomNavigationBarItem(
                              icon: Icon(Icons.money),
                              label: 'depenses',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.business),
                              label: 'Project',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.view_agenda),
                              label: 'Agenda',
                            ),
                          ],
                        )
                      : null
                  : null,
              body: snapshot.data!.fournisseur!
                  ? const ProjetUiFournisseur()
                  : taille(context).width < 640
                      ? uiList[selectedindex!]
                      : const NewApplication(),
              appBar: AppBar(
                leading: const SizedBox.shrink(),
                actions: [
                  IconButton(
                      onPressed: () {
                        UserApp.logout();
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     // builder: (context) => DeriAfrica(),
                        //   ),
                        // );
                      },
                      icon: Icon(
                        Icons.logout,
                        size: taille(context).width > 640 ? 30 : 24,
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Parametre(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.settings_sharp,
                        size: taille(context).width > 640 ? 30 : 24,
                      )),
                  IconButton(
                    onPressed: () {
                      ThemeServices().changeTheme();
                      setState(() {
                        dark = Get.isDarkMode;
                      });
                    },
                    icon: !dark!
                        ? const Icon(Icons.light_mode)
                        : const Icon(
                            Icons.dark_mode,
                          ),
                  )
                ],
                title: Text(
                  'Deri Mobile',
                  style: styletext.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
            );
          } else {
            return const SpalshSCreen();
          }
        });
  }
}
