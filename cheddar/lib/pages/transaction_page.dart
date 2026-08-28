import 'package:cheddar/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:cheddar/ui_elements.dart';
import 'package:provider/provider.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  


  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  Future<void> loadTransactions(BuildContext context) async {
    List Transactions = await context.read<UserProvider>().loadTransactions(budget: 'Budget 2', cat: 'Food');/
    
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
         loadTransactions(context);
      }),
      body: MyTransactionList(
        budgets: ['null', 'poop'],
        categories: ['Rent', 'beer'],
        names: ['MCDONALDS#2467','BURGERKING#00929838'],
        oneCategory: false,
        categoryName: 'beer',
        values: [100.67, -189302.08],
      
      ),
    );
    
  }
}