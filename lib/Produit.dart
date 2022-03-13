

class Produit{
  
  
  String titre;
  String score;
  
  

  Produit(String titre, String score){
    this.titre = titre;
    this.score = score;
  }
  
    
    
  

  

  Map<String,dynamic> toJson(){
    return{
      
      'score' : this.score,
      'titre' : this.titre
    };
  }

  

}