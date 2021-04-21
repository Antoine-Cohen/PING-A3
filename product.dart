import 'dart:convert';

class Product{
  String title;
  String codeB;
  double score;

  Product({this.title,
  this.codeB,
  this.score});


factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

String toRawJson() => json.encode(toJson());

factory Product.fromJson(Map<String,dynamic> json) => Product(title: json["_title"],
  codeB: json["_codeB"],
  score: json["_score"],
);

Map<String,dynamic> toJson() => {
  "_title":title,
  "_codeB":codeB,
  "_score":score
};



}
