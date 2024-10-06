import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friday/pages/home_page.dart';
import 'package:friday/service/auth.dart';
import 'package:friday/signup.dart';
import 'package:friday/forgot_password.dart';

class LogIn extends StatefulWidget {
 const LogIn({super.key});

 @override
 State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
 String email = "", password = "";
 TextEditingController mailcontroller = TextEditingController();
 TextEditingController passwordcontroller = TextEditingController();

 final _formkey = GlobalKey<FormState>();

 userLogin() async {
    if (_formkey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Login Successful",
          style: TextStyle(fontSize: 20.0,color:Color(0xFF00FFF6)),
        )));
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.black12, // Light black background
              content: Text(
                "No User Found for that Email",
                style: TextStyle(fontSize: 18.0, color: Color(0xFF00FFF6)), // Aqua blue text
              )));
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.black12, // Light black background
              content: Text(
                "Wrong Password Provided by User",
                style: TextStyle(fontSize: 18.0, color: Color(0xFF00FFF6)), // Aqua blue text
              )));
        }
      }
    }
 }

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Container(
        child: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                 "images/logo.jpg",
                 fit: BoxFit.cover,
                )),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Form(
                key: _formkey,
                child: Column(
                 children: [
                    buildTextField(mailcontroller, "Email", "Please Enter E-mail"),
                    SizedBox(height: 30.0),
                    buildTextField(passwordcontroller, "Password", "Please Enter Password", isPassword: true),
                    SizedBox(height: 30.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF00FFF6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MaterialButton(
                        onPressed: (){
                          if(_formkey.currentState!.validate()){
                            setState(() {
                              email = mailcontroller.text;
                              password = passwordcontroller.text;
                            });
                            userLogin();
                          }
                        },
                        child: Text(
                          "Log In",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPassword()));
                      },
                      child: Text("Forgot Password?",
                          style: TextStyle(
                              color: Color(0xFF8c8e98),
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(height: 40.0),
                    Text(
                      "or login with",
                      style: TextStyle(
                          color: Color.fromARGB(255, 82, 255, 243),
                          fontSize: 22.0,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            AuthMethods().signInWithGoogle(context);
                          },
                          child: Image.asset(
                            "images/google.png",
                            height: 45,
                            width: 45,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?",
                            style: TextStyle(
                                color: Color(0xFF8c8e98),
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500)),
                        SizedBox(width: 5.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => SignUp()));
                          },
                          child: Text(
                            "SignUp",
                            style: TextStyle(
                                color: Color.fromARGB(255, 91, 255, 255),
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    )
                 ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
 }

 Widget buildTextField(TextEditingController controller, String hintText, String validationMessage, {bool isPassword = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 22, 22, 22),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF00FFF6).withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validationMessage;
          }
          return null;
        },
        controller: controller,
        style: TextStyle(
          color: Color(0xFF00FFF6), // Set text color here
          fontSize: 18.0,
        ),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
                color: Color(0xFFb2b7bf), fontSize: 18.0)),
        obscureText: isPassword,
      ),
    );
 }
}
