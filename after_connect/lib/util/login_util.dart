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