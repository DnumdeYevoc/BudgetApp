import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  //variables
  String username;
  String email;
  CollectionReference<Map<String, dynamic>>? budgetsRef;

  UserProvider({
    this.username = 'Set Username',
    this.email = 'Set User Email'
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

    //test
    budgetsRef?.doc('poop month').set({"poop": "fart"});//worked!

    //function that can be used later if we need to get any budget data
    setBudgetData(date: "08/2026");

    //maybe make a class for budgets, make method to grab them from UserProvider (check if date exissts, create one if not and return that)

    //watch tutorial so u know what ur doing
    //create a new collection "budgets" under your user in the user collection
    
    //create monthly documents for now, can revamp to make weekly later
    //save an array of category names 
    //save an array of category values
    //save an array of category icons ('string names of icons')
    //save an array of current category values
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
        //cur_budget  = Budget.createNewBudget(date);
      } else {
        //cur_budget = Budget.loadBudget(date);
      }
    }
  }
}

class Budget {

}