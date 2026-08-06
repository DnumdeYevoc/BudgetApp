
import 'package:flutter/material.dart';
import'package:firebase_auth/firebase_auth.dart';
import 'package:cheddar/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();


  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
        );
    } on FirebaseAuthException catch (e) {
      setState((){
        errorMessage = e.message;
      });
    
    }
  }

  Future<void> CreateUserWithEmailAndPassword() async{
    try {   
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
        );
      await saveEmailUser(_controllerEmail.text,_controllerPassword.text);
     } on FirebaseAuthException catch (e) {
      setState((){
        errorMessage = e.message;
      });
    }
  }

  Future<void> signInWithGoogle()async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null){
      final _gAuth = await account.authentication;
      final _credential = GoogleAuthProvider.credential(
        idToken: _gAuth.idToken,
        accessToken: _gAuth.accessToken,
      );

      await Auth().signInWithCredential(credential: _credential);
      await saveGoogleUser(account);
      
      }
    } on FirebaseAuthException catch (error){
      errorMessage = error.message;
    }
  }

  Future<void> saveGoogleUser(GoogleSignInAccount account)async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(account.email);
    final docSnap = await docRef.get();
    if (docSnap.exists){
      docRef.set ({
        "email" : account.email,
      }
    );
    }
  }

  Future<void> saveEmailUser(String email,String password)async {
    FirebaseFirestore.instance.collection('users')
      .doc(email)
      .set ({
        "email" : email,
        "username" : "default"
      }
    );
  }

  // widgets
  Widget _title() {
    return Text('Cheddar', 
    style: TextStyle(
      color:Theme.of(context).colorScheme.primary,
      fontSize: 50,
      fontWeight: FontWeight(500),
      ),);
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
    bool isHidden,
  ){
    return TextField(
      obscureText: isHidden,
      controller: controller,
      decoration: InputDecoration(
        labelText: title,

        )
      );
    }

  Widget _errorMessage(){
    return Text(errorMessage == ''? '' : 'huh? $errorMessage');
  }

  Widget _sumbitButton(){
    return ElevatedButton(
      onPressed:
        isLogin ? signInWithEmailAndPassword : CreateUserWithEmailAndPassword,
       child: Text(isLogin ? 'Login' : 'Register')
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
       onPressed: (){
          setState((){
            isLogin = !isLogin;
          }
          );
       },
       child: Text(isLogin ? 'Register instead' : 'Login instead'),

    );
  }

  Widget _googleSignIn(){
    return ElevatedButton(onPressed: signInWithGoogle, child: const Text('Sign in with Google'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      
      body: Container(
        
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Icon(Icons.monetization_on_sharp, color: Theme.of(context).colorScheme.primary, size: 50,),
                _title(),
              ]
            ),
            
            _entryField('email', _controllerEmail, false),
            _entryField('password', _controllerPassword, true),
            _errorMessage(),
            _sumbitButton(),
            _loginOrRegisterButton(),
            _googleSignIn(),
            
          ],
        )
      ),
    );
  }
}