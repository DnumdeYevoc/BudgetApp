import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:cheddar/auth.dart';
import 'package:flutter/material.dart';
import 'package:cheddar/pages/account_page.dart';
import 'package:cheddar/pages/budget_page.dart';
import 'package:cheddar/pages/transaction_page.dart';
import 'package:cheddar/pages/home_page.dart';

class Mainpage extends StatefulWidget {
  Mainpage({Key? key}) : super(key: key);
  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  final User? user = Auth().currentUser;

  int myIndex = 0;
  List<Widget> pages = [
    HomePage(),
    TransactionPage(),  
    BudgetPage(),
    AccountPage(),
  ];
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: pages[myIndex],

      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (value){
          setState(() {
            myIndex = value;
          });
        },
        currentIndex: myIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: 'Transactions',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Budget',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
            
          ),
        ],
      ),
    );
  }
}