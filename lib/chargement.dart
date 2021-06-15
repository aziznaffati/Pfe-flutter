import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'auth/authProvider.dart';

class CharPage extends StatefulWidget {
final  String snPDA;
CharPage({this.snPDA});
  @override
  _CharPage createState() => _CharPage();
}

class _CharPage extends State<CharPage> {
  bool _isload1 = false;
  bool _isload2 = false;
  bool _isload0 = false;
  FocusNode _focus0 = FocusNode();
  FocusNode _focus1 = FocusNode();
  final dayStat = TextEditingController();
  final monthStat = TextEditingController();
  DateTime statD = DateTime.now();
  DateTime statM = DateTime.now();

  Future<dynamic> submit(snc, date,heure) async {
    try {
      
      Map<String, String> body = {
        'snC': snc,
        'snPDA': widget.snPDA,
        'datechargementChar': date,
        'heure_ch': heure,
        
      };

      print('body ==> $body');

      var res = await http.post("https://pfeisetz.herokuapp.com/chargement/",
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8'
          },
          body: body);

      print(res.body);
      if (res.statusCode == 409) {
        String message = jsonDecode(res.body)['message'];
        _showDialog(message);
      } else {
        _showDialog('Chariot Envoyer');
      }

      print(res.body);
      return 'Seccess';
      //final parsed = json.decode(res.body).cast<Map<String, dynamic>>();
      //return parsed.map<Product>((json) =>Product.fromJson(json)).toList();

    } catch (e) {
      return 'Fail';
    }
  }

Future<dynamic> subC( snc) async {
    try {
      Map<String, dynamic> body = {
              
              'statuChar': "Chariot On Stock ",
             
            };
var resl = await http.patch(
                "https://pfeisetz.herokuapp.com/chariot/$snc",
                headers: <String, String>{
                  'Context-Type': 'application/json;charSet=UTF-8'
                }, body: body);
            print('reslllp ==>${resl.body}');
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
  String bar = 'Reference Chariot';
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
          'Chargement Chariot',
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
                              child: Text("Chargement Chariot",
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      bar = 'Numéro de série Chariot';
                                      
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
                                    submit(bar, todayDate,heure);
                                    subC(bar);
                                    print(todayDate);
                                    print(heure);
                                  },
                                  elevation: 6,
                                  disabledColor: Colors.grey,
                                  color: Color(0xFF2196F3),
                                  textColor: Colors.white,
                                  padding: EdgeInsets.all(8.0),
                                  splashColor: Color(0xFF2196F3),
                                  child: Text(
                                    "Chargement",
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