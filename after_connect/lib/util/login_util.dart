import 'package:flutter/material.dart';

class PasswordInputField extends StatefulWidget {
  const PasswordInputField({
    Key? key,
  }) : super(key: key);

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('パスワード', style: TextStyle(
          fontSize: 16.0,
        ),),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: TextFormField(
            obscureText: hidePassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Password',
              suffixIcon: IconButton(
                onPressed: (){
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                icon: Icon(hidePassword? Icons.visibility_off:Icons.visibility),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class EmailInputField extends StatefulWidget {
  // final String emailText;
  const EmailInputField({
    // required this.emailText,
    Key? key,
  }) : super(key: key);

  @override
  State<EmailInputField> createState() => _EmailInputFieldState();
}

class _EmailInputFieldState extends State<EmailInputField> {
  String? requestModelEmail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('メールアドレス', style: TextStyle(
          fontSize: 16.0,
        ),),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            // onSaved: (input) => widget.emailText = input,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Example@mail.com',
            ),
          ),
        ),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 30.0,
        horizontal: 0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 60,
            ),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(width: 1.0, color: Colors.black),
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
    );
  }
}