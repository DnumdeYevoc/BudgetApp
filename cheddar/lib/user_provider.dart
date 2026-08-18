import 'package:string_to_icon/string_to_icon.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  //variables
  String username;
  String email;
  CollectionReference<Map<String, dynamic>>? budgetsRef;

  Budget curBudget = Budget.blank();
  List<String> budgetNames = [];
  int budgetIndex = -1;

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
    
    // Call the callback to update the actual class variable
    setter(newValue);
    notifyListeners();
  }

  void changeBudgetVar<T>(void Function(T) setter, T newValue, {required String varName, required String date, mergeOpt = true}) {
    budgetsRef?.doc(date)
    .set({
      varName : newValue
        }, SetOptions(merge: mergeOpt));
    notifyListeners();
    // Call the callback to update the actual class variable
    setter(newValue);//TODO change to work with the arrays
  }
  Future<void> changeBudgetArrayVar<T>(
  Future<List<T>> Function(List<T> currentList) duper,
  List<T> currentList,
  Future<void> Function(List<T> newList) setter,{
  required String varName,
  required T newVar,
  required int index,
  required String date,
  bool mergeOpt = true,
  bool firebaseSave= true,
}) async {
  final updatedList = await duper(currentList);

  // IMPORTANT: replace the field, do not mutate the old list
  setter(updatedList); // or whichever list you are watching
  if(firebaseSave){
    await budgetsRef?.doc(date).set(
      {varName: updatedList},
      SetOptions(merge: mergeOpt),
    );
  }
  notifyListeners();
  }
 
  void deleteCategory({required  int index, required bool isInc,required String date, mergeOpt = true }){
    if (isInc){
      // add name, value, icon, and icon name to new arrays before removing so we don't mutate the original list in place
      final incNames = List<String>.from(curBudget.inc.names)..removeAt(index);
      final incValues = List<double>.from(curBudget.inc.values)..removeAt(index);
      final incIcons = List<Icon>.from(curBudget.inc.icons)..removeAt(index);
      final incCurValues = List<double>.from(curBudget.inc.curValues)..removeAt(index);
      final incIconNames = List<String>.from(curBudget.inc.iconNames)..removeAt(index);

      curBudget.inc.names = incNames;
      curBudget.inc.values = incValues;
      curBudget.inc.icons = incIcons;
      curBudget.inc.curValues = incCurValues;
      curBudget.inc.iconNames = incIconNames;
      
      //upadte database
      budgetsRef?.doc(date)
      .set({
        'incNames' : curBudget.inc.names,
        'incValues' : curBudget.inc.values,
        'incIconNames' : curBudget.inc.iconNames,
        'incCurValues' : curBudget.inc.curValues,

          }, SetOptions(merge: mergeOpt));

    }else{//exp
      final expNames = List<String>.from(curBudget.exp.names)..removeAt(index);
      final expValues = List<double>.from(curBudget.exp.values)..removeAt(index);
      final expIcons = List<Icon>.from(curBudget.exp.icons)..removeAt(index);
      final expCurValues = List<double>.from(curBudget.exp.curValues)..removeAt(index);
      final expIconNames = List<String>.from(curBudget.exp.iconNames)..removeAt(index);

      curBudget.exp.names = expNames;
      curBudget.exp.values = expValues;
      curBudget.exp.icons = expIcons;
      curBudget.exp.curValues = expCurValues;
      curBudget.exp.iconNames = expIconNames;
      
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
  void addCategory<T>({
    required String name, required double value, required Icon icon, required String iconName,required bool isInc, required String date, mergeOpt = true}) {
    if (isInc){
      // add name, value, icon, and icon name to new arrays before adding so we don't mutate the original list in place
      final incNames = List<String>.from(curBudget.inc.names)..add(name);
      final incValues = List<double>.from(curBudget.inc.values)..add(value);
      final incIcons = List<Icon>.from(curBudget.inc.icons)..add(icon);
      final incCurValues = List<double>.from(curBudget.inc.curValues)..add(0);
      final incIconNames = List<String>.from(curBudget.inc.iconNames)..add(iconName);

      curBudget.inc.names = incNames;
      curBudget.inc.values = incValues;
      curBudget.inc.icons = incIcons;
      curBudget.inc.curValues = incCurValues;
      curBudget.inc.iconNames = incIconNames;
      
      //upadte database
      budgetsRef?.doc(date)
      .set({
        'incNames' : curBudget.inc.names,
        'incValues' : curBudget.inc.values,
        'incIconNames' : curBudget.inc.iconNames,
        'incCurValues' : curBudget.inc.curValues,

          }, SetOptions(merge: mergeOpt));

    }else{//exp
      final expNames = List<String>.from(curBudget.exp.names)..add(name);
      final expValues = List<double>.from(curBudget.exp.values)..add(value);
      final expIcons = List<Icon>.from(curBudget.exp.icons)..add(icon);
      final expCurValues = List<double>.from(curBudget.exp.curValues)..add(0);
      final expIconNames = List<String>.from(curBudget.exp.iconNames)..add(iconName);

      curBudget.exp.names = expNames;
      curBudget.exp.values = expValues;
      curBudget.exp.icons = expIcons;
      curBudget.exp.curValues = expCurValues;
      curBudget.exp.iconNames = expIconNames;
      
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
  Future<void> loadDataFromEmail ({required String userEmail}) async {
    email = userEmail;// key for users data

    //username
    final usersDocRef = FirebaseFirestore.instance.collection('users').doc(email);
   
    final usersDocSnap = await usersDocRef.get();

    Map<String, dynamic> data = usersDocSnap.data() as Map<String, dynamic>;
    username = data['username'] as String? ?? 'Set Username';
    
    budgetsRef = usersDocRef.collection('Budgets');  
    //create a new collection "budgets" under your user in the user collection, if it isn't already there
    
    await setBudgetData(date: data['curBudget'] as String? ?? 'New Budget'); 
    notifyListeners();  
  }

  Future<void> setBudgetData({required String date}) async{ 
    if (budgetsRef == null){
      return;
    }//idk if this is nessicary
    
    final docRef = budgetsRef?.doc(date);
    
    if (docRef != null){
      final docSnap = await docRef.get();
      
      if (!budgetNames.contains(date)) {
        budgetNames = List<String>.from(budgetNames)..add(date);
      }
      budgetIndex = budgetNames.indexOf(date);

      if (docSnap.exists){
        curBudget  =  loadBudget(snap: docSnap);
      } else {
        curBudget = await createNewBudget(date: date);
      }
      //get user variable
      
    }
    
    //set user variable (curBudget)
    await FirebaseFirestore.instance.collection('users').doc(email)
      .set({
        "curBudget" : date
      }, SetOptions(merge: true));

    final budgetsSnap = await budgetsRef?.get();
    if (budgetsSnap!=null){
      //get budget names
      budgetNames = budgetsSnap.docs.map((doc)=> doc.id).toList();
    }
    notifyListeners();  
  }

  Future<Budget> createNewBudget({required String date}) async {
    //set variables
    
    //exp
    List<String> expNames = ['Expense 1','Expense 2'];
    List<String> expIconNames = ['cancel', 'home'];
    List<double> expValues = [100, 50];
    List<double> expCurValues = [0,0];

    //inc
    List<String> incNames = ['Income 1'];
    List<String> incIconNames = ['check'];
    List<double> incValues = [200];
    List<double> incCurValues = [0];

    //set database

    await budgetsRef?.doc(date).set({
      'expNames': expNames,
      'expIconNames': expIconNames,
      'expValues': expValues,
      'expCurValues': expCurValues,
      'incNames': incNames,
      'incIconNames': incIconNames,
      'incValues': incValues,
      'incCurValues': incCurValues,
    }, SetOptions(merge: true));

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
    //set budget index
    budgetIndex = budgetNames.indexOf(date);

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
      iconList.add(Icon(IconMapper.getIconData(stringList[i])));//TODO add monetization _on to map of strings to icons, for default value
    }

    return iconList;
   }  

   Future<void> deleteBudget({required String date}) async{
    
    await FirebaseFirestore.instance
    .collection('users')
    .doc(email)
    .collection('Budgets')
    .doc(date)
    .delete();
    
    budgetNames.removeAt(budgetIndex);
    budgetIndex = 0;
    setBudgetData(date: budgetNames[budgetIndex]);
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

  // static Budget remake(){
  //   return Budget(
  //     budgetDate: 'null',
  //     exp: Expenses(date: 'null' , names: [], icons: [], iconNames: [],values: [], curValues: []),
  //     inc: Incomes(date: 'null' , names: [], icons: [], iconNames: [], values: [], curValues: [])
  //   );
  // }
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