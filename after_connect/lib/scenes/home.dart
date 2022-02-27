import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'After Connect',
                  style: TextStyle(
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
                    side: BorderSide(width: 1.0, color: Colors.black),
                    // primary: Colors.white,
                    minimumSize: const Size.fromHeight(10),
                  ),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
                  },
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