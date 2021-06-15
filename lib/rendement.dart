import 'dart:convert';
import 'dart:developer';

import 'package:SagemCom_App/user.dart';
import 'package:flutter/material.dart';
import 'package:SagemCom_App/auth/authProvider.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:http/http.dart' as http;

class RendementPage extends StatefulWidget {
  RendementPage({Key key, this.today, this.typeMonth}) : super(key: key);

  final String today;
  final bool typeMonth;

  @override
  State<StatefulWidget> createState() {
    return _RendementPage();
  }
}

class _RendementPage extends State<RendementPage> {
  bool _isload1 = false;
  bool _isload2 = false;
  bool _isload0 = false;
  FocusNode _focus0 = FocusNode();
  FocusNode _focus1 = FocusNode();
  final dayStat = TextEditingController();
  final monthStat = TextEditingController();
  DateTime statD = DateTime.now();
  DateTime statM = DateTime.now();

// ignore: missing_return

  Future<List<Dechargement>> dechargements;
  Future<List<Dechargement>> save() async {
    try {
      var res = await http.get(
        "https://pfeisetz.herokuapp.com/dechargement/",
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8'
        },
      );
      //s print(res.body);

      if (res.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        var results = jsonDecode(res.body);

        List<Dechargement> dechargements = [];

        for (var item in results) {
          // print('podcat == $item');

          dechargements.add(Dechargement.fromMap(item));
        }

        return dechargements;
      } else {
        throw Exception('fail');
      }

      //    Listtrow<Chariot> chariots = [];
      //final parsed = json.decode(res.body).cast<Map<String, dynamic>>();
      //   return parsed.map<Chariot>((json) =>Chariot.fromMap(json)).toList();

    } catch (e) {
      print('Errorrr =>  ${e.toString()}');
      _showDialog(e);
      throw e;
    }
  }

  @override
  void initState() {
    dechargements = save();

    _changeDay();
    _changeMonth();
    super.initState();
    _focus0.addListener(() {
      if (_focus0.hasFocus) _selectDate(context);
    });
    _focus1.addListener(() {
      if (_focus1.hasFocus) _selectMonth();
    });
    _statDay(statD);
    _statMonth(statM);
  }

  _changeDay() {
    dayStat.text = "${statD.day} ${getMonthLetter(statD.month)} ${statD.year}";
  }

  _changeMonth() {
    monthStat.text = "${getMonthLetter(statM.month)} ${statM.year}";
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
      context: context,
      initialDate: statD,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );

    if (_datePicker != null) {
      statD = _datePicker;
      setState(() {
        _changeDay();
      });
      _statDay(statD);
    }
    FocusManager.instance.primaryFocus.unfocus();
  }

  Future _statDay(DateTime sday) async {
    setState(() {
      _isload1 = true;
    });
    String day = "${sday.year}/${sday.month}/${sday.day}";
    var res = await statDaily(day);

    if (res == null) {
      setState(() {});
    } else {
      // ignore: unused_local_variable
      for (var row in res) {
        setState(() {});
      }
    }
    setState(() {
      _isload1 = false;
    });
  }

  Future _statMonth(DateTime sday) async {
    setState(() {
      _isload2 = true;
    });
    var res = await statMonthly(sday);

    if (res == null) {
      setState(() {});
    } else {
      for (var row in res) {
        setState(() {});
      }
    }
    setState(() {
      _isload2 = false;
    });
  }

  _selectMonth() async {
    showMonthPicker(
      context: context,
      firstDate: DateTime(2021, 5),
      lastDate: DateTime(DateTime.now().year + 1, 9),
      initialDate: DateTime.now(),
      locale: Locale("fr"),
    ).then(
      (date) {
        print(date.toString());
        if (date != null) {
          setState(() {
            statM = date;
            _changeMonth();
            _isload2 = true;
          });
          _statMonth(statM);
        }
      },
    );

    FocusManager.instance.primaryFocus.unfocus();
  }

  bool show = false;
  bool calendarType = false;
  String testDate = "";

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

  @override
  Widget build(BuildContext context) {
    String dateToday = DateTime.now().toString();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Rendement",
            style: TextStyle(
              fontFamily: "ProductSans",
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: new SingleChildScrollView(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 50,
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.35,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: LoadingOverlay(
                        color: Colors.white,
                        progressIndicator: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                          strokeWidth: 2,
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Rendement",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFF2196F3),
                                      fontFamily: "ProductSans")),
                              TextField(
                                style: TextStyle(fontFamily: "ProductSans"),
                                decoration: InputDecoration(
                                  fillColor: Color(0xFF2196F3),
                                  hintText: "Rendement Date",
                                ),
                                keyboardType: null,
                                controller: calendarType ? dayStat : monthStat,
                                focusNode: _focus0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    color: Colors.blue,
                                    child: IconButton(
                                        icon: Icon(
                                          calendarType
                                              ? Icons.calendar_view_day_sharp
                                              : Icons.calendar_today_sharp,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            calendarType = !calendarType;
                                            show = false;
                                          });
                                        }),
                                  ),
                                  FlatButton(
                                      onPressed: () {
                                        String cond = calendarType
                                            ? "${statD.year}-${statD.month < 10 ? '0${statD.month}' : statD.month}-${statD.day < 10 ? '0${statD.day}' : statD.day}"
                                            : "${statD.year}-${statD.month < 10 ? '0${statD.month}' : statD.month}";

                                        // log('cond===> $cond');
                                        setState(() {
                                          testDate = cond;
                                          show = true;
                                        });

                                        // setState(() {
                                        //   testDate = cond;
                                        //   show = false;
                                        // });
                                      },
                                      color: Color(0xFF2196F3),
                                      textColor: Colors.white,
                                      child: Text(
                                        "Détails",
                                        style: TextStyle(
                                            fontFamily: "ProductSans"),
                                      )),
                                ],
                              )
                            ]),
                        isLoading: _isload1),
                  )),
              Container(
                  height: MediaQuery.of(context).size.height,
                  child: new SingleChildScrollView(
                      child: FutureBuilder<List<Dechargement>>(
                    future: dechargements,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) log(snapshot.error);
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());

                      // print('snapshot ==>> ${snapshot.data}');
                      // log('${dateToday}');
                      // String todayDate = calendarType == false
                      //     ? dateToday.toString().substring(0, 10)
                      //     : dateToday.toString().substring(0, 7);
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, int index) {
                          Dechargement dechargement = snapshot.data[index];
                          // log('calendar type ==> $calendarType');
                          log('chargement date ==> ${dechargement.datedechargementChar}');
                         
                          // log('ch dat 0--10 type ==> ${chargement.datechargementChar.toString().substring(0, 10)}');
                          String chargementDate = calendarType
                              ? dechargement.datedechargementChar
                                  .substring(0, 10)
                              : dechargement.datedechargementChar
                                  .substring(0, 7);
                          // String ch = chargement.datechargementChar;
                          // print('datechargementChar ==> $ch');
                          log('testdate ==> $testDate');
                          log('chargementDate ==> ${chargementDate.substring(0, testDate.length)}');

                          if (chargementDate == testDate) {
                            print('chariot snc ==> ${dechargement.snC}');

                            if (dechargements != null) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueAccent,
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                margin: EdgeInsets.only(bottom: 9),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Num de serie Chariot: ${dechargement.snC}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                      Text(
                                          'Num de serie PDA: ${dechargement.snPDA}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                      Text(
                                          'Date Chargement Chariot: ${dechargement.datedechargementChar.substring(0, 10)}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                      Text(
                                          'Heure Chargement Chariot: ${dechargement.heuredech}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                    ]),
                              );
                            }
                            return SizedBox(height: 0);
                          }
                          return SizedBox(height: 0);
                        },
                      );

                      // return the ListView widget :
                    },
                  )))
            ]))));
  } // This trailing comma makes auto-formatting nicer for build methods.

}
