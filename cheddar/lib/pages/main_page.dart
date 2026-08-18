
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:cheddar/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cheddar/user_provider.dart';

import 'package:cheddar/pages/account_page.dart';
import 'package:cheddar/pages/budget_page.dart';
import 'package:cheddar/pages/transaction_page.dart';
import 'package:cheddar/pages/home_page.dart';
import 'package:cheddar/ui_elements.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});
  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  final User? user = Auth().currentUser;

  late Future<Scaffold> isloaded;


  int myIndex = 0;
  List<Widget> pages = [
    HomePage(),
    TransactionPage(),  
    BudgetPage(),
    AccountPage(),
  ];
  //load user data

  Future<Scaffold> loadData ()async{
    //function using email as key to load the rest of UserProviders data

    await context.read<UserProvider>().loadDataFromEmail(userEmail: user?.email ?? 'email not found');
    
    
    return Scaffold();
  }

  @override
  void initState(){
    super.initState();
    isloaded = loadData();
  }

  @override
  Widget build(BuildContext context){
    
    return FutureBuilder<Scaffold>(
      future: isloaded,
      builder:(context,snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          return MyLoadingScreen();
        }else{
          return Scaffold(
            body: IndexedStack(
              index: myIndex,
              children: pages,
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
    );

  }
}