import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  final String _habitTrackerTable = 'HabitsTracker';
  final String _dateHabitTable = 'DateHabit';

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/habits_tracker.db';

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_habitTrackerTable(
    id INTEGER PRIMARY KEY,
    ChallengeName TEXT,
    Category TEXT,
    DateTime TEXT);
    ''');

    await db.execute('''
    CREATE TABLE $_dateHabitTable(
    DateTime TEXT,
    id INTEGER,
    Success INTEGER,
    FOREIGN KEY (id) REFERENCES HabitsTracker(id)
    );
    ''');
  }

  //HabitTrackerTable
  //Part 1
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;

    return await db.insert(_habitTrackerTable, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;

    return await db.query(_habitTrackerTable);
  }

  Future update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int rowId = row['id'];
    return await db
        .update(_habitTrackerTable, row, where: 'id = ?', whereArgs: [rowId]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;

    return await db
        .delete(_habitTrackerTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> fetchData(String columnName) async {
    Database db = await instance.database;
    return await db.rawQuery('''
    SELECT id FROM HabitsTracker WHERE ChallengeName = '$columnName';
    ''');
  }

  //DateHabitTableHelper
  //Part 2
  Future<int> insertDateHabit(Map<String, dynamic> row) async {
    Database db = await instance.database;

    return await db.insert(_dateHabitTable, row);
  }

  Future<List<Map<String, dynamic>>> queryAllDateHabit() async {
    Database db = await instance.database;

    return await db.query(_dateHabitTable);
  }

  Future updateDateHabit(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int rowId = row['id'];
    return await db
        .update(_dateHabitTable, row, where: 'id = ?', whereArgs: [rowId]);
  }

  Future<int> deleteDateHabit(int id) async {
    Database db = await instance.database;

    return await db.delete(_dateHabitTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> fetchRowFromDateHabitWhereDateTime(
      String dateTime) async {
    Database db = await instance.database;
    return await db.rawQuery('''
    SELECT HabitsTracker.id,HabitsTracker.ChallengeName,HabitsTracker.Category,DateHabit.DateTime,DateHabit.Success  
    FROM HabitsTracker INNER JOIN DateHabit ON DateHabit.id = HabitsTracker.id 
    WHERE DateHabit.DateTime = '$dateTime';
    ''');
  }

  Future<List<Map<String, dynamic>>> updateSuccessHabitDate(
      int id, String date, int success) async {
    Database db = await instance.database;
    return await db.rawQuery('''
    UPDATE DateHabit SET Success = $success WHERE id = $id and DateTime = '$date';
    ''');
  }

  Future<List<dynamic>> countSuccessOneByOne(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> success = await db.rawQuery(
        '''SELECT count() as 'Success' FROM DateHabit WHERE id = $id AND Success = 1;''');
    List<Map<String, dynamic>> unSuccess = await db.rawQuery(
        '''SELECT count() as 'UnSuccess' FROM DateHabit WHERE id = $id AND Success = 0;''');
    List list = [success[0], unSuccess[0]];
    return list;
  }

  Future<List<dynamic>> fetchAllByGroup() async {
    Database db = await instance.database;
    int i = 0;
    List returnList = [];
    List a = [];
    List<Map<String, dynamic>> list = await db.rawQuery('''
  SELECT 
  HabitsTracker.id,
  HabitsTracker.ChallengeName
  FROM HabitsTracker INNER JOIN DateHabit ON DateHabit.id = HabitsTracker.id GROUP BY DateHabit.id;  
    ''');

    List<dynamic> successList = [];

    for (var data in list) {
      successList = await countSuccessOneByOne(data['id']);

      returnList.add([data, successList[0], successList[1]]);
    }

    //print(returnList);
    return returnList;
  }
}
