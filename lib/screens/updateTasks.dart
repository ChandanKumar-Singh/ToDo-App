import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateTasks extends StatefulWidget {
  const UpdateTasks(
      {Key? key, required this.initialTitle, required this.initialDescription})
      : super(key: key);
  final String initialTitle;
  final String initialDescription;

  @override
  _UpdateTasksState createState() => _UpdateTasksState();
}

class _UpdateTasksState extends State<UpdateTasks> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String? newT;
  String? newD;
  String? id;

  @override
  void initState() {
    super.initState();
    getId();
    // print(id);
  }

  Stream<String> getId() async* {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    QuerySnapshot snapshot = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('MyTasks')
        .snapshots() as QuerySnapshot<Object?>;
    await snapshot.docs.map((e) => id = e.id);

  }

  updateTaskToFirebase() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      final User user = await auth.currentUser!;
      final time = DateTime.now().toIso8601String();
      if (titleController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('MyTasks')
            .doc(id)
            .update({
          'title': newT,
          'description': newD,
          'timeStamp': DateTime.now(),
        });
        Fluttertoast.showToast(msg: 'Task Added ');
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(msg: 'Add All required fields');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Column(
              children: [
                TextFormField(
                  initialValue: widget.initialTitle,
                  // controller: titleController,
                  onSaved: (value) => value = newT,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(),
                    ),
                    labelText: 'Enter Title',
                    labelStyle: GoogleFonts.roboto(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: widget.initialDescription,
                  // controller: descriptionController,
                  onSaved: (value) => value = newD,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(),
                    ),
                    labelText: 'Enter Description',
                    labelStyle: GoogleFonts.roboto(),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(5),
                  height: 70,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.purple.shade100;
                      return Theme.of(context).primaryColor;
                    })),
                    onPressed: () => updateTaskToFirebase(),
                    child: Text(
                      'Update Task',
                      style:
                          GoogleFonts.roboto(fontSize: 30, color: Colors.blue),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
