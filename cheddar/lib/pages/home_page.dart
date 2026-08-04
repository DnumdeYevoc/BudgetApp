import 'package:flutter/material.dart';
import 'package:cheddar/ui_elements.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return 
        MyPieChart(
          innerData: [1000,100],
          innerName: 'Income',
          innerNameData: ['Paycheque','Birthday Money'],
          innerIconData: [
            Icon(Icons.monetization_on_outlined),
            Icon(Icons.celebration)],

          outerData: [100,500],
          outerName: 'Expenses',
          outerNameData: ['Groceries', 'Rent'],
          outerIconData: [
            Icon(Icons.fastfood_outlined),
            Icon(Icons.home),
            ],

          radius: 9,
        );    
  }
}