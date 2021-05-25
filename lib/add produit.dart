import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'auth/authProvider.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPage createState() => _AddPage();
}

class _AddPage extends State<AddPage> {
  final dayStat = TextEditingController();
  final monthStat = TextEditingController();
  DateTime statD = DateTime.now();
  DateTime statM = DateTime.now();
  String selectedRadio;
  Future<dynamic> submit(sn, type, max,date) async {
    try {
      var result = await http.get(
          'https://pfeapis.herokuapp.com/produit/$sn',
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8'
          });
          if (result.statusCode == 200) {
  
       _showDialog('Numéro de serie Produit existe déja' );
         }else{
      var res = await http.post("https://pfeapis.herokuapp.com/produit/",
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8'
          },
          body: <String, String>{
            'nserieProduit': sn,
            'typeembalage': type,
            'maxembalage': max,
            'dateajout': date,
          });
      print('ffffffffffffffffffffff$type');
      print('ffffffffffffffffffffff$type');
      print('ffffffffffffffffffffff$type');
      print(res.body);
      
       _showDialog('Ajout fait avec Succes');
      }

      
          
    } catch (e) {
      //   print(jsonDecode(e.body)['message']['gtmlhklm']);
      _showDialog(e.toString());
      return null;
    }
  }
  
  final quantite = TextEditingController();

  OverlayEntry overlayEntry;
  String bar = 'Reference Produit';
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
  void initState() {
    super.initState();
    selectedRadio = '';
  }

  setSelectedRadio(String val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = new DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajout Produit',
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
                              child: Text("Ajout Produit",
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
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              controller: quantite,
                              decoration: InputDecoration(
                                  fillColor: Color(0xFF2196F3),
                                  hintText: "Max Embalage"),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Text('Type Embalage'),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ButtonBar(
                                      alignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Cartoon"),
                                        Radio(
                                          value: 'Cartoon',
                                          groupValue: selectedRadio,
                                          activeColor: Colors.blue,
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedRadio(val);
                                          },
                                        ),
                                        Text("Sachet"),
                                        Radio(
                                          value: 'Sachet',
                                          groupValue: selectedRadio,
                                          activeColor: Colors.blue,
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedRadio(val);
                                          },
                                        ),
                                      ],
                                    )
                                  ]),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      bar = 'Reference Produit';
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
                                     String todayDate =
                                        today.toString().substring(0, 10);
                                    submit(bar, selectedRadio, quantite.text,todayDate);
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
