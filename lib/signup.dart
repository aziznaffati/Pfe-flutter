import 'package:flutter/material.dart';
import 'package:SagemCom_App/signin.dart';
import 'package:SagemCom_App/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;


class Signup extends StatefulWidget {
  Signup({Key key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  
  
  Future save(email, password) async {
    var res = await http.post("https://pfeapis.herokuapp.com/user/register",
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8'
        },
        body: <String, String>{
          'emailPer': email,
          'passPer': password,
        });
    print(res.body);
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => Signin()));
  }

  User user = User('', '','');
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  Text(
                    "Créer Compte",
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
                          return 'Entrer valide email';
                        } else if (RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return null;
                        } else {
                          return 'Entrer valide email';
                        }
                      },
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.email,
                            color: Colors.blue,
                          ),
                          hintText: 'Entrer Email',
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

                              await save(
                                  _emailController.text, _passController.text);
                             
                            } else {
                              print("not ok");
                            }
                          },
                          child: Text(
                            "Valider Ce Compte",
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
