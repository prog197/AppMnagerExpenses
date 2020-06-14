import 'package:expensesmanager/AddExpense.dart';
import 'package:expensesmanager/Choice.dart';
import 'package:expensesmanager/ExpensesModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:date_range_picker/date_range_picker.dart' as DRP;

void main() {
  runApp(ExpensesApp());
}

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses Manager',
      theme: ThemeData(
        brightness:Brightness.dark,
        primarySwatch: Colors.lime,
        primaryColor: Colors.lime,
        accentColor: Colors.lime,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Main Info'),
    );
  }
}

//class MyHomePage extends StatelessWidget {
//  final String title;
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}

class MyHomePage extends StatelessWidget  {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);
//  GlobalKey<ScaffoldState> _scaff = GlobalKey<ScaffoldState>();
//  static List<>

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ExpensesModel>(
      model: ExpensesModel(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: <Widget>[
              ScopedModelDescendant<ExpensesModel>(
                builder:(context, child, model) => PopupMenuButton<Choice>(
                  icon: Icon(Icons.menu),
                  onSelected: (res) async {
                    if (res.title == "Expenses for the period") {
                      final List<DateTime> picked = await DRP.showDatePicker(
                          context: context,
                          initialFirstDate: DateTime.now().add(Duration(days:-7)),
                          initialLastDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(3000));
                      if (picked != null) {
                        if (picked.length == 2)
                          model.LoadForPeriod(
                              new DateTime(picked[0].year, picked[0].month,
                                  picked[0].day),
                              new DateTime(picked[1].year, picked[1].month,
                                  picked[1].day)
                                  .add(Duration(days: 1)));
                        else
                          model.LoadForPeriod(
                              new DateTime(picked[0].year, picked[0].month,
                                  picked[0].day),
                              new DateTime(picked[0].year, picked[0].month,
                                  picked[0].day)
                                  .add(Duration(days: 1)));
                      }
//                      showDatePicker(
//                          context: context,
//                    initialDate: DateTime.now(),
//                    firstDate: DateTime(2000),
//                    lastDate: DateTime(3000));
                    }
                    else {
                      if (res.title == "All expenses"){
                      model.Load();
                    }}
                  },
                  itemBuilder: (context) {
                    return Choice.choices.map((Choice choice) {
                      return PopupMenuItem<Choice>(
                        value: choice,
                        child: ListTile(
                          title: Text(choice.title),
                          leading: Container(
                            color: Colors.lime,
                              child: Icon(choice.icon)),
                        )
                      );
                    }).toList();
                  },
                ),
              ),
            ]
          ),
          body: Stack(
            children:
            [Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: ScopedModelDescendant<ExpensesModel>(
                builder: (context, child, model) => Text(
                  "Expenses: " + model.GetSum().toString()+"",
                  style: TextStyle(
                    fontSize: 30,
                    height: 2,
                  ),
                ),
              ),
            ),
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: ScopedModelDescendant<ExpensesModel>(
                  builder: (context, child, model) => ListView.separated(
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Container(
                            height: 0.0,
                          );
                        } else {
                          index -= 1;
                          return Dismissible(
                              key: Key(model.GetKey(index)),
                              confirmDismiss: (DismissDirection direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Remove"),
                                      content: const Text("Do you want to delete this item?"),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () {
                                              model.RemoveAt(
                                                  index, int.tryParse(model.GetKey(index)));
                                              Navigator.of(context).pop();
                                              model.Load();
                                            },
                                            child: const Text("Yes")
                                        ),
                                        FlatButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: const Text("No"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onDismissed: (direction) {
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text("Delected record $index"))
                                );
                              },
                              child: ListTile(
                                title: Text(model.GetText(index)),
                                leading: Icon(Icons.attach_money),
                                trailing: Icon(Icons.delete),
                                onLongPress: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                      builder: (context){
                                    return AddExpense(model, index, "C");
                                  }));
                                },
                              )
                          );
                        }
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: model.recordsCount + 1
                  ),
                ),
              ),
          ]),
        floatingActionButton: ScopedModelDescendant<ExpensesModel>(
          builder: (context, child, model) => FloatingActionButton(
            onPressed:() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context){
                      return AddExpense(model, 0, "A");
                    }
                  )
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}