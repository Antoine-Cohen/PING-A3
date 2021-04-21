import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_test/database_helper.dart';
import 'database_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Example of database",
      home: Homescreen(),
    );
  }
}

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  
   DatabaseHelper dbH = new DatabaseHelper();
   Database db = DatabaseHelper.getdb();
  @override
 
  

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              MaterialButton(
                child: Text("Press Me"),
                onPressed: () {
                  dbH.init();
                },
              ),
            MaterialButton(child: Text("query all"),onPressed: ()async {
              List<Map<String,dynamic>> queryrows= await dbH.getAllTheProducts();
              print(queryrows);
            },)],
          ),
        ),
        alignment: Alignment.center,
      ),
      appBar: AppBar(
        title: Text("Database implementation"),
      ),
    );
  }
}
