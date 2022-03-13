

import 'dart:async';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'Produit.dart';

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  final FirebaseDatabase db = FirebaseDatabase(app: app);
  db.setPersistenceEnabled(true);
  db.setPersistenceCacheSizeBytes(10000000);
  //addTextile();

  // DatabaseReference produits_ref = FirebaseDatabase(app: app).reference().child('produits');
  // produits_ref.keepSynced(true);
  runApp(MaterialApp(
    title: 'Flutter Database Example',
    initialRoute: 'scan',
    routes: {
      'scan':(context) => ScanPage(app: app,),
      'result' : (context) => ResultScreen(app: app,),
      'calendar': (context) => CalendarScreen()
    },
    
    
  ));
  
}

addTextile()async{
  FirebaseDatabase db = FirebaseDatabase.instance;
  Produit textile = Produit('Chemise à carreaux, style bucheron,','10.9');
  await db.reference().child('produits').child('3606744792996').set(<String,String>{
    "titre": textile.titre,
    "score": textile.score
  });
}
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({ Key key }) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.green,
      title: Text('Calendrier'),),
      body: Container(alignment: Alignment.center,
      child: Column(
        children: [
          Image.asset('assets/calendrier.png'),
          ElevatedButton(style: ElevatedButton.styleFrom(primary: Colors.green),
          onPressed: (){Navigator.pop(context);}, child: 
          Text('Retourner à la page d\'accueil'))
        ],
      ),),
      
    );
  }
}

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key key, this.app}) : super(key: key);

  

  @override
  _ResultScreenState createState() => _ResultScreenState();

  final FirebaseApp app;
  
}

class ScanPage extends StatefulWidget {
  const ScanPage({ Key key, this.app}) : super(key: key);

  final FirebaseApp app;

  @override
  _ScanPageState createState() => _ScanPageState();
}




class _ScanPageState extends State<ScanPage> {
  static String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(title: const Text('Page d\'accueil'),backgroundColor:Colors.green,),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RichText(text: TextSpan(text: 'Welcome \n',
                        style: DefaultTextStyle.of(context).style,
                        children: <InlineSpan> [
                          TextSpan(text: 'to \n',style: DefaultTextStyle.of(context).style),
                          TextSpan(text: 'GO2R \n', style: TextStyle(fontWeight: FontWeight.bold))

                        ] ,
                        )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget> [
                            IconButton(
                            onPressed: () async {
                              await scanBarcodeNormal();
                              Navigator.pushNamed(context, 'result');

                            },
                            icon: Image.asset('assets/barcode_icon.png'),
                            iconSize: 50,),

                            IconButton(onPressed: (){}, 
                            icon: Image.asset('assets/pine-tree.png'),
                            iconSize: 50,),

                            IconButton(onPressed: (){
                              Navigator.pushNamed(context, 'calendar');
                            }, 
                            icon: Image.asset('assets/plant.png'),
                            iconSize: 50,),


                          ],
                        ),
                        
                                                       
                        

                      ]
                      )
                    );
          }
            )
            );
  }
}


class _ResultScreenState extends State<ResultScreen> {
  Color score_color = Colors.green;
  

  Future<Map<String,dynamic>> getDataFromFirebase(String codeB) async {
    Completer<Map<String,dynamic>> completer = new Completer<Map<String,dynamic>>();
     

    final FirebaseDatabase database = FirebaseDatabase(app:widget.app);
    
    DatabaseReference produits_ref = database.reference().child('produits');
    
    
      
    dynamic valeur;    
    String titre = "";
    String score = "";
    Produit produit;   
   
    produits_ref.child(codeB).once().then((DataSnapshot snapshot){
    valeur = snapshot.value;    
    titre = valeur ['titre'];
    score = valeur['score'];
    produit = Produit(titre, score);
    completer.complete(produit.toJson());
   
    print('La valeur du score est ${score}');
    print('La valeur du titre est ${titre}');

    });  
    return completer.future;

  }

  
  String get_titre(Map<String,dynamic> json){
    String titre = json['titre'];
    return titre;
  }
  String get_score(Map<String,dynamic> json){
    String score = json['score'];
    return score;
  }

  String afficherJson(Map<String,dynamic> json){
    String str = "";
    json.forEach((key, value) { 
      if(key=='score'){
        str = str+key+': '+value+' kg CO2/kg de produit'+'\n';

      }
      else{
        str = str+key+': '+value+'\n';
      }
      
    });
    return str;
  } 

  @override
  Widget build(BuildContext context) {
    
    
    return Scaffold(appBar: AppBar(
      title: Text('Résultats du scan'),
      backgroundColor: Colors.green,
    ),
    body: Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        FutureBuilder<Map<String,dynamic>>(future: getDataFromFirebase(_ScanPageState._scanBarcode),
      builder: (context,snapshot){
      
      if(snapshot.hasError){
        return Text('There was an error');
      }
      else if (snapshot.hasData){
        String score = get_score(snapshot.data);
        double score_d = double.tryParse(score);

        String titre = get_titre(snapshot.data);

        if (score_d>4){
          
            score_color = Colors.red;
          

        }
        else{
          
            score_color = Colors.green;
          
        }
        
        return RichText(text: TextSpan(
          text: 'titre: ',
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(text: titre +'\n',style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: 'score: '),
            TextSpan(text: score, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: score_color)),
            TextSpan(text: ' kg CO2/kg produit')
            ]
          )
        );
      

      }
      else{
        return Text('No data yet');
      }
      
      
      

    }),
    ElevatedButton(style: ElevatedButton.styleFrom(primary: Colors.green),
    onPressed: (){Navigator.pop(context);}, child: 
    Text('Retourner à la page d\'accueil'))
      ],
      ),
    ),
    );
    
  }
}
