import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class patienthistory extends StatefulWidget {
  String? username;
  patienthistory({super.key, @required username});

  @override
  State<patienthistory> createState() => _patienthistoryState();
}

class _patienthistoryState extends State<patienthistory> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? aadharNumber;
  String? username;
  TextEditingController aadharController = TextEditingController();

  void getUsername() async {
    username = await _auth.currentUser?.email.toString();
  }

  TextStyle? getStyle(double size) {
    TextStyle textStyle = GoogleFonts.poppins(
        color: Colors.lightBlue, fontSize: size, fontWeight: FontWeight.bold);
    return textStyle;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsername();
  }

  bool widgetNumber = false;

  Widget getWidget(String? aadharNumber, String? username) {
    return FutureBuilder(
      future: _firestore
          .collection('doctors')
          .doc(username.toString())
          .collection('patients')
          .doc(aadharNumber)
          .collection('visits')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          int lengthDocs = snapshot.data!.docs.length;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: lengthDocs,
            itemBuilder: (context, index) {
              Timestamp time = snapshot.data!.docs[index]['Date'];
              DateTime dateTime = time.toDate();
              String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
              String condition = snapshot.data!.docs[index]['Condition'];
              String imageUrl = snapshot.data!.docs[index]['ImagePath'];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // Wrap the image with an AspectRatio to maintain aspect ratio
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InteractiveViewer(
                          child: ClipRRect(
                            child: Image.network(
                              imageUrl,
                              width: 200,
                              height: 200,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "Condition : $condition",
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Date : $formattedDate",
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: const Text("Waiting for data !!!!"),
          );
        } else {
          return const Text("No data !!!!");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          "Patient History",
          style: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        elevation: 10,
        titleSpacing: 5,
      ),
      body: Material(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 10),
                child: TextField(
                  cursorColor: Colors.black,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  onChanged: (val) {
                    aadharNumber = val;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.lightBlue,
                          width: 2,
                        )),
                    labelStyle: getStyle(15),
                    labelText: "AADHAR Number",
                  ),
                  controller: aadharController,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widgetNumber = true;
                    aadharNumber = aadharController.text.toString();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Search",
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              widgetNumber ? getWidget(aadharNumber, username) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
