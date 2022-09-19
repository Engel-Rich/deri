// ignore_for_file: avoid_print

import 'package:deri/Firebases/firebaseusers.dart';
import 'package:deri/interfaces/adds/register.dart';
// import 'package:deri/interfaces/app/application.dart';
import 'package:deri/interfaces/app/splash.dart';
// import 'package:deri/interfaces/app/trsition.dart';
import 'package:deri/main.dart';
// import 'package:deri/models/user.dart';
import 'package:deri/variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

import '../../services/Theme_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final specer = const SizedBox(
    height: 30.0,
  );
  bool visible = true;
  String errorLogin = " ";
  bool showssplash = false;

  final logFormkey = GlobalKey<FormState>();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return showssplash
        ? const SpalshSCreen()
        : Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    ThemeServices().changeTheme();
                  },
                  icon: Get.isDarkMode
                      ? const Icon(Icons.light_mode, size: 30)
                      : const Icon(Icons.dark_mode, size: 30),
                )
              ],
              elevation: 0.0,
              centerTitle: true,
              title: Text(
                "Deri Application",
                style: styletitle,
              ),
            ),
            body: Container(
              margin: EdgeInsets.symmetric(
                horizontal: estGrand(context)
                    ? taille(context).width * 0.20
                    : taille(context).width * 0.07,
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: logFormkey,
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/logo.png",
                          width: estGrand(context)
                              ? taille(context).width * 0.5
                              : taille(context).width * 0.7,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          height: 50,
                          child: Center(
                            child: Text(
                              errorLogin,
                              style: styletext.copyWith(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        // Email input
                        Container(
                          decoration: BoxDecoration(
                            // color: Colors.blueGrey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: controllerEmail,
                            validator: (val) {
                              return val!.trim().isEmpty
                                  ? "please suplie an Email"
                                  : null;
                            },
                            style: styletext.copyWith(
                              fontSize: 15,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Get.isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.blueGrey.shade100,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: "enter your Email",
                              icon: Icon(
                                Icons.email,
                                size: estGrand(context) ? 30 : 24,
                              ),
                              hintStyle: styletext,
                            ),
                          ),
                        ),
                        specer,
                        // password input
                        Container(
                          decoration: BoxDecoration(
                            // color: Colors.blueGrey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            controller: controllerPassword,
                            validator: (val) {
                              return val!.trim().isEmpty
                                  ? "please suplie a Password"
                                  : null;
                            },
                            obscureText: visible,
                            style: styletext.copyWith(
                              fontSize: 15,
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Get.isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.blueGrey.shade100,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    visible = !visible;
                                  });
                                },
                                icon: Icon(
                                    visible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: estGrand(context) ? 30 : 24),
                              ),
                              hintText: "enter your password",
                              icon: Icon(
                                Icons.security,
                                size: estGrand(context) ? 30 : 24,
                              ),
                              hintStyle: styletext,
                            ),
                          ),
                        ),
                        spacerheight(10),
                        // Row(children: [
                        //   TextButton(
                        //     onPressed: () {
                        //       Navigator.of(context).push(PageTransition(
                        //           child: const Register(),
                        //           type: PageTransitionType.bottomToTop));
                        //     },
                        //     child:
                        //         Text("I dont have count ?", style: styletitle),
                        //   ),
                        // ]),
                        // Botton
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
                              if (logFormkey.currentState!.validate()) {
                                setState(() {
                                  showssplash = true;
                                });
                                final String userEmail =
                                    controllerEmail.text.trim();
                                final String userPass =
                                    controllerPassword.text.trim();
                                final userApp = UserApp(
                                    name: "",
                                    email: userEmail,
                                    password: userPass);
                                try {
                                  final login = await userApp.login();
                                  // print('resulte : $login');
                                  if (login.toString().isEmpty) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        child: DeriAfrica(),
                                        type: PageTransitionType.bottomToTop,
                                      ),
                                    );
                                    setState(() {
                                      showssplash = false;
                                      errorLogin = " ";
                                      logFormkey.currentState!.reset();
                                    });
                                  } else {
                                    print(login);
                                    setState(() {
                                      showssplash = false;
                                      errorLogin =
                                          "Incorrecte Email or Password";
                                    });
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              } else {
                                setState(() {
                                  errorLogin =
                                      "Please suplie the required informations";
                                });
                              }
                            },
                            icon: Icon(
                              Icons.login,
                              size: estGrand(context) ? 30 : 24,
                            ),
                            label: Text(
                              "Login",
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
