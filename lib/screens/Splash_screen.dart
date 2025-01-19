

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vartalaap/screens/home_page.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),(){

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>  const AuthWrapper(),
          )
      );

    }
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFF003366),

      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 300,
                  width: double.infinity,
                  child: Image(
                      image: AssetImage(
                        'assets/images/splash.png'
                      )
                  ),
                ),
              ),

              SizedBox(height: 20,),

              Text(
                "Vartalaap",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 35
                ),
              ),
              SizedBox(height: 10,),
              Text(
                "Powered by Google Gemini",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
                ),
              ),
              SizedBox(height: 60,),

              CircularProgressIndicator(
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return  HomePage();
    }
    return  LoginScreen();
  }
}
