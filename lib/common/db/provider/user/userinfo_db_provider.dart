import 'package:flutter/foundation.dart';
import 'package:flutter_test_master/entity/User.dart';
import 'package:flutter_test_master/utils/code_utils.dart';
import 'package:sqflite/sqflite.dart';

import '../../sql_provider.dart';

/// userinfo_db_provider: 用户表
/// Created by Chen_Mr on 2019/6/17.

class UserInfoDbProvider extends BaseDbProvider{

  final String name = "UserInfo";

  final String columnId = "_id";
  final String columnUserName = "userName";
  final String columnData = "data";

  int id;
  String userName;
  String data;


  UserInfoDbProvider();

  Map<String,dynamic> toMap(String userName,String data) {
    Map<String, dynamic> map = {columnUserName: userName, columnData: data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  UserInfoDbProvider.fromMap(Map map) {
    id = map[columnId];
    userName = map[columnUserName];
    data = map[columnData];
  }

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        ''' 
        $columnUserName text not null,
        $columnData text not null)
        ''';
  }

  Future _getUserProvider(Database db, String userName) async {
    List<Map<String, dynamic>> maps =
    await db.query(name, columns: [columnId, columnUserName, columnData], where: "$columnUserName = ?", whereArgs: [userName]);
    if (maps.length > 0) {
      UserInfoDbProvider provider = UserInfoDbProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  ///插入到数据库
  Future insert(String userName, String eventMapString) async {
    Database db = await getDataBase();
    var userProvider = await _getUserProvider(db, userName);
    if (userProvider != null) {
      await db.delete(name, where: "$columnUserName = ?", whereArgs: [userName]);
    }
    return await db.insert(name, toMap(userName, eventMapString));
  }

  ///获取事件数据
  Future<User> getUserInfo(String userName) async {
    Database db = await getDataBase();
    var userProvider = await _getUserProvider(db, userName);
    if (userProvider != null) {


      ///使用 compute 的 Isolate 优化 json decode
      var mapData = await compute(CodeUtils.decodeMapResult, userProvider.data as String);
      return User.fromJson(mapData);
    }
    return null;
  }
}