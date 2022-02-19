import 'package:flutter/material.dart';
void main() => runApp(const MaterialApp(
  home: Home(),
));

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
            child:Container(
              // color: Colors.amber,
              child:Image.network('https://4.bp.blogspot.com/-vpajUL6jZkw/VMIu9i4l5aI/AAAAAAAAq2M/TPYfH7t6kXQ/s800/butsudan.png'),
            ),
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
                    side: BorderSide(width: 1.0, color: Colors.black),
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
class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text('ユーザー登録',style: TextStyle(
          color: Colors.black,
        ),),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 20.0,
        ),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('ユーザー名', style: TextStyle(
              fontSize: 16.0,
            ),),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '山田太郎',
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text('メールアドレス', style: TextStyle(
              fontSize: 16.0,
            ),),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Example@mail.com',
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text('パスワード', style: TextStyle(
              fontSize: 16.0,
            ),),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 60,
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 1.0, color: Colors.black),
                        // primary: Colors.white,
                        minimumSize: const Size.fromHeight(10),
                      ),
                      onPressed: (){
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const SignUpPage()),
                        // );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 10.0,
                        ),
                        child:Text(
                          '登録',
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Text(
                  '既にアカウントをお持ちの方',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text('ログイン',style: TextStyle(
          color: Colors.black,
        ),),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 20.0,
        ),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            SizedBox(
              height: 50.0,
            ),
            Text('メールアドレス', style: TextStyle(
              fontSize: 16.0,
            ),),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Example@mail.com',
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text('パスワード', style: TextStyle(
              fontSize: 16.0,
            ),),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 60,
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 1.0, color: Colors.black),
                        // primary: Colors.white,
                        minimumSize: const Size.fromHeight(10),
                      ),
                      onPressed: (){
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const SignUpPage()),
                        // );
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
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                  );
                },
                child: Text(
                  'パスワードを忘れた場合',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text('パスワードを忘れた場合',style: TextStyle(
          color: Colors.black,
        ),),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 20.0,
        ),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            SizedBox(
              height: 50.0,
            ),
            Text('メールアドレス', style: TextStyle(
              fontSize: 16.0,
            ),),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Example@mail.com',
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 60,
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 1.0, color: Colors.black),
                        // primary: Colors.white,
                        minimumSize: const Size.fromHeight(10),
                      ),
                      onPressed: (){
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const SignUpPage()),
                        // );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 10.0,
                        ),
                        child:Text(
                          '送信',
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'メールアドレスにURLを送ります',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

