import 'package:deri/models/agenda.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseLocal {
  DatabaseLocal._();
  static DatabaseLocal instance = DatabaseLocal._();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDB();
    }
    return _database!;
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), "deriLocalDb"),
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE IF NOT EXISTS Agenda(idAgenda INTEGER NOT NULL PRIMARY KEY, title Text, description TEXT, jour  TEXT , heure TEXT )");
      },
      version: 1,
    );
  }

  void insertAgenda(Agenda agenda) async {
    final Database db = await database;
    await db.insert("Agenda", agenda.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  void updateAgenda(Agenda agenda) async {
    final Database db = await database;
    await db.update("Agenda", agenda.toMap(),
        where: "idAgenda = ?",
        whereArgs: [agenda.idAgenda],
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  void deleAgenda(int idAgenda) async {
    final Database db = await database;
    await db.delete(
      "Agenda",
      where: 'idAgenda = ?',
      whereArgs: [idAgenda],
    );
  }

  Future<List<Agenda>> agendaget() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      "Agenda",
      distinct: true,
    );
    List<Agenda> agenda =
        List.generate(maps.length, (index) => Agenda.fromMap(maps[index]));
    return agenda;
  }
}
