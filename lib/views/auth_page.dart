import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/views/home_screen.dart';
import 'package:firebase_project/views/login_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return HomeScreen();
            }
            else{
              return LoginPage();
            }
          }),
    );
  }
}
