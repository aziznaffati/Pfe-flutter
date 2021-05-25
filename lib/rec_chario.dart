import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:http/http.dart' as http;

class RecPage extends StatefulWidget {
  @override
  _RecPage createState() => _RecPage();
}

class _RecPage extends State<RecPage> {
  final dayStat = TextEditingController();
  final monthStat = TextEditingController();
  DateTime statD = DateTime.now();
  DateTime statM = DateTime.now();

  Future<dynamic> submit(snc, qteProdCh, date) async {
    try {
      print(snc);
      var result = await http.get('https://pfeapis.herokuapp.com/chariot/${snc}', 
           headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8'
        });
 print(result.body);

    var qteProdChar = jsonDecode(result.body)['chariot'];
    print(qteProdChar);
    
      Map<String, String> body = {
        'statuChar': 'Chariot vider',
        'datedechargementChar': date,
      };

      print('body ==> $body');

      var res = await http.patch("https://pfeapis.herokuapp.com/chariot/$snc",
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8'
          },
          body: body);print(' resp ===> ${res.body}');
      if (res.statusCode == 404) {
        String message = jsonDecode(res.body)['message'];
        print('message ==> $message');
        _showDialog(message);
      }else{_showDialog('Chariot vider');}
      
    
    } catch (e) {
//return null;
      throw Exception(e);
    }
  }

  final quantite = TextEditingController();

  bool isDisable = false;
  bool _saving = false;
  OverlayEntry overlayEntry;

  String bar = 'Reference Chariot';

  String barcode = 'Unknown';

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
          'Réceptioner Chariot',
          style: TextStyle(
            fontFamily: "ProductSans",
          ),
        ),
      ),
      body: LoadingOverlay(
          color: Colors.black,
          progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
            strokeWidth: 2,
          ),
          child: Center(
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 25,
                  child: SingleChildScrollView(
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
                                child: Text('Réceptioner Chariot',
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
                            TextField(
                              controller: quantite,
                              decoration: InputDecoration(
                                  fillColor: Color(0xFF2196F3),
                                  hintText: "Quantité à Réceptioner"),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.only(top: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          bar = "Reference Chariot";
                                          quantite.text = "";
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
                                            
                                        submit(
                                            '111', quantite.text, todayDate);
                                        print(todayDate);
                                      },
                                      elevation: 6,
                                      disabledColor: Colors.grey,
                                      color: Color(0xFF2196F3),
                                      textColor: Colors.white,
                                      padding: EdgeInsets.all(8.0),
                                      splashColor: Color(0xFF2196F3),
                                      child: Text(
                                        "VALIDER",
                                        style: TextStyle(
                                          fontFamily: "ProductSans",
                                        ),
                                      ))
                                ],
                              ),
                            )
                          ]),
                    ),
                  ))),
          isLoading: _saving),
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
