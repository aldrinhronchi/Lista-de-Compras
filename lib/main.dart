import 'food_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/food_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FoodBloc>(
      create: (context) => FoodBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lista De Compras ',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: FoodList(),
      ),
    );
  }
}
