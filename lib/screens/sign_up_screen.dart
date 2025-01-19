import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase_utilities/firebase_auth_methods.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  void signUpUser() async {
    context.read<FirebaseAuthMethods>().signUpWithEmail(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
      context: context,
    );


  }

  bool _obscureText = true;

  void toggleVisibility() {
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
                  height: 300,
                  child: Image(
                    image: AssetImage('assets/images/login.jpeg'),
                  ),
                ),
              ),
              SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: const Color.fromRGBO(245, 247, 249, 1),
                  ),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        size: 25,
                      ),
                      labelText: "Enter your Name",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 2,
                        ),
                      ),
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
                    color: const Color.fromRGBO(245, 247, 249, 1),
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
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 2,
                        ),
                      ),
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
                    color: const Color.fromRGBO(245, 247, 249, 1),
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
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: toggleVisibility,
                      ),
                      labelText: "Enter your password",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: signUpUser,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF146EB4),
                      elevation: 5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have account ? ",
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Login",
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
