// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:deri/Firebases/firebaseusers.dart';
import 'package:deri/interfaces/app/splash.dart';
import 'package:deri/main.dart';
import 'package:deri/variables.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPasse = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  String erno = " ";
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  bool visible = true;
  bool fournisseur = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? const SpalshSCreen()
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close, size: estGrand(context) ? 30 : 25),
              ),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(
                horizontal: estGrand(context)
                    ? taille(context).width * 0.20
                    : taille(context).width * 0.07,
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/logo.png",
                          width: estGrand(context)
                              ? taille(context).width * 0.5
                              : taille(context).width * 0.7,
                        ),
                        SizedBox(
                          height: 30,
                          child: Center(
                            child: Text(
                              erno,
                              style: styletext.copyWith(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        spacerheight(40),
                        // Premier champs pour le nom
                        TextFormField(
                          controller: controllerName,
                          validator: (val) {
                            return val!.isEmpty ? "Enter name" : null;
                          },
                          style: styletext.copyWith(
                            fontSize: 15,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            filled: true,
                            fillColor: Colors.blueGrey.shade100,
                            hintText: "enter your name",
                            prefixIcon: Icon(
                              Icons.person,
                              size: estGrand(context) ? 30 : 24,
                            ),
                            hintStyle: styletext,
                          ),
                        ),
                        spacerheight(30),
                        //   second champs por l'email
                        TextFormField(
                          controller: controllerEmail,
                          validator: (val) {
                            return val!.isEmpty ? "Enter Email" : null;
                          },
                          style: styletext.copyWith(
                            fontSize: 15,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            filled: true,
                            fillColor: Colors.blueGrey.shade100,
                            hintText: "enter your Email",
                            prefixIcon: Icon(
                              Icons.email,
                              size: estGrand(context) ? 30 : 24,
                            ),
                            hintStyle: styletext,
                          ),
                        ),
                        spacerheight(30),
                        // le troisième champs pour le mmot de passe
                        TextFormField(
                          controller: controllerPasse,
                          validator: (val) {
                            return val!.isEmpty
                                ? "Enter password"
                                : val.length <= 6
                                    ? "le mot de passe doit avoir 6 caractères"
                                    : null;
                          },
                          obscureText: visible,
                          style: styletext.copyWith(
                            fontSize: 15,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            filled: true,
                            fillColor: Colors.blueGrey.shade100,
                            hintText: "enter your password",
                            prefixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  visible = !visible;
                                });
                              },
                              child: Icon(
                                !visible ? Icons.lock : Icons.lock_open,
                                size: estGrand(context) ? 30 : 24,
                              ),
                            ),
                            hintStyle: styletext,
                          ),
                        ),
                        spacerheight(10),
                        // Row(
                        //   children: [
                        //     SwitchListTile(
                        //       value: fournisseur,
                        //       title: Text(
                        //         "I have a count !",
                        //         style: styletitle,
                        //       ),
                        //       onChanged: (val) {},
                        //     ),
                        //   ],
                        // ),
                        spacerheight(40),
                        // bouton de validation
                        Container(
                          width: double.infinity,
                          // padding: const EdgeInsets.all(12),
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                UserApp userApp = fournisseur
                                    ? UserApp(
                                        name: controllerName.text,
                                        email: controllerEmail.text,
                                        password: controllerPasse.text,
                                        fournisseur: true,
                                      )
                                    : UserApp(
                                        name: controllerName.text,
                                        email: controllerEmail.text,
                                        password: controllerPasse.text);

                                final error = await userApp.register();
                                print(
                                    "Error retouné : ${error.toString().trim()}");
                                if (error == null) {
                                  debugPrint('Aucune Erreur');
                                  // Navigator.pushReplacement(
                                  //   context,
                                  //   PageTransition(
                                  //       duration:
                                  //           const Duration(milliseconds: 0),
                                  //       child: const DeriAfrica(),
                                  //       type: PageTransitionType.fade),
                                  // );
                                  setState(() {
                                    loading = false;
                                    controllerEmail.clear();
                                    controllerName.clear();
                                    controllerPasse.clear();
                                  });
                                  Fluttertoast.showToast(
                                      msg: 'User adding succesfull');
                                } else {
                                  print(error);
                                  setState(() {
                                    loading = false;
                                    erno = error;
                                  });
                                }
                              }
                            },
                            icon: Icon(
                              Icons.login,
                              size: estGrand(context) ? 30 : 24,
                            ),
                            label: Text(
                              "Register",
                              style: styletitle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
