import 'package:flutter/material.dart';
import 'package:cheddar/ui_elements.dart';
import 'package:provider/provider.dart';
import 'package:cheddar/user_provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final Budget budget = context.watch<UserProvider>().curBudget;
    
    return Scaffold(
      body: MyPieChart(
              innerData: budget.inc.curValues,
              innerName: 'Income',
              innerNameData: budget.inc.names,
              innerIconData: budget.inc.icons,
              outerData: budget.exp.curValues,
              outerName: 'Expenses',
              outerNameData: budget.exp.names,
              outerIconData: budget.exp.icons,
              radius: 10,
            ),
      
    );
        }
      
  
  
}