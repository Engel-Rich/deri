import 'package:deri/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class UserApp {
  final String name;
  final String email;

  String? password;
  String? userid;
  String? profile;
  bool fournisseur;

  UserApp({
    required this.name,
    required this.email,
    this.userid,
    this.password,
    this.profile,
    this.fournisseur = false,
  });

  Future<String?> register() async {
    try {
      final userResult = await authentication.createUserWithEmailAndPassword(
          email: email, password: password!);
      await userResult.user!.updateDisplayName(name);
      final uid = userResult.user!.uid;
      userid = uid;
      try {
        final docu = userCollection.doc(uid);
        await docu.set(toMap());
        return null;
      } catch (e) {
        // print(e.toString());
        return e.toString();
      }
    } on FirebaseException catch (e) {
      // print(e.toString());
      return e.code;
    }
  }

  Future<String?> login() async {
    try {
      final userResult = await authentication.signInWithEmailAndPassword(
          email: email, password: password!);
      if (userResult.user != null) {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print("Erreur firebase $e");
      return e.code;
    }
    return null;
  }

  static logout() async {
    try {
      await authentication.signOut();
    } on FirebaseAuthException catch (e) {
      print("Erreur firebase ${e.code}");
    }
  }

  toMap() => {
        "name": name,
        "email": email,
        "userid": userid,
        "profile": profile,
        'fournisseur': fournisseur
      };

  factory UserApp.fromMap(Map<String, dynamic> map) => UserApp(
      name: map['name'],
      email: map['email'],
      userid: map['userid'],
      profile: map['profile'],
      fournisseur: map['fournisseur']);
  static Stream<List<UserApp>> get userapps => userCollection.snapshots().map(
      (event) => event.docs.map((e) => UserApp.fromMap(e.data())).toList());
  static Future<List<UserApp>>? futureUser() async {
    final userAppList = await userCollection.get().then(
        (value) => value.docs.map((e) => UserApp.fromMap(e.data())).toList());
    return userAppList;
  }

  static Future<UserApp> getOneUser(idUser) {
    final onUser = userCollection
        .doc(idUser)
        .get()
        .then((value) => UserApp.fromMap(value.data()!));
    return onUser;
  }

  static Stream<UserApp> getOneUserStream(idUser) {
    final onUser = userCollection
        .doc(idUser)
        .snapshots()
        .map((event) => UserApp.fromMap(event.data()!));
    return onUser;
  }

  static Stream<List<UserApp>> fournisseurList() {
    final onUser = userCollection
        .where('fournisseur', isNull: false)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => UserApp.fromMap(e.data())).toList());
    return onUser;
  }
}
