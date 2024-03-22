import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_app/ComparisonScreen.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timestamp_to_string/timestamp_to_string.dart';
import 'package:quickalert/quickalert.dart';

class CompareImages extends StatefulWidget {
  String? username;
  CompareImages({required this.username});

  @override
  State<CompareImages> createState() => _CompareImagesState();
}

class _CompareImagesState extends State<CompareImages> {
  List<bool>? selectedIndex;
  List<String>? documentPath = ["a"];
  int selectedItems = 0;
  String? username;
  dynamic response;
  void getCurrentUser() async {
    username = widget.username;
  }

  Future<dynamic> getFuture() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String username = firebaseAuth.currentUser!.email.toString();
    try {
      response = await FirebaseFirestore.instance
          .collection('Users')
          .doc(username)
          .collection('UploadedImages')
          .orderBy('timeUploaded', descending: true)
          .get();
      //updateList(response);
      return response;
    } on Exception catch (e) {
      print(e);
    }
  }

  // Future<Widget> updateList(dynamic response) async {
  //   return FutureBuilder(
  //     future: getFuture(),
  //     builder: (BuildContext context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         int lengthDocs = snapshot.data.docs.length;
  //         print(lengthDocs);
  //         return ListView.builder(
  //           scrollDirection: Axis.vertical,
  //           shrinkWrap: true,
  //           itemCount: lengthDocs,
  //           itemBuilder: (context, index) {
  //             documentTimestamp?[index] =
  //                 snapshot.data.docs[index]['timeUploaded'];
  //             documentPath?[index] = snapshot.data.docs[index]['imagePath'];
  //             return Container();
  //           },
  //         );
  //       } else if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       } else {
  //         return Container();
  //       }
  //     },
  //   );
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            onPressed: () {
              if (selectedItems != 2) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  text: "Please select two images to compare",
                );
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ComparisonScreen(imagePath: documentPath)));
              }
            },
            backgroundColor: Colors.lightGreen,
            child: const Icon(
              Icons.compare,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text(
            "Select images to compare",
            style: GoogleFonts.poppins(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          elevation: 10,
          titleSpacing: 5,
        ),
        body: Material(
          color: Colors.white,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: FutureBuilder(
                future: getFuture(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    int lengthDocs = snapshot.data.docs.length;
                    //debugPrint(" The length of docs is $lengthDocs ");
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: lengthDocs,
                      itemBuilder: (context, index) {
                        selectedIndex?[index] = false; //for bool storage
                        Timestamp time =
                            snapshot.data.docs[index]['timeUploaded'];
                        DateTime dateTime = time.toDate();
                        String formattedDate = DateFormat('dd-MM-yyyy')
                            .format(dateTime); // formatted date time
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ListTile(
                              onTap: () {
                                if (documentPath!.contains(
                                    snapshot.data.docs[index]['imagePath'])) {
                                  documentPath!.remove(
                                      snapshot.data.docs[index]['imagePath']);
                                  selectedItems--;
                                } else {
                                  documentPath!.add(
                                      snapshot.data.docs[index]['imagePath']);
                                  selectedItems++;
                                }
                                print(selectedItems);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              tileColor: Colors.lightBlue,
                              subtitle: Center(
                                child: Text("Image uploaded on above date",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                              ),
                              title: Center(
                                child: Text(formattedDate.toString(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
