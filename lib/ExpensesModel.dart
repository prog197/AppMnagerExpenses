import 'package:expensesmanager/ExpenseDB.dart';
import 'package:expensesmanager/Expense.dart';
import 'package:scoped_model/scoped_model.dart';

class ExpensesModel extends Model{
  List<Expense> _items = [];
  ExpenseDB _database;
  double _sum;

  int get recordsCount => _items.length;

  ExpensesModel(){
    _database = ExpenseDB();
    Load();
  }

  void Load(){
    Future<List<Expense>> future = _database.getAllExpenses();
    future.then((list){
      _items = list;
      notifyListeners();
    });

    Future<double> f1 = _database.getSumExpenses();
    f1.then((value) {
      _sum = value;
      notifyListeners();
    });
  }

  void LoadForPeriod(DateTime first, DateTime last){
    Future<List> future = _database.getPartExpenses(first, last);
    future.then((list){
      _items = list[0];
      _sum = list[1];
      notifyListeners();
  });
  }

  double GetSum(){
    return _sum;
  }

  String GetKey(int index){
    return _items[index].id.toString();
  }

  String GetText(int index){
    var e = _items[index];
    return e.name + " for " +
        e.price.toString() + "\n" +
        e.date.toString();
  }

  String GetName(int index){
    var e = _items[index];
    return e.name;
  }

  String GetPrice(int index){
    var e = _items[index];
    return e.price.toString();
  }

  String GetDate(int index){
    var e = _items[index];
    return e.date.toString();
  }

  void RemoveAt(int index, int id){
    Future<void> future = _database.deleteExpense(id);
    future.then((_) {
      _items.removeAt(index);
      notifyListeners();
    });
  }

  void AddExpense(String name, double price, String date){
    Future<void> future = _database.addExpense(name, price, date);
    future.then((_){
      Load();
    });
  }

  void ChangeExpense(int id, String name, double price, String date){
    Future<void> future = _database.updateExpense(int.tryParse(GetKey(id)), name, price, date);
    future.then((_) {
      Load();
    });
  }

//  void PlanningExpense(String name, double cost){
//    Future<void> future = _database.planExpense(name, cost);
//    future.then((_){
//      Load();
//    });
//  }
}
