

import 'package:sqflite/sqflite.dart';
import 'package:zhushanApp/modules/CacheDataModules.dart';

class CacheHelp{
  Database db;
  final tableName='cache';
  CacheHelp(Database db){
    this.db=db;
  }
  Future<void> insert(cache cache) async {
    await db.insert(
      tableName,
      cache.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<cache>> caches(int id,String cacheName) async {
    final List<Map<String, dynamic>> maps = await db.query(
        tableName,
        columns: ['id', 'name', 'data','LastEditDateTime'],
        where: "id = ? AND name LIKE ?",
        whereArgs: [id,cacheName]);
    return List.generate(maps.length, (i) {
      return cache(
        id: maps[i]['id'],
        name: maps[i]['name'],
        data: maps[i]['data'],
        LastEditDateTime: maps[i]['LastEditDateTime'],
      );
    });
  }
  Future<void> update(cache cache) async {
    await db.update(
      tableName,
      cache.toMap(),
      where: "id = ? AND name LIKE ?",
      whereArgs: [cache.id,cache.name],
    );
  }
  Future<void> delete(cache cache) async {
    await db.delete(
      tableName,
      where: "id = ? AND name LIKE ?",
      whereArgs: [cache.id,cache.name],
    );
  }
}