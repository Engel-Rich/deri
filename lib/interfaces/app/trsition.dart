// import 'package:deri/interfaces/app/application.dart';
// import 'package:deri/interfaces/app/authuser.dart';
// import 'package:deri/interfaces/app/splash.dart';
// // import 'package:deri/models/user.dart';
// import 'package:flutter/material.dart';

// class TransitionPage extends StatefulWidget {
//   const TransitionPage({Key? key}) : super(key: key);

//   @override
//   State<TransitionPage> createState() => _TransitionPageState();
// }

// class _TransitionPageState extends State<TransitionPage> {
//   bool isConnected = false, isLoading = true;
//   checConnection() async {
//     setState(() {
//       isLoading = true;
//     });
//     bool getuser = await Users.getUser();
//     if (getuser) {
//       final usr = Users.userSession;
//       usr.voir();
//       if (Users.userSession.userEmail != null) {
//         setState(() {
//           isConnected = true;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//           isConnected = false;
//         });
//       }
//     } else {
//       setState(() {
//         isConnected = false;
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     checConnection();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isLoading
//         ? const SpalshSCreen()
//         : isConnected
//             ? const Application()
//             : const LoginPage();
//   }
// }
