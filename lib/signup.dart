import 'package:flutter/material.dart';
import 'package:friday/service/auth.dart'; // Import AuthMethods
import 'package:friday/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friday/pages/home_page.dart';

class SignUp extends StatefulWidget {
 const SignUp({super.key});

 @override
 State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
 String email = "", password = "", name = "";
 TextEditingController namecontroller = TextEditingController();
 TextEditingController passwordcontroller = TextEditingController();
 TextEditingController mailcontroller = TextEditingController();

 final _formkey = GlobalKey<FormState>();

 // Add the registration function here
 registration() async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          
            content: Text(
          "Registered Successfully",
          style: TextStyle(fontSize: 20.0,color:Color(0xFF00FFF6)),
        )));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Password Provided is too Weak",
                style: TextStyle(fontSize: 18.0,color:Color(0xFF00FFF6)),
              )));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          
              content: Text(
                "Account Already exists",
                style: TextStyle(fontSize: 18.0,color:Color(0xFF00FFF6)),
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
                    buildTextField(namecontroller, "Name", "Please Enter Name"),
                    SizedBox(height: 30.0),
                    buildTextField(mailcontroller, "Email", "Please Enter Email"),
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
                              name = namecontroller.text;
                              password = passwordcontroller.text;
                            });
                            registration(); // Call the registration function here
                          }
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Text(
                      "or signup with",
                      style: TextStyle(
                          color: Color(0xFF00FFF6),
                          fontSize: 22.0,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 30.0),
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
                    SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?",
                            style: TextStyle(
                                color: Color(0xFF8c8e98),
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500)),
                        SizedBox(width: 5.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => LogIn()));
                          },
                          child: Text(
                            "LogIn",
                            style: TextStyle(
                                color: Color.fromARGB(255, 77, 255, 255),
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
          color: Color(0xFF00FFF6), 
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
