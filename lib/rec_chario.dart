import 'dart:convert';

import 'package:SagemCom_App/user.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'auth/authProvider.dart';

class RecPage extends StatefulWidget {
  final String snc;
  final String sn;
  final int qt;
  final String date;
  final String heure;
  RecPage({this.snc, this.sn, this.qt, this.date, this.heure});
  @override
  _RecPage createState() => _RecPage();
}

class _RecPage extends State<RecPage> {
  bool _isload1 = false;
  bool _isload2 = false;
  bool _isload0 = false;
  FocusNode _focus0 = FocusNode();
  FocusNode _focus1 = FocusNode();
  final dayStat = TextEditingController();
  final monthStat = TextEditingController();
  DateTime statD = DateTime.now();
  DateTime statM = DateTime.now();

  Future<dynamic> subC(snc) async {
    try {
      Map<String, dynamic> body = {
        'statuChar': "Chariot à l'état de Réception ",
      };
      var resl = await http.patch("https://pfeisetz.herokuapp.com/chariot/$snc",
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8'
          },
          body: body);
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

  Future<dynamic> supp(snc, sn) async {
    try {
      var res = await http.delete(
        "https://pfeisetz.herokuapp.com/contenaire/$snc/$sn",
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8'
        },
      );
      print(res.body);

      if (res.statusCode == 200) {
        String message = jsonDecode(res.body)['message'];
        _showDialog(message);
      } else {
        String message = jsonDecode(res.body)['message'];
        _showDialog(message);
        throw Exception('fail');
      }
    } catch (e) {
      print('Errorrr =>  ${e.toString()}');
      _showDialog(e.body);
      throw e;
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
          'Réception Chariot',
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
                              child: Text("Réception Chariot",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF2196F3),
                                      fontFamily: "ProductSans"))),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Numéro de série Chariot: ${widget.snc}',
                                  style: TextStyle(
                                      fontSize: 16, fontFamily: "ProductSans")),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Numéro de série Produit: ${widget.sn}',
                                  style: TextStyle(
                                      fontSize: 16, fontFamily: "ProductSans")),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                  'Quantité à Réceptionner: ${widget.qt.toString()}',
                                  style: TextStyle(
                                      fontSize: 16, fontFamily: "ProductSans")),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Date Remplir Chariot: ${widget.date}',
                                  style: TextStyle(
                                      fontSize: 16, fontFamily: "ProductSans")),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Heure remplissage Chariot: ${widget.heure}',
                                  style: TextStyle(
                                      fontSize: 16, fontFamily: "ProductSans")),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RaisedButton(
                                  onPressed: () {
                                    subC(widget.snc);
                                    supp(widget.snc, widget.sn);
                                  },
                                  elevation: 6,
                                  disabledColor: Colors.grey,
                                  color: Color(0xFF2196F3),
                                  textColor: Colors.white,
                                  padding: EdgeInsets.all(8.0),
                                  splashColor: Color(0xFF2196F3),
                                  child: Text(
                                    "Réceptionner",
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
