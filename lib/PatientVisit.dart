import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class patientVisit extends StatefulWidget {
  const patientVisit({super.key});

  @override
  State<patientVisit> createState() => _patientVisitState();
}

//This page is intended to register a visit of the patient.
// The images will be stored and the data also will be stored as the visit_collection object
//This provides the data for Patient's History Page

// the fields will be :
// UIDAI number and the image of the condition.

class _patientVisitState extends State<patientVisit> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String? username;
  String? aadharNumber;
  String? condition;
  String? imagePath;
  TextEditingController controllerAadhar = TextEditingController();
  TextEditingController controllerCondition = TextEditingController();

  File? image;
  final picker = ImagePicker();

  void getUsername() {
    username = firebaseAuth.currentUser?.email.toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsername();
  }

  void getImage() async {
    try {
      final localImage = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (localImage != null) {
          image = File(localImage.path);
          imagePath = localImage.path.toString();
        }
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  TextStyle? getStyle(double size) {
    TextStyle textStyle = GoogleFonts.poppins(
        color: Colors.lightBlue, fontSize: size, fontWeight: FontWeight.bold);
    return textStyle;
  }

  Widget getWidget() {
    if (image == null) {
      //here the text will come "click here to upload the image"
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: const BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.all(Radius.circular(60)),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: IconButton(
                            onPressed: () {
                              getImage();
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.upload_file_rounded,
                              size: 70,
                              color: Colors.white,
                            )),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "Submit",
                  style: getStyle(30),
                ),
              ),
            ]),
      );
    } else if (image != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: const BoxDecoration(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image(
                    fit: BoxFit.contain,
                    image: FileImage(image!),
                  ),
                ),
              ),
              TextButton(
                child: Text(
                  "Submit",
                  style: getStyle(30),
                ),
                onPressed: () {
                  //print(imagePath);
                  uploadData(context, username, image!);
                },
              ),
            ],
          ),
        ),
      );
    }
    return Container();
  }

  UploadTask? uploadTask;

  Future<void> uploadData(
      BuildContext context, String? username, File image) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Uploading, please wait...'),
      ),
    );
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final pathImage = '$username/$timestamp/image'; // Updated path generation
    final reference = FirebaseStorage.instance.ref().child(pathImage);
    uploadTask = reference.putFile(image);
    final snapshot = await uploadTask?.whenComplete(() => {});
    final urlDownload = await snapshot?.ref
        .getDownloadURL(); //this is the url of the image stored on firebase

    uploadVisitToFirestore(username, aadharNumber, urlDownload);
    // here the username is the name of the doctor
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data upload complete!'),
      ),
    );
  }

  Future<void> uploadVisitToFirestore(
      String? username, String? aadharNumber, String? imagePath) async {
    FirebaseFirestore cloudFirestore = FirebaseFirestore.instance;
    cloudFirestore
        .collection('doctors')
        .doc(username.toString())
        .collection('patients')
        .doc(aadharNumber.toString())
        .collection('visits')
        .add({
      'Condition': condition,
      'Date': DateTime.now(),
      'ImagePath': imagePath,
    }).then((value) => {debugPrint("Visit Registered")});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          "Patient Visit",
          style: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        elevation: 10,
        titleSpacing: 5,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Text(
                "Note : The patient must already be registered ",
                style: getStyle(12),
              ),
            ),
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
                controller: controllerAadhar,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 10),
              child: TextField(
                cursorColor: Colors.black,
                style: const TextStyle(
                  color: Colors.black,
                ),
                onChanged: (val) {
                  condition = val;
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.lightBlue,
                        width: 2,
                      )),
                  labelStyle: getStyle(15),
                  labelText: "Condition/Disease",
                ),
                controller: controllerCondition,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10),
              child: Text(
                "Upload image of condition",
                style: getStyle(15),
              ),
            ),
            //insert the widget here.
            getWidget(),
          ],
        ),
      ),
    );
  }
}
