import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:cheddar/auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title(){
    return const Text('Cheddar');
  }

  Widget _userUid(){
    return Text(user?.email ?? 'User Email');
  }

  Widget _signOutButton(){
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,//centre column
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userUid(),
            _signOutButton(),
          ],
        ),
      )
    );
  }
}