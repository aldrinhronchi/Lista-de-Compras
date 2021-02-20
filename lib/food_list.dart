import 'db/database_provider.dart';
import 'events/delete_food.dart';
import 'events/set_foods.dart';
import 'food_form.dart';
import 'model/food.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/food_bloc.dart';

class FoodList extends StatefulWidget {
  const FoodList({Key key}) : super(key: key);

  @override
  _FoodListState createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getFoods().then(
      (foodList) {
        BlocProvider.of<FoodBloc>(context).add(SetFoods(foodList));
      },
    );
  }

  showFoodDialog(BuildContext context, Food food, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(food.nome),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FoodForm(food: food, foodIndex: index),
              ),
            ),
            child: Text("Alterar"),
          ),
          FlatButton(
            onPressed: () => DatabaseProvider.db.delete(food.id).then((_) {
              BlocProvider.of<FoodBloc>(context).add(
                DeleteFood(index),
              );
              Navigator.pop(context);
            }),
            child: Text("Deletar"),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Voltar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Compras"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        color: Colors.grey,
        child: BlocConsumer<FoodBloc, List<Food>>(
          builder: (context, foodList) {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                print("foodList: $foodList");

                Food food = foodList[index];
                return Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(food.nome, style: TextStyle(fontSize: 26)),
                    subtitle: Text(
                      "Valor: ${food.valor}\ncomprado: ${food.comprado}",
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () => showFoodDialog(context, food, index),
                  ),
                );
              },
              itemCount: foodList.length,
            );
          },
          listener: (BuildContext context, foodList) {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => FoodForm()),
        ),
      ),
    );
  }
}
