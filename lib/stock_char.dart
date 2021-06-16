import 'dart:convert';

import 'package:SagemCom_App/rec_chario.dart';
import 'package:SagemCom_App/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';

class GestionStockPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GestionStockPage();
  }
}

class _GestionStockPage extends State<GestionStockPage> {
  Future<List<Contenaire>> save() async {
    try {
      var res = await http.get(
        "https://pfeisetz.herokuapp.com/contenaire/",
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8'
        },
      );
      print(res.body);

      if (res.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        var results = jsonDecode(res.body);

        List<Contenaire> contenaires = [];

        for (var item in results) {
          // print('podcat == $item');

          contenaires.add(Contenaire.fromMap(item));
        }

        return contenaires;
      } else {
        String message = jsonDecode(res.body)['message'];
        _showDialog(message);
        throw Exception('fail');
      }

      //    Listtrow<Chariot> chariots = [];
      //final parsed = json.decode(res.body).cast<Map<String, dynamic>>();
      //   return parsed.map<Chariot>((json) =>Chariot.fromMap(json)).toList();

    } catch (e) {
      print('Errorrr =>  ${e.toString()}');
      _showDialog(e.body);
      throw e;
    }

    //  Navigator.push(
    //    context, new MaterialPageRoute(builder: (context) => MyApp2()));
  }

  Future<dynamic> _showDialog(ress) async => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Notification"),
            content: new Text(ress),
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
  Future<List<Contenaire>> contenaires;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contenaires = save();
  }
String snc = '';
String sn = '';
int qt =0 ;
String date = '';
String heure = '';
  @override
  Widget build(BuildContext context) {
    DateTime today = new DateTime.now();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Liste Chariots on Stock",
          style: TextStyle(
            fontFamily: "ProductSans",
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 8),
        margin: EdgeInsets.symmetric(vertical: 15),
        
        child:new SingleChildScrollView(
          child: Column(children: [
            FutureBuilder<List<Contenaire>>(
              future: contenaires,
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                print('snapshot ==>> ${snapshot.data}');
                String todayDate = today.toString().substring(0, 10);
                return Column(
                  children: [
                    Container(
                        child: Text('Les chariots On Stock: ${snapshot.data.length}',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                            ))),
                    SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, int index) {
                        Contenaire contenaire = snapshot.data[index];
                        // String chariotDate = chariot.datechargementChar.toString().substring(0, 10);

                        if (contenaire != null) {
                          return Container(
                            // height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blueAccent,
                            ),
                             padding: EdgeInsets.symmetric(horizontal: 15),
                            margin: EdgeInsets.only(bottom: 9),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Num de série Chariot: ${contenaire.snC}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                               FloatingActionButton(
                                        backgroundColor:
                                            const Color(0xff03dac6),
                                        foregroundColor: Colors.black,
                                         mini: true,
                                        onPressed: () {
                                          Navigator.push(context,
                                                      MaterialPageRoute(builder:
                                                          (BuildContext context) {
                                          return RecPage(snc:contenaire.snC,sn:contenaire.nserieProduit,qt: contenaire.qtechar,date: contenaire.date.toString().substring(0, 10),heure: contenaire.heure,);
                                       }));
                                        },
                                        child: Icon(Icons.check),
                                      )
                                     
                                    ],
                                  ),
                                    
                                  Text('Num de série Produit: ${contenaire.nserieProduit}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                           Text('Quantité Charger: ${contenaire.qtechar}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                        
                                           Text('Date Chargement: ${contenaire.date.toString().substring(0, 10)}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                           Text('Heure Chargement: ${contenaire.heure}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ]),
                          );
                        } else {
                          return SizedBox(height: 0);
                        }
                      },
                    ),
                  ],
                );

                // return the ListView widget :
              },
            )
          ]),
        ),
      ),
    );
  }
}

class StatefulWrapper extends StatefulWidget {
  final Function onInit;
  final Widget child;
  const StatefulWrapper({@required this.onInit, @required this.child});
  @override
  _StatefulWrapperState createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {
  @override
  void initState() {
    if (widget.onInit != null) {
      widget.onInit();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
