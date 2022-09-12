import 'package:mysql1/mysql1.dart';

class DatabaseOnline {
  DatabaseOnline._();
  static DatabaseOnline instance = DatabaseOnline._();
  Future<MySqlConnection> connection() async {
    var connectionSettings = ConnectionSettings(
      host: "deriafrica.org",
      port: 3306,
      user: 'u157010382_Engelbert',
      db: 'u157010382_Derie',
      password: 'Deri@frica2022',
      timeout: const Duration(hours: 1),
    );
    var connection = await MySqlConnection.connect(connectionSettings);
    return connection;
  }
}
