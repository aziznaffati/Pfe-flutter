import 'dart:convert';

import 'package:SagemCom_App/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';

import 'add produit.dart';
import 'miseproduit.dart';

class ListPPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListPPage();
  }
}

class _ListPPage extends State<ListPPage> {


  Future<List<Produit>> save() async {
    try {
      var res = await http.get(
        "https://pfeisetz.herokuapp.com/produit/",
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8'
        },
      );
      print(res.body);

      if (res.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        var results = jsonDecode(res.body);

        List<Produit> produits = [];

        for (var item in results) {
          // print('podcat == $item');

          produits.add(Produit.fromMap(item));
        }

        return produits;
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
            content: new Text(ress.toString()),
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
  Future<List<Produit>> produits;


 Future<dynamic> supp(sn) async {
    try {
   print(sn);
      var res = await http.delete(
        "https://pfeisetz.herokuapp.com/produit/$sn",
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8'
        },
      );
      print(res.body);
      if (res.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        var results = jsonDecode(res.body);
        
_showDialog(results);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    produits = save();
  }
String sn = '';
int qt =0 ;
String mxc = '';
String mxsh = '';
  @override
  Widget build(BuildContext context) {
    DateTime today = new DateTime.now();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Gestion des Produits",
          style: TextStyle(
            fontFamily: "ProductSans",
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return AddPage();
          }));
        },
        child: Icon(Icons.add),
      ),
      body: new SingleChildScrollView(
              child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 8),
          margin: EdgeInsets.symmetric(vertical: 15),
          child:new SingleChildScrollView(
            child: Column(children: [
              FutureBuilder<List<Produit>>(
                future: produits,
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());

                  print('snapshot ==>> ${snapshot.data}');
                  String todayDate = today.toString().substring(0, 10);
                  return Column(
                    children: [
                      Container(
                          child:
                              Text('Total des produits: ${snapshot.data.length}',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                  ))),
                      SizedBox(height: 15),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, int index) {
                          Produit produit = snapshot.data[index];
                          // String chariotDate = chariot.datechargementChar.toString().substring(0, 10);

                          if (produit != null) {
                            return Container(
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
                                        Text(
                                            'Num de serie Produit: ${produit.nserieProduit}',
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
                                                    return MisePage(sn:produit.nserieProduit,qt:produit.qtestock,mxc: produit.maxembalageC,mxsh: produit.maxembalageSH,);
                                                     }));
                                          },
                                          child: Icon(Icons.update),
                                        )
                                      ],
                                    ),
                                    Text('Quantité on stock: ${produit.qtestock}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                    Text(
                                        'Max Quantité on Cartoon Par Chariot: ${produit.maxembalageC}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                    Row(
                                       mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            'Max Quantité on  Sashet: ${produit.maxembalageSH}',
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 20)),
                                      FloatingActionButton(
                                          backgroundColor:
                                              const Color(0xff03dac6),
                                          foregroundColor: Colors.black,
                                           mini: true,
                                          onPressed: () {
                                             supp(produit.nserieProduit);
                                          },
                                          child: Icon(Icons.delete),
                                        )
                                      ],
                                    ),
                                  ]),
                            );
                          } 
                            return SizedBox(height: 0);
                          
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
