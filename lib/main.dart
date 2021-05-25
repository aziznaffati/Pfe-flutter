// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:SagemCom_App/auth/authProvider.dart';
import 'package:SagemCom_App/dashboard.dart';
import 'package:SagemCom_App/signin.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token");
  print(' token ==> $token ');

  if (token != null) {
    // Navigator.push(
    //
    //    context, MaterialPageRoute(builder: (context) => MainPage()));

    runApp(ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(
        con: MyApp2(),
      ),
    ));
  } else {
    runApp(MyApp(
      con: Signin(),
    ));
  }
}

class MyApp extends StatelessWidget {
  final Widget con;

  MyApp({this.con});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SagemCom App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: con,
    );
  }
}
