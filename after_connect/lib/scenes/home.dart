import 'package:flutter/material.dart';
import '../mysql_test/mysql.dart';
import 'login_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var db = Mysql();
  var userName = "";
  void _getCustomer(){
    db.getConnection().then((conn){//たぶちがやった限りでは　ここではエラーは起きず、データベースには接続できていないわけではなさそう
      String sql = 'SELECT * FROM world.city;';
      conn.query(sql).then((results){
        print(results.length); //たぶちがやった限りでは results.length はなにやっても 0 つまりなにも返されていない。もしかしたらmysqlのほうでエラーがおきているのかも。
        for(var row in results){
          setState(() {
            userName = row[0];
          });
        }
      });
      conn.close();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                Text(
                  // 'After Connect',
                  userName,
                  style: const TextStyle(
                      fontSize: 50.0
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child:Image.network('https://4.bp.blogspot.com/-vpajUL6jZkw/VMIu9i4l5aI/AAAAAAAAq2M/TPYfH7t6kXQ/s800/butsudan.png'),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 50.0,
              horizontal: 50.0,
            ),
            child: Column(
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: Colors.black),
                    // primary: Colors.white,
                    minimumSize: const Size.fromHeight(10),
                  ),
                  onPressed: _getCustomer,
                  //     (){
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => const SignUpPage()),
                  //   );
                  // },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    child:Text(
                      'ユーザー登録',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: Colors.black),
                    // primary: Colors.white,
                    minimumSize: const Size.fromHeight(10),
                  ),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    child:Text(
                      'ログイン',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}