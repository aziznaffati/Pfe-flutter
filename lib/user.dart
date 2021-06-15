
class User {
   final String matriculeUser; 
   final String passUser;
   final String roleUser; 
   final String email; 
   final String mat_chef; 
   
   User(this.matriculeUser, this.passUser,this.roleUser, this.email,this.mat_chef); 
   factory User.fromMap(Map<String, dynamic> json) { 
      return User( 
         json['matriculeUser'], 
         json['passUser'], 
         json['roleUser'],
         json['email'],
         json['mat_chef'], 
         
      );
   }
}

class Produit {
   final String nserieProduit; 
   final int qtestock;
   final String maxembalageC; 
   final String maxembalageSH; 

   Produit(this.nserieProduit, this.qtestock, this.maxembalageC,this.maxembalageSH); 
   factory Produit.fromMap(Map<String, dynamic> json) { 
      return Produit( 
         json['nserieProduit'], 
         json['qtestock'], 
         json['maxembalageC'], 
          json['maxembalageSH'], 
         
      );
   }
}

class Panne {
   final String matuser; 
   final String sujetpanne;
   final String etat; 
   
   
   Panne(this.matuser, this.sujetpanne,this.etat); 
   factory Panne.fromMap(Map<String, dynamic> json) { 
      return Panne( 
         json['mat_user'], 
         json['sujet_panne'],
         json['etat'],  
          
         
      );
   }
}

class Ligne {
  final String snPDA; 
   final String designationPDA; 
  
   
   
   Ligne(this.snPDA,this.designationPDA); 
   factory Ligne.fromMap(Map<String, dynamic> json) { 
      return Ligne( 
         json['snPDA'], 
         json['designationPDA'], 
          
         
      );
   }
}

class Contenaire {
   final String snC; 
   final String nserieProduit;
    final int qtechar;
     final String date;
      final String heure;
   
   
   Contenaire(this.snC, this.nserieProduit,this.qtechar,this.date,this.heure); 
   factory Contenaire.fromMap(Map<String, dynamic> json) { 
      return Contenaire( 
         json['snC'], 
         json['nserie_produit'],
          json['qtechar'],
           json['date'],
            json['heure'], 
         
         
      );
   }
}

class Chariot {
   final String snC; 
   final String statuChar;
  
   
   Chariot(this.snC, this.statuChar); 
   factory Chariot.fromMap(Map<String, dynamic> json) { 
      return  Chariot( 
         json['snC'], 
         json['statuChar'], 
         
         
      );
   }
}

class Historique {
   final String matuser; 
   final String snPDA;
    final String date;
      final String heure;
   
   Historique(this.matuser, this.snPDA,this.date,this.heure); 
   factory Historique.fromMap(Map<String, dynamic> json) { 
      return  Historique( 
         json['mat_user'], 
         json['snPDA'], 
         json['date'], 
         json['heure'], 
         
         
      );
   }
}

class Dechargement {
   final String snC; 
   final String snPDA;
    final String datedechargementChar;
      final String heuredech;
   
   Dechargement(this.snC, this.snPDA,this.datedechargementChar,this.heuredech); 
   factory Dechargement.fromMap(Map<String, dynamic> json) { 
      return  Dechargement( 
         json['snC'], 
         json['snPDA'], 
         json['datedechargementChar'], 
         json['heure_dech'], 
         
         
      );
   }
}

class Chargement {
   final String snC; 
   final String snPDA;
    final String datechargementChar;
      final String heurech;
   
   Chargement(this.snC, this.snPDA,this.datechargementChar,this.heurech); 
   factory Chargement.fromMap(Map<String, dynamic> json) { 
      return  Chargement( 
         json['snC'], 
         json['snPDA'], 
         json['datechargementChar'], 
         json['heure_ch'], 
         
         
      );
   }
}




