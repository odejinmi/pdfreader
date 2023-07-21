// To parse this JSON data, do
//
//     final datamodel = datamodelFromJson(jsonString);

import 'dart:convert';

List<Datamodel> datamodelFromJson(String str) =>
    List<Datamodel>.from(json.decode(str).map((x) => Datamodel.fromJson(x)));

String datamodelToJson(List<Datamodel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Datamodel {
  Datamodel({
    this.id,
    this.path,
    this.type,
    this.name,
    this.current,
    this.currentpage = 0,
    this.favourite = 0,
    this.datecreated,
    this.filesized,
    this.totalpage,
  });

  var id;
  var path;
  var name;
  var type;
  var current;
  var currentpage ;
  var favourite;
  var datecreated;
  var filesized;
  var totalpage;

  factory Datamodel.fromJson(Map<String, dynamic> json) => Datamodel(
        id: json["id"],
        name: json["name"],
        path: json["path"],
        type: json["type"],
        current: json["current"],
        currentpage: json["currentpage"],
        favourite: json["favourite"],
        datecreated: json["datecreated"],
        filesized: json["filesized"],
        totalpage: json["totalpage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "path": path,
        "name": name,
        "type": type,
        "current": current,
        "currentpage": currentpage,
        "favourite": favourite,
        "datecreated": datecreated,
        "filesized": filesized,
        "totalpage": totalpage,
      };

  toString() => ' "id": $id, '
      '"path": $path, '
      '"type": $type, '
      '"name": $name, '
      '"current": $current, '
      '"currentpage": $currentpage,'
      '"favourite": $favourite,'
      '"datecreated": $datecreated,'
      '"totalpage": $totalpage,'
      '"filesized": $filesized,';


}
