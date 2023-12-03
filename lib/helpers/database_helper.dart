import 'dart:async';
import 'dart:io';
import 'package:contact_with_sqlite/models/contact.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static late DatabaseHelper _databaseHelper;
  static late Database _database;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper = DatabaseHelper._createInstance();
    return _databaseHelper;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}contacts.db';

    var contactsDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return contactsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    String sql = 'CREATE TABLE contacts ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'name TEXT,'
        'email TEXT,'
        'image TEXT'
        ')';
    await db.execute(sql);
  }

  Future<Database> get database async {
    _database = await initializeDatabase();
    return _database;
  }

  Future<int> insertContact(Contact contact) async {
    Database db = await database;
    var result = await db.insert('contacts', contact.toMap());
    return result;
  }

  Future<int> updateContact(Contact contact) async {
    var db = await database;

    var result = await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );

    return result;
  }

  Future<int> deleteContact(int id) async{
    var db = await database;

    int result = await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );

    return result;
  }

  Future<int> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.query('SELECT COUNT(*) FROM contacts');
    int result = Sqflite.firstIntValue(x)!.toInt();
    return result;
  }

  Future<Contact?> getContact(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(
      'contacts',
      columns: ['id', 'name', 'email', 'image'],
      where: 'id =3',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Contact>> getContacts() async {
    Database db = await database;
    var result = await db.query('contacts');
    List<Contact> list =
        result.isNotEmpty ? result.map((e) => Contact.fromMap(e)).toList() : [];
    return list;
  }

  Future close() async {
    Database db = await database;
    db.close();
  }
}
