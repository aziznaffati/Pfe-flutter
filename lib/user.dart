
class User {
   final String matriculeUser; 
   final String passUser;
   final String roleUser; 
   
   User(this.matriculeUser, this.passUser, this.roleUser); 
   factory User.fromMap(Map<String, dynamic> json) { 
      return User( 
         json['matriculeUser'], 
         json['passUser'], 
         json['roleUser'], 
         
      );
   }
}

class Produit {
   final String matriculeProduit; 
   final String typeembalage;
   final String maxembalage; 
   
   Produit(this.matriculeProduit, this.typeembalage, this.maxembalage); 
   factory Produit.fromMap(Map<String, dynamic> json) { 
      return Produit( 
         json['matriculeProduit'], 
         json['typeembalage'], 
         json['maxembalage'], 
         
      );
   }
}

class Panne {
   final String matuser; 
   final String typepanne;
   final String datePanne; 
   
   Panne(this.matuser, this.typepanne, this.datePanne); 
   factory Panne.fromMap(Map<String, dynamic> json) { 
      return Panne( 
         json['mat_user'], 
         json['type_panne'], 
         json['datePanne'], 
         
      );
   }
}

class Ligne {
   final String designationPDA; 
   final DateTime dateaffecPDA;
   final String matuser; 
   
   Ligne(this.designationPDA, this.dateaffecPDA, this.matuser); 
   factory Ligne.fromMap(Map<String, dynamic> json) { 
      return Ligne( 
         json['designationPDA'], 
         json['dateaffecPDA'], 
         json['mat_user'], 
         
      );
   }
}

class Contenaire {
   final String snC; 
   final String nserieProduit;
   
   
   Contenaire(this.snC, this.nserieProduit); 
   factory Contenaire.fromMap(Map<String, dynamic> json) { 
      return Contenaire( 
         json['snC'], 
         json['nserie_produit'], 
         
         
      );
   }
}

class Chariot {
   final String snC; 
   final String statuChar;
   final String datechargementChar; 
   final String datedechargementChar; 
   final String qteProdChar; 
   final String nserieProduit;
   
   Chariot(this.snC, this.statuChar, this.datechargementChar,this.datedechargementChar,this.qteProdChar,this.nserieProduit); 
   factory Chariot.fromMap(Map<String, dynamic> json) { 
      return  Chariot( 
         json['snC'], 
         json['statuChar'], 
         json['datechargementChar'], 
         json['datedechargementChar'],
         json['QteProdChar'],
         json['nserie_produit'],
         
      );
   }
}



