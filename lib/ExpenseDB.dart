import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:expensesmanager/Expense.dart';

class ExpenseDB{
  Database _database;

  Future<Database> get database async{
    if (_database == null){
        _database = await initialize();
      }
    return _database;
  }

  ExpenseDB() {}

  initialize() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    var path = Path.join(documentsDir.path, "db.db");
    return openDatabase(
        path,
        version: 1,
        onOpen: (db) {},
        onCreate: (db, version) async {
          await db.execute("CREATE TABLE Expenses (id INTEGER PRIMARY KEY AUTOINCREMENT, price REAL, date TEXT, name TEXT)");
        }
    );
  }

  Future<List<Expense>> getAllExpenses() async {
    Database db = await database;
    List<Map> query = await db.rawQuery("SELECT * FROM Expenses ORDER BY date DESC");
    var result = List<Expense>();
    query.forEach((r) => result.add(Expense(r["id"], DateTime.parse(r["date"]), r["name"], r["price"])));
    return result;
  }

  Future<void> addExpense(String name, double price, String dateTime) async{
    Database db = await database;
//    var dateAsString = dateTime.toString();
    await db.rawInsert("INSERT INTO Expenses (name, date, price) VALUES (\"$name\", \"$dateTime\", $price)");
  }

  Future<double> getSumExpenses() async{
    Database db = await database;
    var sum;
    List<Map> query = await db.rawQuery("SELECT ifnull(SUM(price), 0.0) as s FROM Expenses");
    query.forEach((r){
      sum = double.tryParse(r["s"].toString());
    });
    return sum;
  }

  Future<void> deleteExpense(int ind) async {
    Database db = await database;
    await db.rawDelete("DELETE FROM Expenses WHERE id = $ind");
  }

  Future<void> updateExpense(int id, String name, double price, String dateTime) async {
    Database db = await database;
//    var dateAsString = dateTime.toString();
    await db.rawUpdate("UPDATE Expenses SET name = \"$name\", date = \"$dateTime\", price = $price WHERE id = $id");
  }

  Future<List> getPartExpenses(DateTime first, DateTime last) async {
    Database db = await database;
    List<Map> query = await db.rawQuery(
        "SELECT * FROM Expenses WHERE date >= \"$first\" AND date < \"$last\" ORDER BY date DESC");
    var data = List<Expense>();

    var total = 0.0;
    query.forEach((r) {
      data.add(Expense(r["id"], DateTime.parse(r["date"]), r["name"], r["price"]));
      total += double.tryParse(r["price"].toString());
    });

    return [data, total];
  }

//  Future<void> planExpense(String name, double cost) async{
//    Database db = await database;
//    await db.rawInsert("INSERT INTO Plan (name, cost) VALUES (\"$name\", $cost)");
//  }
}