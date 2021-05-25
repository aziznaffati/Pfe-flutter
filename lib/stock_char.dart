
import 'dart:convert';

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


Future<List<Chariot>> save()  async {
   
   try {
        var res = await http.get("https://pfeapis.herokuapp.com/chariot/",
         headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8'
        },
       );
       print(res.body);

 if (res.statusCode == 200) {
       // If the server did return a 200 OK response,
       // then parse the JSON.
       var results = jsonDecode(res.body);
       
       List<Chariot> chariots = [];

       for (var item in results) {


         // print('podcat == $item');

       chariots.add(Chariot.fromMap(item));
       }
       
      
       return chariots;

 }else{
  String message = jsonDecode(res.body)['message'];
    _showDialog(message );
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
Future <dynamic> _showDialog(ress) async => 
  showDialog(
    
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
Future<List<Chariot>> chariots ;

@override
  void initState()  {
    // TODO: implement initState
    super.initState();
     chariots =  save();
  }

  
  @override
  Widget build(BuildContext context) {
    DateTime today = new DateTime.now();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Gestion des  Pleins Chariots",
          style: TextStyle(
            fontFamily: "ProductSans",
          ),
        ),
      ),
         body: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.6,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  margin: EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,                
           child: SingleChildScrollView(
             child: Column(children: [
               FutureBuilder<List<Chariot>>(future: chariots, builder: ( context, snapshot){
                  if (snapshot.hasError) print(snapshot.error); 
                  if(!snapshot.hasData) return Center(child: CircularProgressIndicator()); 
                
                print('snapshot ==>> ${snapshot.data}');
                String todayDate = today.toString().substring(0, 10);
                   return  ListView.builder(
                     shrinkWrap: true,
             itemCount: snapshot.data.length,
             itemBuilder: (context, int index) {
                
                Chariot chariot = snapshot.data[index];
                String chariotDate = chariot.datechargementChar.toString().substring(0, 10);
                  
                if((chariotDate == todayDate) && (chariot.statuChar=='Chariot Plein')  ){
                    return  Container(
                  height: 50,
                  child : Column(children: [Text(chariot.snC), Text(chariot.statuChar),]),
                );
                }else{
                  
                  return SizedBox(height: 0);
                }
              
             },
                   ); 
                   
                   // return the ListView widget : 
                   

               },)
             ]
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
    if(widget.onInit != null) {
      widget.onInit();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}