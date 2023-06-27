import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/authentication/login.dart';
import 'package:untitled/crud/addNotes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/crud/editNotes.dart';
import 'firebase_options.dart';
import 'HomePage/homePage.dart';
import 'authentication/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


late bool isLogin;

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
var user = FirebaseAuth.instance.currentUser;
if(user == null){
  isLogin = false;
}else{isLogin=true;}
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.amber,
    
      ),
      debugShowCheckedModeBanner: false,
      home: isLogin == false ? Login() : HomePage(),
      routes: {
        "login" :(context) => Login() ,  
        "signup" :(context) => SignUp(), 
        "homepage" :(context) => HomePage() ,
        "addnotes" :(context) => AddNotes(),
        
        
        },
    );
  }
}
