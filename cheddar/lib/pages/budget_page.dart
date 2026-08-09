import 'package:flutter/material.dart';
import 'package:cheddar/ui_elements.dart';
import 'package:provider/provider.dart';
import 'package:cheddar/user_provider.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  
  @override
  Widget build(BuildContext context) {
    final Budget budget = context.watch<UserProvider>().curBudget;
    return Scaffold(//add floating button
      floatingActionButton: FloatingActionButton(onPressed:(){///METHOD TO EDIT BUDGETS LETS GO //JUST NEED TO ADD ALL THE LOGIC AND UI FOR IT
        context.read<UserProvider>().changeBudgetVar<List<String>>(
        (val)=> context.read<UserProvider>().curBudget.exp.names = val,
        ['beer','rent'],
        date: '08_2026',
        varName: 'expNames');
        }
        ),
      body: MyPieChart(
              innerData: budget.inc.curValues,
              innerName: 'Income',
              innerNameData: budget.inc.names,
              innerIconData: budget.inc.icons,
              outerData: budget.exp.curValues,
              outerName: 'Expenses',
              outerNameData: budget.exp.names,
              outerIconData: budget.exp.icons,
              radius: 8,
            ),
    );
  }
}