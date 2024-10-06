import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:friday/const.dart';
import 'package:friday/login.dart';
import 'package:friday/pages/home_page.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(options: FirebaseOptions(
    apiKey: 'AIzaSyBGf902qER5tUEvCnp5OdUsWMGBwI6zUtI',
    appId: '1:627003520960:android:9ad0478055e71efb743a25',
    messagingSenderId: '627003520960',
    projectId: 'jarvis-86bf4'));
 Gemini.init(apiKey: GEMINI_API_KEY);
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({super.key});

 @override
 Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Assistance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 255, 247),),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return const LogIn();
            } else {
              return const HomePage();
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
 }
}
