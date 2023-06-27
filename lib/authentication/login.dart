// import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../component/alert.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}


class _LoginState extends State<Login> {
  var myusername, mypassword, myemail;
  final _formKey = GlobalKey<FormState>();

  signin() async {
    var formdata = _formKey.currentState;
    if (formdata!.validate()) {
      formdata.save();
      try {
        showLoading(context);
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: myemail, password: mypassword);
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(context).pop();
          print('No user found for that email.');
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("No user found for that email"))
            ..show();
        } else if (e.code == 'wrong-password') {
                Navigator.of(context).pop();
          print('Wrong password provided for that user.');
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("Wrong password provided for that user"))
            ..show();
        }
      }
    } else {
      print("not valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "images/jogo.png",
          fit: BoxFit.fitHeight,
          width: 100,
          height: 100,
        ),
        Container(
          padding: EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 15),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (val) {
                      myemail = val;
                    },
                    validator: (val) {
                      if (val!.length > 100) {
                        return "email cant be more than 100 letter";
                      }
                      if (val!.length < 2) {
                        return " email cant be less than 2 letters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Enter email",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 15, bottom: 2),
                    child: TextFormField(
                        onSaved: (val) {
                          mypassword = val;
                        },
                        validator: (val) {
                          if (val!.length > 100) {
                            return "password cant be more than 100 letter";
                          }
                          if (val!.length < 4) {
                            return " password cant be less than 4 letters";
                          }
                          return null;
                        },
                        obscureText: true, // hayde kermel tkhabbe l password
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.password),
                            hintText: "Enter Password",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                              ),
                            ))),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        Text("If you don't have an account,"),
                        InkWell(
                          child: Text("create account",
                              style: TextStyle(
                                color: Colors.blue[900],
                                decoration: TextDecoration.underline,
                              )),
                          onTap: (() {
                            Navigator.of(context).pushNamed("signup");
                          }),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                        onPressed: () async {
                          var user = await signin();
                          if (user != null) {
                            Navigator.of(context)
                                .pushReplacementNamed("homepage");
                            print(user);
                          }
                        },
                        child: Text("Login")),
                  ),
                ],
              )),
        )
      ],
    )));
  }
}
