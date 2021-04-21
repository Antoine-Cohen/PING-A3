import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import'dart:io' as io;



class DatabaseHelper{
  static Database _db;
  static final _tablename="produit";

  Future<void> init() async{
    try{
      io.Directory applicationDirectory= await getApplicationDocumentsDirectory();
      if(applicationDirectory.path==null){
        throw MissingPlatformDirectoryException('Unable to access application directory');
      }
      print(applicationDirectory.path);
      String dbPathProduct=path.join(applicationDirectory.path,"scannedProducts.db");

      bool dbExistsProducts= await io.File(dbPathProduct).exists();

      if(!dbExistsProducts){
      // Copy from asset
      ByteData data=await rootBundle.load(path.join("assets","produits.db"));
      List<int> bytes=data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      
      await io.File(dbPathProduct).writeAsBytes(bytes,flush: true);
      print("db copied");
    }
    print("Open database");

    await deleteDatabase(dbPathProduct);
    _db= await openDatabase(dbPathProduct);

    }catch(err){
      print(err);
    }
    
    

    

    
  }
  static Database getdb(){
      return _db;
    }

  Future<List<Map<String,dynamic>>> getAllTheProducts() async{
    return await _db.query(_tablename);
  }
}