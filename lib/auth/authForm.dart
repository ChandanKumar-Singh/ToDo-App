import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late String _email;
  late dynamic _password = '';
  String? _userName;
  bool isLoginPage = true;

  startAuthenticate() async {
    final validity = _formKey.currentState?.validate();
    if (validity!) {
      _formKey.currentState?.save();
      submit();
    }
  }

  void submit() async {
    final auth = FirebaseAuth.instance;
    try {
      if (isLoginPage) {
        final authResult = await auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } else {
        final authrResult = await auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        String uid = authrResult.user!.uid;
        final time = DateTime.now().toIso8601String();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('profile')
            .doc(time)
            .set({
          'username': _userName,
          'email': _email,
          'password': _password,
        });
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      AlertDialog(
        title: const Text('ERROR OCCURRED'),
        content: Text(e.message!),
        actions: [
          FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'))
        ],
      );
    }

    print('Submitted');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  if (!isLoginPage)
                    TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Username required!";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value!;
                      },
                      key: const ValueKey('username'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(),
                        ),
                        labelText: 'Enter Your Name',
                        labelStyle: GoogleFonts.roboto(),
                      ),
                    ),
                  const SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return "Incorrect Email";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                    key: const ValueKey('email'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(),
                      ),
                      labelText: 'Enter Email',
                      labelStyle: GoogleFonts.roboto(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Incorrect Password";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                    key: const ValueKey('password'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(),
                      ),
                      labelText: 'Enter Password',
                      labelStyle: GoogleFonts.roboto(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(5),
                    height: 70,
                    width: double.infinity,
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: startAuthenticate,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(85)),
                      child: isLoginPage
                          ? Text(
                              'login',
                              style: GoogleFonts.roboto(fontSize: 30),
                            )
                          : Text(
                              'Submit',
                              style: GoogleFonts.roboto(fontSize: 30),
                            ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    height: 70,
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: isLoginPage
                          ? () => setState(() {
                                isLoginPage = !isLoginPage;
                              })
                          : submit,
                      child: isLoginPage
                          ? Text(
                              'Not a member? Click here',
                              style: GoogleFonts.roboto(),
                            )
                          : Text(
                              'Already a member? Login',
                              style: GoogleFonts.roboto(),
                            ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
