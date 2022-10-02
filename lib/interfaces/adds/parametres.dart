import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:deri/Firebases/firebaseusers.dart';
import 'package:deri/interfaces/adds/addfornisseur.dart';
import 'package:deri/interfaces/adds/register.dart';
import 'package:deri/interfaces/app/splash.dart';

import 'package:deri/services/Theme_services.dart';
import 'package:deri/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

class Parametre extends StatefulWidget {
  const Parametre({Key? key}) : super(key: key);

  @override
  State<Parametre> createState() => _ParametreState();
}

class _ParametreState extends State<Parametre> {
  bool dark = false;
  bool loading = false;
  @override
  void initState() {
    setState(() {
      dark = Get.isDarkMode;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserApp>(
        stream: UserApp.getOneUserStream(authentication.currentUser!.uid),
        builder: (context, snapshot) {
          return (!snapshot.hasError && snapshot.hasData)
              ? Scaffold(
                  // appBar: AppBar(
                  //   title: Text("Settings", style: styletitle),
                  //   centerTitle: true,
                  //   leading: IconButton(
                  //       onPressed: () {
                  //         Navigator.of(context).pop();
                  //       },
                  //       icon: const Icon(Icons.arrow_back_ios)),
                  // ),
                  body: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 20),
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              height: 250,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.blueAccent.withOpacity(0.1),
                              ),
                              child: StreamBuilder<UserApp>(
                                  stream: UserApp.getOneUserStream(
                                      authentication.currentUser!.uid),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      // print(snapshot.data!.profile);
                                    }
                                    return Stack(
                                      children: [
                                        (snapshot.hasData &&
                                                (snapshot.data!.profile !=
                                                        null &&
                                                    snapshot.data!.profile!
                                                        .isNotEmpty))
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Stack(
                                                  children: [
                                                    CachedNetworkImage(
                                                      imageUrl: snapshot
                                                          .data!.profile!,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  downloadProgress) =>
                                                              spinkit(context),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                    Positioned(
                                                        bottom: 0,
                                                        child: Container(
                                                          height: 75,
                                                          width: taille(context)
                                                                  .width *
                                                              0.97,
                                                          color: Colors
                                                              .blue.shade900
                                                              .withOpacity(0.4),
                                                        )),
                                                    Positioned(
                                                        bottom: 15,
                                                        left: 10,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              snapshot
                                                                  .data!.name,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .justify,
                                                              style: styletext.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontSize: 20,
                                                                  letterSpacing:
                                                                      3,
                                                                  wordSpacing:
                                                                      2,
                                                                  color: Colors
                                                                      .white)),
                                                        ))
                                                  ],
                                                ),
                                              )
                                            : (snapshot.hasData)
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Stack(
                                                      children: [
                                                        Image.asset(
                                                          "assets/profile.jpg",
                                                          width:
                                                              double.infinity,
                                                          fit: BoxFit.contain,
                                                        ),
                                                        Positioned(
                                                            bottom: 0,
                                                            child: Container(
                                                              height: 75,
                                                              width: taille(
                                                                          context)
                                                                      .width *
                                                                  0.97,
                                                              color: Colors
                                                                  .blue.shade900
                                                                  .withOpacity(
                                                                      0.4),
                                                            )),
                                                        Positioned(
                                                            bottom: 15,
                                                            left: 10,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                  snapshot.data!
                                                                      .name,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .justify,
                                                                  style: styletext.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      fontSize:
                                                                          20,
                                                                      letterSpacing:
                                                                          3,
                                                                      wordSpacing:
                                                                          2,
                                                                      color: Colors
                                                                          .white)),
                                                            ))
                                                      ],
                                                    ),
                                                  )
                                                : Center(
                                                    child: texter(snapshot.error
                                                        .toString()),
                                                  ),
                                        Positioned(
                                            top: 0,
                                            right: 1,
                                            child: IconButton(
                                                onPressed: () {
                                                  sendImage();
                                                },
                                                icon: const CircleAvatar(
                                                    child: Icon(Icons.edit,
                                                        size: 30))))
                                      ],
                                    );
                                  }),
                            ),
                            spacerheight(15),
                            ListTile(
                              onTap: () async {
                                setState(() {
                                  loading = true;
                                });
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(
                                        email:
                                            authentication.currentUser!.email!)
                                    .whenComplete(() {
                                  getSnack(
                                      "Resset Email has been send in ${authentication.currentUser!.email!}",
                                      title: "Password reset",
                                      icon: const Icon(
                                        Icons.security_outlined,
                                        size: 30,
                                      ),
                                      color: Colors.lightBlueAccent);
                                  setState(() {
                                    loading = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg:
                                          "Resset Email has been send in ${authentication.currentUser!.email!}",
                                      backgroundColor: Colors.lightBlueAccent,
                                      toastLength: Toast.LENGTH_LONG);
                                });
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(
                                    color: Colors.blue.shade700,
                                  )),
                              title: Text(
                                'reset my password',
                                style: styletext.copyWith(
                                    wordSpacing: 1.5,
                                    letterSpacing: 3,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              leading: !loading
                                  ? const Icon(Icons.clear_all, size: 30)
                                  : const CircularProgressIndicator(),
                            ),
                            spacerheight(15),
                            snapshot.data!.isadmin!
                                ? ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(PageTransition(
                                          child: const AddFournisseur(),
                                          type: PageTransitionType.fade));
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide(
                                          color: Colors.blue.shade700,
                                        )),
                                    title: Text(
                                      'Ajouter un fournisseur',
                                      style: styletext.copyWith(
                                          wordSpacing: 1.5,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    leading: const Icon(
                                        Icons.add_circle_outline_outlined,
                                        size: 30),
                                  )
                                : const SizedBox.shrink(),
                            spacerheight(15),
                            snapshot.data!.isadmin!
                                ? ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(PageTransition(
                                          child: const Register(),
                                          type: PageTransitionType.fade));
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide(
                                          color: Colors.blue.shade700,
                                        )),
                                    title: Text(
                                      'Ajouter un utilisateur',
                                      style: styletext.copyWith(
                                          wordSpacing: 1.5,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    leading: const Icon(
                                        Icons.person_add_alt_1_outlined,
                                        size: 30),
                                  )
                                : const SizedBox.shrink(),
                            spacerheight(15),
                            ListTile(
                              onTap: () {
                                // Get.changeTheme(Themes.dark);
                                ThemeServices().changeTheme();
                                setState(() {
                                  dark = Get.isDarkMode;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(
                                    color: Colors.blue.shade700,
                                  )),
                              leading: !dark
                                  ? const Icon(Icons.light_mode, size: 30)
                                  : const Icon(Icons.dark_mode, size: 30),
                              title: texter(dark
                                  ? "Switch to light mode"
                                  : "Switch to dark mode"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : snapshot.hasError
                  ? Scaffold(
                      appBar: AppBar(),
                      body: Center(
                          child: Text(
                        snapshot.error.toString(),
                        style: styletext.copyWith(
                          color: Colors.red,
                        ),
                      )),
                    )
                  : const SpalshSCreen();
        });
  }

  bool imagview = false;
  File? image;
  sendImage() {
    ImagePicker picker = ImagePicker();

    String imegeUrl = "";
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Selectionnez un Image",
              style:
                  styletext.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            content: (!imagview)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await picker
                              .pickImage(source: ImageSource.camera)
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                image = File(value.path);
                                imagview = true;
                              });
                              Navigator.of(context).pop();
                              sendImage();
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.camera,
                          size: 30,
                          color: Color.fromRGBO(40, 173, 193, 1),
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      IconButton(
                        onPressed: () async {
                          await picker
                              .pickImage(source: ImageSource.gallery)
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                image = File(value.path);
                                imagview = true;
                              });
                              Navigator.of(context).pop();
                              sendImage();
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.photo,
                          size: 30,
                          color: Color.fromRGBO(40, 173, 193, 1),
                        ),
                      )
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(image!)),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      image = null;
                      imagview = false;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("Annuler",
                      style: styletext.copyWith(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              (!imagview)
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: () {
                        setState(() {
                          imagview = false;
                        });
                        Navigator.of(context).pop();
                        sendImage();
                      },
                      child: Text("Changer",
                          style: styletext.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600))),
              (imagview)
                  ? TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await FirebaseStorage.instance
                            .ref('Profile')
                            .child(authentication.currentUser!.uid)
                            .putFile(image!)
                            .whenComplete(() async {
                          await FirebaseStorage.instance
                              .ref('Profile')
                              .child(authentication.currentUser!.uid)
                              .getDownloadURL()
                              .then((value) async {
                            await authentication.currentUser!
                                .updatePhotoURL(value);
                            await userCollection
                                .doc(authentication.currentUser!.uid)
                                .update({'profile': value});
                            Fluttertoast.showToast(
                                msg: 'Profile photo updating succesfull');
                          });
                        });
                      },
                      child: Text("Valider",
                          style: styletext.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600)))
                  : Container()
            ],
          );
        });
  }
}
