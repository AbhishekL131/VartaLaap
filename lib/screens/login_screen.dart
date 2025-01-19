

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vartalaap/screens/sign_up_screen.dart';

import '../firebase_utilities/firebase_auth_methods.dart';
import 'home_page.dart';





class LoginScreen extends StatefulWidget{

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;


  void loginUser() async {
    bool success = await context.read<FirebaseAuthMethods>().LoginWithEmail(
      email: emailController.text,
      password: passwordController.text,
      context: context,
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please check your credentials.')),
      );
    }
  }

  void toggleVisibility(){
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 350,
                  child: Image(
                      image: AssetImage(
                        'assets/images/login.jpeg',
                      )
                  ),
                ),
              ),

              Text(
                "Login",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003366)
                ),
              ),

              SizedBox(height: 20,),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: const Color.fromRGBO(245,247,249,1)
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          size: 25,
                        ),
                        labelText: "Enter your Email",
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(
                                color: Colors.blueAccent,
                                width: 2
                            )
                        ),

                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 2
                            )
                        )
                    ),
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: const Color.fromRGBO(245,247,249,1)
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(

                        prefixIcon: Icon(
                          Icons.password,
                          size: 25,
                        ),
                        suffixIcon: IconButton(
                            icon : Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                            onPressed: toggleVisibility
                        ),
                        labelText: "Enter your password",
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(
                                color: Colors.blueAccent,
                                width: 2
                            )
                        ),

                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 2
                            )
                        )
                    ),
                  ),
                ),
              ),


              // forgot password


              InkWell(
                onTap: (){
                  final email = emailController.text.trim();
                  context.read<FirebaseAuthMethods>().resetPassword(
                      email: email,
                      context: context
                  );
                },
                child: Text(
                  "Forgot password ?",
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF146EB4)
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loginUser,
                    child: Text(
                      "Log In",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF146EB4),
                        elevation: 5

                    ),
                  ),
                ),
              ),

              SizedBox(height: 15,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Dont have account?",
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()
                          )
                      );
                    },
                    child: Text(
                      "SignUp",
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF146EB4)
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}