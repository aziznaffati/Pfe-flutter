import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'auth/authProvider.dart';

class EnvPage extends StatefulWidget {
  @override
  _EnvPage createState() => _EnvPage();
}

class _EnvPage extends State<EnvPage> {
  bool _isload1 = false;
  bool _isload2 = false;
  bool _isload0 = false;
  FocusNode _focus0 = FocusNode();
  FocusNode _focus1 = FocusNode();
  final dayStat = TextEditingController();
  final monthStat = TextEditingController();
  DateTime statD = DateTime.now();
  DateTime statM = DateTime.now();

  Future<dynamic> submit(snc, sn, qteProdChar, date, heure) async {
    try {
     

            Map<String, dynamic> body = {
              'snC': snc,
              'nserie_produit': sn,
              'qtechar': qteProdChar,
              'date': date,
              'heure': heure
            };

            
log('body ==> $body');
            var res = await http.post(
                "https://pfeisetz.herokuapp.com/contenaire/",
                headers: <String, String>{
                  'Context-Type': 'application/json;charSet=UTF-8'
                },
                body: body);
           
            log('resp ==>${res.body}');
            if (res.statusCode != 200) {
              String message = jsonDecode(res.body)['message'];
              _showDialog(message);
              return 'fail11';
            }
_showDialog("Remplissage chariot fait avec Succée");
            // print(res.body);
            return 'Seccess';
          
       


    } catch (e) {
      return 'Fail';
    }
  }

 Future<dynamic> sub( sn, qteProdChar) async {
    try {
      Map<String, dynamic> body = {
              
              'qteProd': qteProdChar,
             
            };
var resl = await http.patch(
                "https://pfeisetz.herokuapp.com/produit/updateqte/$sn",
                headers: <String, String>{
                  'Context-Type': 'application/json;charSet=UTF-8'
                }, body: body);
            log('reslllp ==>${resl.body}');
            if (resl.statusCode != 200) {
              String message = jsonDecode(resl.body)['message'];
              _showDialog(message);
              return 'fail11';
            }
            // print(res.body);
            return 'Seccess';
          
       


    } catch (e) {
      return 'Fail';
    }
  }



 Future<dynamic> subC( snc) async {
    try {
      Map<String, dynamic> body = {
              
              'statuChar': "Chariot à l'état de Remplissage ",
             
            };
var resl = await http.patch(
                "https://pfeisetz.herokuapp.com/chariot/$snc",
                headers: <String, String>{
                  'Context-Type': 'application/json;charSet=UTF-8'
                }, body: body);
            log('reslllp ==>${resl.body}');
            if (resl.statusCode != 200) {
              String message = jsonDecode(resl.body)['message'];
              _showDialog(message);
              return 'fail11';
            }
            // print(res.body);
            return 'Seccess';
          
       


    } catch (e) {
      return 'Fail';
    }
  }


  final quantite = TextEditingController();

  OverlayEntry overlayEntry;
  String bar = 'Numéro de série Chariot';
  String bare = 'Numéro de série Produit';
  String barcode = 'Unknown';
  String notif = '';

  Future<String> _showDialog(notif) async => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Notification"),
            content: new Text(notif),
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
    DateTime today = new DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Remplir Chariot',
          style: TextStyle(
            fontFamily: "ProductSans",
          ),
        ),
      ),
      body: Stack(children: [
        Center(
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 25,
                child:new SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: MediaQuery.of(context).size.height * 0.02),
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width * 0.8,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: 10),
                              child: Text("Remplir Chariot",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF2196F3),
                                      fontFamily: "ProductSans"))),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(bar),
                              IconButton(
                                icon: Icon(Icons.camera_alt_outlined,
                                    color: Color(0xFF2196F3)),
                                onPressed: () async {
                                  String newBar = await scanBarcodeNormal();
                                  setState(() {
                                    bar = newBar;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(bare),
                              IconButton(
                                icon: Icon(Icons.camera_alt_outlined,
                                    color: Color(0xFF2196F3)),
                                onPressed: () async {
                                  String newBar = await scanBarcodeNormal();
                                  setState(() {
                                    bare = newBar;
                                  });
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              controller: quantite,
                              decoration: InputDecoration(
                                  fillColor: Color(0xFF2196F3),
                                  hintText: "Quantité à Envoyer"),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      bar = 'Numéro de série Chariot';
                                      bare = 'Numéro de série Produit';
                                      quantite.text = '';
                                    });
                                  },
                                  textColor: Color(0xFF2196F3),
                                  padding: EdgeInsets.all(8.0),
                                  splashColor: Color(0xFF2196F3),
                                  child: Text(
                                    "EFFACER",
                                    style: TextStyle(
                                      fontFamily: "ProductSans",
                                    ),
                                  )),
                              RaisedButton(
                                  onPressed: () {
                                    print(today);
                                    String todayDate =
                                        today.toString().substring(0, 10);
                                    String heure =
                                        today.toString().substring(11, 16);
                                    submit(bar, bare, quantite.text, todayDate,
                                        heure);
                                        sub(bare, quantite.text);
                                        subC(bar);
                                    print(todayDate);
                                  },
                                  elevation: 6,
                                  disabledColor: Colors.grey,
                                  color: Color(0xFF2196F3),
                                  textColor: Colors.white,
                                  padding: EdgeInsets.all(8.0),
                                  splashColor: Color(0xFF2196F3),
                                  child: Text(
                                    "Remplir",
                                    style: TextStyle(
                                      fontFamily: "ProductSans",
                                    ),
                                  ))
                            ],
                          )
                        ]),
                  ),
                ))),
      ]),
    );
  }

  Future<String> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(' BARCOde ==> $barcodeScanRes');
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      print('BARCODE ::==> $barcodeScanRes');
    }

    return barcodeScanRes;
  }
}
