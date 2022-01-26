import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTasks extends StatefulWidget {
  const AddTasks({Key? key}) : super(key: key);

  @override
  _AddTasksState createState() => _AddTasksState();
}

class _AddTasksState extends State<AddTasks> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  addTaskToFirebase() async {
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
            .doc(time)
            .set({
          'title': titleController.text,
          'description': descriptionController.text,
          'time':time.toString(),
          'timeStamp':DateTime.now(),
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
        title: const Text('New Task'),
        centerTitle: true,
        backgroundColor: Colors.purple,

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Column(
              children: [
                TextField(
                  controller: titleController,
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
                TextField(
                  controller: descriptionController,
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
                // TextFormField(
                //   keyboardType: TextInputType.text,
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10),
                //       borderSide: const BorderSide(),
                //     ),
                //     labelText: 'Enter Password',
                //     labelStyle: GoogleFonts.roboto(),
                //   ),
                // ),
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
                    onPressed: () => addTaskToFirebase(),
                    child: Text(
                      'Add Task',
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
