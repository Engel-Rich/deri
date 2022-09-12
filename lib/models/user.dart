// import 'dart:convert';

// import 'package:deri/databases/databaonline.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Users {
//   String userName;
//   String userEmail;
//   int userId;
//   String? userPass;

//   Users(
//       {required this.userName,
//       required this.userEmail,
//       required this.userId,
//       this.userPass});

//   static Users userSession = Users(
//     userName: "",
//     userId: 0,
//     userEmail: '',
//   );

//   factory Users.fromMap(Map<String, dynamic> users) => Users(
//       userName: users['userName'],
//       userEmail: users['userEmail'],
//       userId: users['userId'],
//       userPass: users['userPass']);

//   Map<String, dynamic> toMap() => {
//         'userName': userName,
//         "userEmail": userEmail,
//         "userId": userId,
//         "userPass": userPass,
//       };

//   save() async {
//     final pref = await SharedPreferences.getInstance();
//     final user = jsonEncode(toMap());
//     await pref.setString("users", user);
//     print("Session: $user");
//   }

//   static Future<bool> getUser() async {
//     final pref = await SharedPreferences.getInstance();
//     final String? result = await pref.getString("users")!.trim();
//     if (result!.isNotEmpty) {
//       final decode = jsonDecode(result);
//       final Users usersM = Users.fromMap(decode);
//       userSession.userEmail = usersM.userEmail;
//       userSession.userId = usersM.userId;
//       userSession.userName = usersM.userName;
//       userSession.userPass = usersM.userPass;
//       return true;
//     } else {
//       return false;
//     }
//   }

//   voir() {
//     debugPrint('''
//     Name : $userName,
//     Email: $userEmail,
//     id : $userId,
// ''');
//   }

//   static Future<Users>? getOneUser(int id) async {
//     Users users = Users(userName: "Admin test", userEmail: "", userId: 0);
//     final con = await DatabaseOnline.instance.connection();
//     Users list;
//     await con.query("Select * From Users Where userId= ?", [id]).then((value) {
//       for (var user in value) {
//         final usr = Users(
//           userName: user['userName'].toString(),
//           userEmail: user['userEmail'].toString(),
//           userId: user['userId'],
//           userPass: user['userPass'].toString(),
//         );
//         if (usr.userId != 0) {
//           users = usr;
//         }
//       }
//     });
//     return users;
//   }

//   static Future<List<Users>>? userList() async {
//     final con = await DatabaseOnline.instance.connection();
//     final List<Users> list = [];
//     await con
//         .query(
//       "Select * From Users",
//     )
//         .then((value) {
//       for (var user in value) {
//         final usr = Users(
//           userName: user['userName'].toString(),
//           userEmail: user['userEmail'].toString(),
//           userId: user['userId'],
//           userPass: user['userPass'].toString(),
//         );
//         list.add(usr);
//       }
//     });
//     return list;
//   }

//   static logOut() async {
//     final pref = await SharedPreferences.getInstance();
//     await pref.setString("users", "");
//   }

//   static Future<bool> loginUser(String userEmail, String userPass) async {
//     final con = await DatabaseOnline.instance.connection();
//     bool result = false;
//     final List<Users> list = [];
//     await con.query("Select * From Users Where userPass = ? And userEmail = ?",
//         [userPass, userEmail]).then((value) {
//       print("valuer de retou est $value");
//       if (value == null) {
//         print("retun Login value est nulle et sa valeur est : $value");
//         result = false;
//       } else {
//         print("retun Login value $value");
//         for (var user in value) {
//           final usr = Users(
//             userName: user['userName'].toString(),
//             userEmail: user['userEmail'].toString(),
//             userId: user['userId'],
//             userPass: user['userPass'].toString(),
//           );
//           usr.save();
//           result = true;
//         }
//       }
//     });
//     return result;
//   }
// }
