import 'bloc/food_bloc.dart';
import 'db/database_provider.dart';
import 'events/add_food.dart';
import 'events/update_food.dart';
import 'model/food.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodForm extends StatefulWidget {
  final Food food;
  final int foodIndex;

  FoodForm({this.food, this.foodIndex});

  @override
  State<StatefulWidget> createState() {
    return FoodFormState();
  }
}

class FoodFormState extends State<FoodForm> {
  String _nome;
  String _valor;
  bool _comprado = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildNome() {
    return TextFormField(
      initialValue: _nome,
      decoration: InputDecoration(labelText: 'Nome'),
      maxLength: 15,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Nome não pode ser vazio';
        }

        return null;
      },
      onSaved: (String value) {
        _nome = value;
      },
    );
  }

  Widget _buildValor() {
    return TextFormField(
      initialValue: _valor,
      decoration: InputDecoration(labelText: 'Valor'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        int valor = int.tryParse(value);

        if (valor == null || valor <= 0) {
          return 'Valor deve ser maior que  0';
        }

        return null;
      },
      onSaved: (String value) {
        _valor = value;
      },
    );
  }

  Widget _buidComprado() {
    return SwitchListTile(
      title: Text("Comprado?", style: TextStyle(fontSize: 20)),
      value: _comprado,
      onChanged: (bool newValue) => setState(() {
        _comprado = newValue;
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.food != null) {
      _nome = widget.food.nome;
      _valor = widget.food.valor;
      _comprado = widget.food.comprado;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Compras")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildNome(),
              _buildValor(),
              SizedBox(height: 16),
              _buidComprado(),
              SizedBox(height: 20),
              widget.food == null
                  ? RaisedButton(
                      child: Text(
                        'Proximo',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }

                        _formKey.currentState.save();

                        Food food = Food(
                          nome: _nome,
                          valor: _valor,
                          comprado: _comprado,
                        );

                        DatabaseProvider.db.insert(food).then(
                              (storedFood) =>
                                  BlocProvider.of<FoodBloc>(context).add(
                                AddFood(storedFood),
                              ),
                            );

                        Navigator.pop(context);
                      },
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            "Atualizar",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              print("form");
                              return;
                            }

                            _formKey.currentState.save();

                            Food food = Food(
                              nome: _nome,
                              valor: _valor,
                              comprado: _comprado,
                            );

                            DatabaseProvider.db.update(widget.food).then(
                                  (storedFood) =>
                                      BlocProvider.of<FoodBloc>(context).add(
                                    UpdateFood(widget.foodIndex, food),
                                  ),
                                );

                            Navigator.pop(context);
                          },
                        ),
                        RaisedButton(
                          child: Text(
                            "Cancelar",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
