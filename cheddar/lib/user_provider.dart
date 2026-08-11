import 'package:string_to_icon/string_to_icon.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  //variables
  String username;
  String email;
  CollectionReference<Map<String, dynamic>>? budgetsRef;

  Budget curBudget = Budget.blank();

  UserProvider({
    this.username = 'Set Username',
    this.email = 'Set User Email',
  });


  void changeUserName({
    required String newUserName,
  }) async {
    username = newUserName;
    notifyListeners();
    FirebaseFirestore.instance.collection('users').doc(email)
    .set({
      "username" : newUserName
        }, SetOptions(merge: true));
  }
  void changeUserVar<T>(void Function(T) setter, T newValue, {required String varName, mergeOpt = true}) {

    FirebaseFirestore.instance.collection('users').doc(email)
    .set({
      varName : newValue
        }, SetOptions(merge: mergeOpt));
    notifyListeners();
    // Call the callback to update the actual class variable
    setter(newValue);
  }

  void changeBudgetVar<T>(void Function(T) setter, T newValue, {required String varName, required String date, mergeOpt = true}) {
    budgetsRef?.doc(date)
    .set({
      varName : newValue
        }, SetOptions(merge: mergeOpt));
    notifyListeners();
    // Call the callback to update the actual class variable
    setter(newValue);

  }

  void addCategory<T>({
    required String name, required double value, required Icon icon, required String iconName,required bool isInc, required String date, mergeOpt = true}) {
    if (isInc){
      
      
      //add name, value icon to inc arrays
      curBudget.inc.names.add(name);
      curBudget.inc.values.add(value);
      curBudget.inc.icons.add(icon);

      curBudget.inc.curValues.add(0);
      //add icon name 
      curBudget.inc.iconNames.add(iconName);
      
      //upadte database
      budgetsRef?.doc(date)
      .set({
        'incNames' : curBudget.inc.names,
        'incValues' : curBudget.inc.values,
        'incIconNames' : curBudget.inc.iconNames,
        'incCurValues' : curBudget.inc.curValues,

          }, SetOptions(merge: mergeOpt));

    }else{//exp
      curBudget.exp.names.add(name);
      curBudget.exp.values.add(value);
      curBudget.exp.icons.add(icon);

      curBudget.exp.curValues.add(0);
      //add icon name add it
      curBudget.exp.iconNames.add(iconName);
      
      //upadte database
      budgetsRef?.doc(date)
      .set({
        'expNames' : curBudget.exp.names,
        'expValues' : curBudget.exp.values,
        'expIconNames' : curBudget.exp.iconNames,
        'expCurValues' : curBudget.exp.curValues,

          }, SetOptions(merge: mergeOpt));

    }
    notifyListeners();
      
  }
  
  
  
  //used when you get email to grab all other assoicated data
  void loadDataFromEmail ({required String userEmail}) async {
    email = userEmail;// key for users data

    //username
    final usersDocRef = FirebaseFirestore.instance.collection('users').doc(email);
    final usersDocSnap = await usersDocRef.get();

    if (!usersDocSnap.exists){
      return;}

    Map<String, dynamic> data = usersDocSnap.data() as Map<String, dynamic>;
    username = data['username'];
    
    budgetsRef = usersDocRef.collection('Budgets');  
    //create a new collection "budgets" under your user in the user collection
    //is started when first data point is set in setBudgetData()
  
    //test
    //function that can be used later if we need to get any budget data
    setBudgetData(date: "August 2026"); 
    notifyListeners();  
  }

  Future<void> setBudgetData({required String date}) async{ 
    if (budgetsRef == null){
      return;
    }//idk if this is nessicary
  
    //check date is in right format?
    
    final docRef = budgetsRef?.doc(date);
    
    if (docRef != null){
      final docSnap = await docRef.get();
      
      if (docSnap.exists){
        curBudget  = loadBudget(snap: docSnap);
      } else {
        curBudget = createNewBudget(date: date);
      }
    }
    notifyListeners();  
  }

  Budget createNewBudget({required String date}){
    //set variables

    //exp
    List<String> expNames = ['Expense 1','Expense 2'];
    List<String> expIconNames = ['cancel', 'home'];
    List<double> expValues = [100, 50];
    List<double> expCurValues = [50, 10];

    //inc
    List<String> incNames = ['Income 1'];
    List<String> incIconNames = ['check'];
    List<double> incValues = [200];
    List<double> incCurValues = [100];

    //set database
    budgetsRef?.doc(date).set({'expNames': expNames}, SetOptions(merge: true));
    budgetsRef?.doc(date).set({'expIconNames': expIconNames}, SetOptions(merge: true));
    budgetsRef?.doc(date).set({'expValues': expValues}, SetOptions(merge: true));
    budgetsRef?.doc(date).set({'expCurValues': expCurValues}, SetOptions(merge: true));

    budgetsRef?.doc(date).set({'incNames': incNames}, SetOptions(merge: true));
    budgetsRef?.doc(date).set({'incIconNames': incIconNames}, SetOptions(merge: true));
    budgetsRef?.doc(date).set({'incValues': incValues}, SetOptions(merge: true));
    budgetsRef?.doc(date).set({'incCurValues': incCurValues}, SetOptions(merge: true));

    List<Icon> incIcons = stringsToIcons(stringList: incIconNames);
    List<Icon> expIcons= stringsToIcons(stringList: expIconNames);

    return Budget(    
    budgetDate: date,
      exp: Expenses(
        date: date,
        names: expNames,
        icons: expIcons,
        iconNames: expIconNames,
        values: expValues,
        curValues: expCurValues,

        ),
      inc: Incomes(
        date: date,
        names: incNames,
        icons: incIcons,
        iconNames: incIconNames,
        values: incValues,
        curValues: incCurValues,
        )
      );
  }

  Budget loadBudget({required DocumentSnapshot snap}){

    String date;

    List<String> expNames;
    List<String> expIconNames;
    List<double> expValues;
    List<double> expCurValues;

    //inc
    List<String> incNames;
    List<String> incIconNames;
    List<double> incValues;
    List<double> incCurValues;
    
    //load from database
    
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;

    date = snap.id;

    expNames = List<String>.from(data['expNames'] ?? []);
    expIconNames =  List<String>.from(data['expIconNames'] ?? []);
    expValues =  List<double>.from(data['expValues'] ?? []);
    expCurValues =  List<double>.from(data['expCurValues'] ?? []);

    incNames =  List<String>.from(data['incNames'] ?? []);
    incIconNames =  List<String>.from(data['incIconNames'] ?? []);
    incValues =  List<double>.from(data['incValues'] ?? []);
    incCurValues =  List<double>.from(data['incCurValues'] ?? []);

    //icon lists
    
    List<Icon> incIcons = stringsToIcons(stringList: incIconNames);
    List<Icon> expIcons= stringsToIcons(stringList: expIconNames);

    // for (int i = 0; i < expIconNames.length; i++){
    //   expIcons.add(Icon(IconMapper.getIconData(expIconNames[i])));
    // }

    return Budget(    
    budgetDate: date,
      exp: Expenses(
        date: date,
        names: expNames,
        icons: expIcons,
        iconNames: expIconNames,
        values: expValues,
        curValues: expCurValues,

        ),
      inc: Incomes(
        date: date,
        names: incNames,
        icons: incIcons,
        iconNames: incIconNames,
        values: incValues,
        curValues: incCurValues,
        )
      );
  }
  List<Icon> stringsToIcons({required List<String> stringList}){
    List<Icon> iconList = [];
    for (int i = 0; i < stringList.length; i++){
      print(stringList[i]);
      iconList.add(Icon(IconMapper.getIconData(stringList[i])));//TODO add monetization _on to map of strings to icons, for default value
    }

    return iconList;
   }  
}

class Budget {
  Budget({
    required this.budgetDate,
    required this.exp,
    required this.inc,
  });

  final String budgetDate;

  final Expenses exp;
  final Incomes inc;

  static Budget blank(){
    return Budget(
      budgetDate: 'null',
      exp: Expenses(date: 'null' , names: [], icons: [], iconNames: [],values: [], curValues: []),
      inc: Incomes(date: 'null' , names: [], icons: [], iconNames: [], values: [], curValues: [])
    );
    
  }
}

class Expenses {
  String date;
  List<String> names;
  List<Icon> icons;
  List<String> iconNames;
  List<double> values;
  List<double> curValues;

  Expenses({
    required this.date,
    required this.names,
    required this.icons,
    required this.iconNames,
    required this.values,
    required this.curValues,
  });
}

class Incomes {
  String date;
  List<String> names;
  List<Icon> icons;
  List<String> iconNames;
  List<double> values;
  List<double> curValues;

  Incomes({
    required this.date,
    required this.names,
    required this.icons,
    required this.iconNames,
    required this.values,
    required this.curValues,
  });
}