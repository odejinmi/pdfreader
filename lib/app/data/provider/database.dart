import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';



Future<String> pathstring() async {
  final Directory databasesPath = await getApplicationDocumentsDirectory();
  return join(databasesPath.path, "pdfreader_database.db");
}
Future<Database> Databasequary() async {
  var path = await pathstring();
  print("database path $path");
  var databaseFactory = databaseFactoryFfi;
    final database = await databaseFactory.openDatabase(path,options: OpenDatabaseOptions(
         version: 1,onCreate: (database, version){

       database.execute(
        'CREATE TABLE document(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, path TEXT, name TEXT, type TEXT, '
            'current INTEGER, currentpage INTEGER DEFAULT "0", favourite INTEGER DEFAULT "0", '
            'filesized TEXT, datecreated TEXT)',
      );
      //  database.execute(
      //   'CREATE TABLE bettings(name TEXT, code TEXT, id TEXT)',
      // );
      //  database.execute(
      //   'CREATE TABLE electricitys(name TEXT, code TEXT, id TEXT)',
      // );
      // database.execute(
      //   'CREATE TABLE datas(id INTEGER, name TEXT, coded TEXT, price TEXT, network TEXT, category TEXT,  status INTEGER)',
      // );
      //  database.execute(
      //   'CREATE TABLE tvs(id INTEGER  , name TEXT, coded TEXT, price TEXT, type TEXT, status INTEGER)',
      // );
    }));
  return database;
}

// Define a function that inserts dogs into the database
Future<void> insertContact(dog, dogs) async {
  // Get a reference to the database.
  final db = await Databasequary();

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    dogs,
    dog.toJson(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// A method that retrieves specific the dogs from the dogs table.
Future<List> fetchspecificContact(
    String condition, List number, String dogs) async {
  // Get a reference to the database.
  final db = await Databasequary();

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query(
    dogs,
    // Ensure that the Dog has a matching id.
    where: condition,
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: number,
  );

  return maps;
}

// A method that retrieves specific the dogs from the dogs table.
Future<List> fetchdistintContact(
    String tablename, String columns) async {
  // Get a reference to the database.
  final db = await Databasequary();

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.rawQuery(
   "SELECT DISTINCT $tablename FROM $columns"
  );

  return maps;
}

// A method that retrieves all the dogs from the dogs table.
Future<List> fetchallContact(tablename) async {
  // Get a reference to the database.
  final db = await Databasequary();

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query(tablename);

  return maps;
} // A method that retrieves all the dogs from the dogs table.

Future<void> insertsingleContact(tablename, columns, values) async {
  // Get a reference to the database.
  final db = await Databasequary();

  // await db.rawInsert('INSERT INTO my_table(name, age) VALUES($name, $age)');
  await db.rawInsert('INSERT INTO $tablename $columns VALUES$values');
}

Future<void> updateContact(dog) async {
  // Get a reference to the database.
  final db = await Databasequary();

  // Update the given Dog.
  await db.update(
    'document',
    dog.toJson(),
    // Ensure that the Dog has a matching id.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [dog.id],
  );
}

Future<void> deleteContact(dog) async {
  // Get a reference to the database.
  final db = await Databasequary();

  // Update the given Dog.
  await db.delete(
    'document',
    // Ensure that the Dog has a matching id.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [dog.id],
  );
}

// Future<void> emptyContact(dog) async {
//   // Get a reference to the database.
//   var databasesPath = await getDatabasesPath();
//   var path = join(databasesPath, "mcd_database.db");
//   if (await databaseExists(path)) {
//     final db = await Databasequary();
//     // Delete the given Table.
//     await db.rawQuery("delete from $dog");
//   }
// }

// Future<void> deletedatabase() async {
//   // Get a reference to the database.
//   var databasesPath = await getDatabasesPath();
//   var path = join(databasesPath, "mcd_database.db");
//   if (await databaseExists(path)) {
//     final db = await Databasequary();
// // delete existing if any
//     await deleteDatabase(path);
//   }
// }

Future<void> deletedatabase() async {
  // Get a reference to the database.
  // var databasesPath = await getDatabasesPath();

  var path = await pathstring();
  if (File(path).exists() == true) {
    File(path).delete();
    // final db = await Databasequary();
// delete existing if any
//     await deleteDatabase(path);
  }
}

Future<void> deletetable(tablename) async {
  final db = await Databasequary();
  await db.execute("DROP TABLE IF EXISTS $tablename");
}
Future<void> emptytable(tablename) async {
  final db = await Databasequary();
  var list = await fetchallContact(tablename);
  if (list.isNotEmpty) {
    await db.execute("DELETE FROM $tablename");
  }
}
