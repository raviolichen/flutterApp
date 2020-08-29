import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class SQlitHelp{
  static Database db;
  static Future<void> initdb(String dbpath) async {
    db =await openDatabase( join(dbpath, 'cache_database.db'), version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              "CREATE TABLE cache(id INTEGER ,name TEXY, data TEXT, LastEditDateTime TEXT )");
        });
  }
  static Future<Database> getdb(String path)async{
    if(db==null)
       await initdb(path);
    return db;
  }
}