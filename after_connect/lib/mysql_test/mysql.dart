import 'package:mysql1/mysql1.dart';

class Mysql {
  //mysql database の情報
  static String host = '10.0.2.2',
                user = 'root',
                password = '',
                db = 'world';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async{
    var settings = ConnectionSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      db: db
    );
    return await MySqlConnection.connect(settings);
  }
}