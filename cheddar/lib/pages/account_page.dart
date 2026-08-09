import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cheddar/auth.dart';
import 'package:provider/provider.dart';
import 'package:cheddar/user_provider.dart';


class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final User? user = Auth().currentUser;
  final TextEditingController userNameController = TextEditingController();
  bool changeUserName = false;

  Future<void> signOut() async {
    await Auth().signOut();
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

  Widget _userName(){
    return Text(
      context.watch<UserProvider>().username,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      )
    );
  }

  Widget _changeUserName(){
    return changeUserName
    ?Column(
      children: [
        SizedBox(
          width: 200,
          height: 50,
          child: TextField(
            controller: userNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: (){
            if (userNameController.text != ''){
              context.read<UserProvider>().changeUserVar(
                (val)=> context.read<UserProvider>().username = val,
                 userNameController.text,
                 varName:'username');
              FocusManager.instance.primaryFocus?.unfocus;
              userNameController.clear();
              changeUserName = false;
            }
          },
          child: const Text('Save'))
      ],
    )
    :ElevatedButton(
      onPressed:(){ setState(() {
        changeUserName = true;
      });},
      child: const Text('Change Username')
      );
    }
  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _userName(),
            _userUid(),
            _changeUserName(),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}