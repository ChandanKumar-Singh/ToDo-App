import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_6_months/screens/addTasks.dart';
import 'package:todo_6_months/screens/description.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _uid;
  @override
  initState() {
    getUid();
    super.initState();
  }

  void getUid() async {
    final uid = await FirebaseAuth.instance.currentUser!.uid;
    setState(() {
      _uid = uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO'),
        centerTitle: true,
        backgroundColor: Colors.purple,
        actions: [
          IconButton(onPressed: logOut, icon: const Icon(Icons.logout))
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.red,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(_uid)
              .collection('MyTasks')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator()));
            } else {
              final docs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final time = (docs[index]['timeStamp'] as Timestamp).toDate();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>  DescriptionPage(title: docs[index]['title'],description: docs[index]['description'],))),
                      child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xff121211),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.yellow[50]!,
                                    offset: Offset(1, 1),
                                    blurRadius: 10)
                              ]),
                          height: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      docs[index]['title'],
                                      style: GoogleFonts.roboto(fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      DateFormat.yMd().add_jm().format(time),
                                      style: GoogleFonts.roboto(fontSize: 20),
                                    ),
                                  )
                                ],
                              ),
                              IconButton(
                                  onPressed: () async {
                                    print('delete');
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(_uid)
                                        .collection('MyTasks')
                                        .doc(docs[index].id)
                                        .delete();
                                    Fluttertoast.showToast(
                                        msg: 'Deleted ${docs[index]['title']}');
                                  },
                                  icon: Icon(Icons.delete_forever))
                            ],
                          )),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddTasks())),
        child: Icon(Icons.add),
      ),
    );
  }

  void logOut() async {
    final logOut = await FirebaseAuth.instance.signOut();
    logOut;
  }
}
