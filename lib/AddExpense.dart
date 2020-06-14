import 'package:expensesmanager/ExpensesModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _AddExpenseState extends State<AddExpense> {
  double _price;
  String _name;
  String _date;
  ExpensesModel _model;
  int _id;
  String _flag;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _AddExpenseState(this._model, this._id, this._flag);

  @override
  Widget build(BuildContext context) {
    if(_flag == "A") {
      _price = 0;
      _name =  "";
      _date = DateTime.now().toString();
    }
    if(_flag == "C") {
      _price = double.tryParse(_model.GetPrice(_id));
      _name =  _model.GetName(_id);
      _date = _model.GetDate(_id);
    }
    return Scaffold(
        appBar: AppBar(title: Text("Expense")),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
              key: _formKey,
              child: Column(
                  children: [
                    Column(
                      children: <Widget>[
                        Text("Price",
                          style: TextStyle(
                            fontSize: 20,
                          ),),
                        TextFormField(
                          autovalidate: true,
                          initialValue: _price.toString(),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (double.tryParse(value) != null) {
                              return null;
                            } else {
                              return "Enter the valid price";
                            }
                          },
                          onSaved: (value) {
                            _price = double.tryParse(value);
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text("\nName",
                        style: TextStyle(
                          fontSize: 20,
                        ),),
                        TextFormField(
                          initialValue: _name,
                          onSaved: (value){
                            _name = value;
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text("\nDate", style: TextStyle(
                          fontSize: 20,
                        )),
                        TextFormField(
                          initialValue: _date,
                          onSaved: (value){
                            _date = value;
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35.0),
                      child: RaisedButton(
                        onPressed: (){
                          if (_formKey.currentState.validate()){
                            _formKey.currentState.save();
                            if(_flag == "A") _model.AddExpense(_name, _price, _date);
                            if(_flag == "C") _model.ChangeExpense(_id, _name, _price, _date);
                            Navigator.pop(context);
                          }
                        },
                        child: Text("Save", style: TextStyle(color: Colors.black),)
                      ),
                    )
                  ]
              )
          ),
        )
    );
  }
}

class AddExpense extends StatefulWidget{
  final ExpensesModel _model;
  final int _id;
  final String _flag;
  AddExpense(this._model, this._id, this._flag);

  @override
  State<StatefulWidget> createState() => _AddExpenseState(_model, _id, _flag);
}