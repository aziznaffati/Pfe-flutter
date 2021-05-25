import 'package:flutter/material.dart';

import 'package:SagemCom_App/user.dart';

class AuthProvider extends ChangeNotifier {
  bool auth = false;

  void changeAuthStatus(bool newAuth) {
    auth = newAuth;

    notifyListeners();
  }
}

// ignore: missing_return
Future<bool> majStatus(String status, int id, int quantite) async {
  try {

  }catch (err){
  print(err);
    return false;
  }
  
  }

  // ignore: missing_return
  Future<bool> updatePasswd(String usr, String passwd) async {
  try {

} catch (err) {
    print(err);
    return false;
  }
}

// ignore: missing_return
Future<bool> insertchariot(Chariot chariot) async {
  try {
} catch (err) {
    print(err);
    return false;
  }
}

Future prodDispo() async {
  try {
    } catch (e) {
    return [];
  }
}

Future getDetail(String condition) async {
  try {
} catch (err) {
    print(err);
    return false;
  }
}

String beautyNumber(int num) {
  String val = "$num".split('').reversed.join();
  String newVal = "";

  for (int i = 0; i < val.length; i++) {
    if (i % 3 == 0) newVal += " ";
    newVal += val[i];
  }

  return newVal.split('').reversed.join();
}

Future statDaily(day) async {
  try {
     } catch (err) {
    print(err);
    return null;
  }
}

Future statMonthly(DateTime day) async {
  try {
     } catch (err) {
    print(err);
    return null;
  }
}

Future showAllProduct({String query: "1"}) async {
  try {
    } catch (err) {
    print(err);
    return null;
  }
}

Future<bool> insertProduit(Produit prod) async {
  try {
    } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> updateProduit(Produit prod) async {
  try {
     } catch (e) {
    print(e);
    return false;
  }
}
getMonthLetter(int m) {
  switch (m) {
    case 1:
      {
        return "Janvier";
      }
      break;
    case 2:
      {
        return "Fevrier";
      }
      break;
    case 3:
      {
        return "Mars";
      }
      break;
    case 4:
      {
        return "Avril";
      }
      break;
    case 5:
      {
        return "Mai";
      }
      break;
    case 6:
      {
        return "Juin";
      }
      break;
    case 7:
      {
        return "Juillet";
      }
      break;
    case 8:
      {
        return "Août";
      }
      break;
    case 9:
      {
        return "Septembre";
      }
      break;
    case 10:
      {
        return "Octobre";
      }
      break;
    case 11:
      {
        return "Novembre";
      }
      break;
    case 12:
      {
        return "Decembre";
      }
      break;
  }
}