import 'dart:convert';
import 'dart:developer';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:SagemCom_App/dashboard.dart';
import 'package:SagemCom_App/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Signin extends StatefulWidget {
  Signin({Key key}) : super(key: key);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  String notif = '';
  Future<String> save(mat, password) async {
    try {
      var res = await http.post("https://pfeisetz.herokuapp.com/user/login",
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8'
          },
          body: <String, String>{
            'matriculeUser': mat,
            'passUser': password,
          });
      log(res.body);
      if (res.statusCode == 200) {
       SharedPreferences prefs = await SharedPreferences.getInstance();
          var userData = jsonDecode(res.body)['userData'];
          await prefs.setString('userData', jsonEncode(userData));

        String role = jsonDecode(res.body)['userData']['roleUser'];
        return role;
      }

      print(res.body);
      String message = jsonDecode(res.body)['message'];
      _showDialog(message);
    } catch (e) {
      //   print(jsonDecode(e.body)['message']['gtmlhklm']);
      _showDialog(e.toString());
      return null;
    }

    //  Navigator.push(
    //    context, new MaterialPageRoute(builder: (context) => MyApp2()));
  }

  User user = User('', '', '', '', '');

  Future<String> _showDialog(ress) async => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Notification"),
            content: new Text(ress),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Fermer"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
            alignment: Alignment.topCenter,
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'images/logo.png',
              width: 400,
              height: 150,
            )),
        Container(
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child:new SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  Text(
                    "Connection",
                    style: GoogleFonts.pacifico(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: Colors.blue),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      // controller: TextEditingController(text: user.email),
                      controller: _emailController,
                      // onChanged: (value) {
                      //   user.email = value;
                      // },
                      validator: (value) {
                        if (value.isEmpty) {
                          notif = 'Matricule vide';
                          //_showDialog(notif);
                          return 'Matricule vide';
                        } else if (RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                          return null;
                        } else {
                          notif = 'Entrer valide Matricule';
                          //_showDialog(notif);

                          return 'Entrer valide matricule';
                        }
                      },
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
                          hintText: 'Entrer Matricule',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.blue)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.blue)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.red))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      // controller: TextEditingController(text: user.email),
                      // onChanged: (value) {
                      //   user.email = value;
                      // },
                      controller: _passController,
                      validator: (value) {
                        if (value.isEmpty) {
                          notif = 'Mot de passe vide';
                          // _showDialog(notif);
                          return 'Entrer valide Mot de passe';
                        }

                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.vpn_key,
                            color: Colors.blue,
                          ),
                          hintText: 'Entrer Mot de Passe',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.blue)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.blue)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.red))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(55, 16, 16, 0),
                    child: Container(
                      height: 50,
                      width: 400,
                      child: FlatButton(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              // save();

                              String role = await save(
                                  _emailController.text, _passController.text);
                              if (role != null && role != 'Admin') {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String token = prefs.getString(role);
                                String matricule = _emailController.text;

                                print(token);
                                print(matricule);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyApp2(
                                            role: role, matricule: matricule)));
                              } else {
                                notif = 'Verifier Matricule ou Mot de Passe';

                                print("not ok");
                                //_showDialog('');
                              }
                            }
                          },
                          child: Text(
                            "Connecter",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
