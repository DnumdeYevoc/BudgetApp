//TODO
//class with all required data elements
//future: add date as a code to select which budget
//use this class to create pie charts etc

//class that stores all user data
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  //variables
  String userName;
  String email;

  UserProvider({
    this.userName = 'Username',
    this.email = 'User Email'
  });

  void setEmail({
    required String newEmail
  }) async {
 
    email = newEmail;
  }

  void changeUserName({
    required String newUserName,
  }) async {
    userName = newUserName;
    try{
      await FirebaseFirestore.instance.collection('users')
        .doc(email )
          .set ({ 
            "email": email,//erases previous data for some reason??
            "username" : newUserName

                }
              );
    } catch (e) {
      print("Error: $e");
  }
    notifyListeners();
  }

}