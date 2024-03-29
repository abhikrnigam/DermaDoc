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
    return SingleChildScrollView(
      child: FutureBuilder(
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
                String formattedDate =
                    DateFormat('dd-MM-yyyy').format(dateTime);
                String condition = snapshot.data!.docs[index]['Condition'];
                String imageUrl = snapshot.data!.docs[index]['ImagePath'];
                print("*****");
                print(formattedDate);
                print(condition);
                print(imageUrl);
                return Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.65,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        InteractiveViewer(child: Image.network(imageUrl)),
                        Text("Condition/Disease : $condition"),
                        Text("Date : $formattedDate"),
                      ],
                    ),
                  ),
                );
              },
            );
            // return Container(
            //   child: Text(snapshot.data!.size.toString()),
            // );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: const Text("Waiting for data !!!!"),
            );
          } else {
            return const Text("No data !!!!");
          }
        },
      ),
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
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
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
                  child: Text(
                    "Search",
                    style: getStyle(15),
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
