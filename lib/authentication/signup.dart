import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:untitled/component/alert.dart';



class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var myusername, mypassword, myemail;
  final _formKey = GlobalKey<FormState>();


  

  signup() async {
    var formdata = _formKey.currentState;
    if (formdata!.validate()) {
      formdata.save();
      try {
        showLoading(context);
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: myemail,
          password: mypassword,
        );
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.of(context).pop();
          print('The password provided is too weak.');
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("Password is too weak"))
            ..show();
        } else if (e.code == 'email-already-in-use') {
           Navigator.of(context).pop();
          print('The account already exists for that email.');
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("The account already exists for that email."))
            ..show();
        }
      } catch (e) {
        print(e);
      }
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
                      myusername = val;
                    },
                    validator: (val) {
                      if (val!.length > 100) {
                        return "username cant be more than 100 letter";
                      }
                      if (val!.length < 2) {
                        return " username cant be less than n2 letters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Enter Username",
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
                            prefixIcon: Icon(Icons.password),
                            hintText: "Enter email",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                              ),
                            ))),
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
                        obscureText: true, // This is for hiding the password
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
                        Text("If you have an account,"),
                        InkWell(
                          child: Text("Login",
                              style: TextStyle(
                                color: Colors.blue[900],
                                decoration: TextDecoration.underline,
                              )),
                          onTap: (() {
                            Navigator.of(context).pushNamed("login");
                          }),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child:
                        ElevatedButton(onPressed: ()async {
                            var user = await signup();
                          if(user != null){
                            await FirebaseFirestore.instance.collection("users").add({
                              "username" : myusername,
                              "email" : myemail
                            }).then((value) {
                               Navigator.of(context).pushReplacementNamed("homepage");
                            });
                            
                            
                          }
                        }, child: Text("SignUp")),
                  ),
                ],
              )),
        )
      ],
    )));
  }
}
