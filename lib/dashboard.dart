import 'dart:convert';

import 'package:SagemCom_App/rec_chario.dart';
import 'package:SagemCom_App/rendement.dart';
import 'package:SagemCom_App/stock-charv.dart';
import 'package:SagemCom_App/stock_char.dart';
import 'package:SagemCom_App/user.dart';
import 'package:flutter/material.dart';
import 'package:SagemCom_App/signin.dart';
import 'package:SagemCom_App/env_chario.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'Miseajourproduit.dart';
import 'Misecontenaire.dart';
import 'add contenaire.dart';
import 'add produit.dart';

class MyApp2 extends StatelessWidget {
  MyApp2({Key key, this.role, this.matricule}) : super(key: key);
  final String role;
  final String matricule;

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SagemCom_App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        title: 'Gestion De Flux',
        role: role,
        matricule: matricule,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.role, this.matricule})
      : super(key: key);
  final String role;
  final String matricule;
  final String title;

  static String tag = "Homepage";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController typepanne = new TextEditingController();
  Future<String> _showDialog(notif) async => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Notification"),
            content: new Text(notif),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

// ignore: missing_return
  Future<String> save(String typepanne) async {
    try {
      var res = await http.post("https://pfeapis.herokuapp.com/panne/",
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8'
          },
          body: <String, String>{
            'mat_user': widget.matricule,
            'type_panne': typepanne,
            'etat':'Non Résolut'
          });
      if (res.statusCode == 409) {
        _showDialog('Entrer le type de panne');
      } else {
        _showDialog('Panne Ajouter');
      }
      print(res.body);

      //   _showDialog(res.body);
      return 'Seccess';
    } catch (e) {
      //        _showDialog(e.body);
      print(e);
      print('Errrrrrrrrror ==> ${widget.matricule}');
      return 'Error ==> $e';
    }

    //  Navigator.push(
    //    context, new MaterialPageRoute(builder: (context) => MyApp2()));
  }

  Panne panne = Panne('', '', '');

  Future recpanne(String role, String matricule) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            "Reclamation de Panne",
            style: TextStyle(fontFamily: "ProductSans", color: Colors.blue),
          ),
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(15),
              child: Text(role),
            ),
            Container(
                margin: EdgeInsets.all(15),
                child: TextField(
                  controller: typepanne,
                  decoration: InputDecoration(
                      fillColor: Colors.blue, hintText: "Type panne"),
                )),
            Container(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                onPressed: () async {
                  setState(() {
                    typepanne = typepanne;
                  });
                  String result = await save(typepanne.text);
                  print('result sattus => $result');
                },
                elevation: 6,
                color: Colors.blue,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.blue,
                child: Text(
                  "Envoyer",
                  style: TextStyle(
                    fontFamily: "ProductSans",
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontFamily: "ProductSans"),
        ),
      ),
      body: Stack(children: [
        Center(
          child: Image.asset('images/logo.png'),
        ),
        Container(
          alignment: Alignment.topCenter,
          child: Text(
            "Bienvenu",
            style: GoogleFonts.pacifico(
                fontWeight: FontWeight.bold, fontSize: 50, color: Colors.blue),
          ),
        )
      ]),
      drawer: Drawer(
        
        child: ListView(
            padding: EdgeInsets.zero,
            children: widget.role == 'Ligne1'
                ? [
                    DrawerHeader(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25))),
                        child: Image.asset('images/logo.png')),
                    ListTile(
                      title: Text(
                        "Envoyer Chariot",
                        style: TextStyle(
                          fontFamily: "ProductSans",
                        ),
                      ),
                      leading:
                          Icon(Icons.add_shopping_cart, color: Colors.blue),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return EnvPage();
                        }));
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Les vide Chariots on Stock",
                        style: TextStyle(
                          fontFamily: "ProductSans",
                        ),
                      ),
                      leading: Icon(Icons.store_outlined, color: Colors.blue),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return GestionStockvPage();
                        }));
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Rendement",
                        style: TextStyle(
                          fontFamily: "ProductSans",
                        ),
                      ),
                      leading:
                          Icon(Icons.bar_chart_outlined, color: Colors.blue),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return RendementPage();
                        }));
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Panne",
                        style: TextStyle(
                          fontFamily: "ProductSans",
                        ),
                      ),
                      leading:
                          Icon(Icons.settings_outlined, color: Colors.blue),
                      onTap: () {
                        Navigator.of(context).pop();
                        recpanne(widget.role, widget.matricule);
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Deconnexion",
                        style: TextStyle(
                          fontFamily: "ProductSans",
                        ),
                      ),
                      leading: Icon(Icons.logout, color: Colors.blue),
                      onTap: () {
                        Future deconnexion() async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.clear();
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return Signin();
                          }));
                        }

                        deconnexion();
                      },
                    ),
                  ]
                : widget.role == 'Ligne2'
                    ? [
                        DrawerHeader(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(25),
                                    bottomRight: Radius.circular(25))),
                            child: Image.asset('images/logo.png')),
                        ListTile(
                          title: Text(
                            "Rèceptioner Chariot",
                            style: TextStyle(
                              fontFamily: "ProductSans",
                            ),
                          ),
                          leading:
                              Icon(Icons.add_shopping_cart, color: Colors.blue),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return RecPage();
                            }));
                          },
                        ),
                        ListTile(
                          title: Text(
                            "Les pleins Chariots on Stock",
                            style: TextStyle(
                              fontFamily: "ProductSans",
                            ),
                          ),
                          leading:
                              Icon(Icons.store_outlined, color: Colors.blue),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return GestionStockPage();
                            }));
                          },
                        ),
                        ListTile(
                          title: Text(
                            "Rendement",
                            style: TextStyle(
                              fontFamily: "ProductSans",
                            ),
                          ),
                          leading: Icon(Icons.bar_chart_outlined,
                              color: Colors.blue),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return RendementPage();
                            }));
                          },
                        ),
                        ListTile(
                          title: Text(
                            "Panne",
                            style: TextStyle(
                              fontFamily: "ProductSans",
                            ),
                          ),
                          leading:
                              Icon(Icons.settings_outlined, color: Colors.blue),
                          onTap: () {
                            Navigator.of(context).pop();
                            recpanne(widget.role, widget.matricule);
                          },
                        ),
                        ListTile(
                          title: Text(
                            "Deconnexion",
                            style: TextStyle(
                              fontFamily: "ProductSans",
                            ),
                          ),
                          leading: Icon(Icons.logout, color: Colors.blue),
                          onTap: () {
                            Future deconnexion() async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.clear();
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return Signin();
                              }));
                            }

                            deconnexion();
                          },
                        ),
                      ]
                    : [
                            DrawerHeader(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(25),
                                        bottomRight: Radius.circular(25))),
                                child: Image.asset('images/logo.png')),
                            ListTile(
                              title: Text(
                                "Ajout Produit",
                                style: TextStyle(
                                  fontFamily: "ProductSans",
                                ),
                              ),
                              leading: Icon(Icons.add, color: Colors.blue),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return AddPage();
                                }));
                              },
                            ),
                            ListTile(
                              title: Text(
                                "Mise à jours Produit",
                                style: TextStyle(
                                  fontFamily: "ProductSans",
                                ),
                              ),
                              leading: Icon(Icons.refresh, color: Colors.blue),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return MisPage();
                                }));
                              },
                            ),
                            ListTile(
                              title: Text(
                                "Ajout Contenaire",
                                style: TextStyle(
                                  fontFamily: "ProductSans",
                                ),
                              ),
                              leading: Icon(Icons.add, color: Colors.blue),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return AddCPage();
                                }));
                              },
                            ),
                            ListTile(
                              title: Text(
                                "Mise à jours Contenaire",
                                style: TextStyle(
                                  fontFamily: "ProductSans",
                                ),
                              ),
                              leading: Icon(Icons.refresh, color: Colors.blue),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return MisCPage();
                                }));
                              },
                            ),
                            ListTile(
                              title: Text(
                                "Panne",
                                style: TextStyle(
                                  fontFamily: "ProductSans",
                                ),
                              ),
                              leading: Icon(Icons.settings_outlined,
                                  color: Colors.blue),
                              onTap: () {
                                Navigator.of(context).pop();
                                recpanne(widget.role, widget.matricule);
                              },
                            ),
                            ListTile(
                              title: Text(
                                "Deconnexion",
                                style: TextStyle(
                                  fontFamily: "ProductSans",
                                ),
                              ),
                              leading: Icon(Icons.logout, color: Colors.blue),
                              onTap: () {
                                Future deconnexion() async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.clear();
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return Signin();
                                  }));
                                }

                                deconnexion();
                              },
                            ),
                          ]
                        
                          ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
