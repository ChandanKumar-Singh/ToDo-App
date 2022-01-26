import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_6_months/screens/updateTasks.dart';

class DescriptionPage extends StatelessWidget {
  const DescriptionPage(
      {Key? key, required this.title, required this.description})
      : super(key: key);
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Description'),
        centerTitle: true,
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
              onPressed: () => print('edit'),
              // () => Navigator.of(context)
              // .push(MaterialPageRoute(builder: (context) => UpdateTasks(initialDescription: description, initialTitle: title,))),
              icon: const Icon(Icons.edit_rounded))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.red[50]!,
                        offset: Offset(1, 1),
                        blurRadius: 10)
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Text(
                      title,
                      style: GoogleFonts.roboto(fontSize: 30),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 18.0, left: 10, right: 10),
                      child: Text(
                        description,
                        style: GoogleFonts.roboto(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
