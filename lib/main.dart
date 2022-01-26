import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_6_months/auth/authScreens.dart';
import 'package:todo_6_months/screens/home.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TodoApp());}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(brightness: Brightness.dark, primaryColor: Colors.purple),
      home: StreamBuilder(
        stream:FirebaseAuth.instance.authStateChanges() ,
        builder: (context,snapshot){
          if(snapshot.hasData){
            return const Home();
          }
          else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}
