import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

//in this we will let the user add only one image for one timestamp.
// images will also be sorted based on the timestamp.
// the location should be something like that {user_uid/timestamp/userImage}
// or we can just search the images based on the timestamp.

class AddImage extends StatefulWidget {
  const AddImage({super.key});
  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  String? name;
  String? age;
  String? gender;
  String? phoneNumber;
  String? disease;
  String? aadharNumber;
  //above are the details of the patients to be registered.

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerGender = TextEditingController();
  TextEditingController controllerAge = TextEditingController();
  TextEditingController controllerPhoneNumber = TextEditingController();
  TextEditingController controllerDisease = TextEditingController();
  TextEditingController controllerAadhar = TextEditingController();
  //above given are the editing controllers for the text fields that will be created.

  File? image;
  final picker = ImagePicker();
  String username =
      FirebaseAuth.instance.currentUser!.email!.toLowerCase().toString();
  String? imagePath;

  // common textStyle that is to be followed.
  TextStyle? getStyle(double size) {
    TextStyle textStyle = GoogleFonts.poppins(
        color: Colors.lightBlue, fontSize: size, fontWeight: FontWeight.bold);
    return textStyle;
  }

  //the function gets the image from the gallery.
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
              // this is the break point of the code
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
                  print(imagePath);
                  uploadImage(context, username, image!);
                },
              ),
            ],
          ),
        ),
      );
    }
    return Container();
  }

  // void storeToDatabase(final url, final username) async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   debugPrint("## Image Upload Done ");
  //   await firestore
  //       .collection("Users")
  //       .doc(username)
  //       .collection("UploadedImages")
  //       .add({
  //         "imagePath": url.toString(),
  //         "timeUploaded": Timestamp.now(),
  //       })
  //       .then((value) => print("The data has been uploaded"))
  //       .catchError((error) => print("Failed to upload data: $error"));
  // }

  void registerPatient(final url, final username) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    debugPrint("## Image Upload Done ");
    await firestore
        .collection("doctors")
        .doc(username)
        .collection("patients")
        .doc(aadharNumber)
        .set({
      'Age': age,
      'Disease': disease.toString(),
      'Name': name,
      'UIDAI': aadharNumber,
      'imagePath': url.toString(),
      'PhoneNumber': phoneNumber.toString(),
    });
  }

  // ignore: prefer_typing_uninitialized_variables
  UploadTask? uploadTask;

  Future<void> uploadImage(
      BuildContext context, String username, File image) async {
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
    final urlDownload = await snapshot?.ref.getDownloadURL();

    //storeToDatabase(urlDownload, username);
    registerPatient(urlDownload, username);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data is uploaded'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          "Register Patient",
          style: GoogleFonts.poppins(
              fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        elevation: 10,
        titleSpacing: 5,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 20),
              child: TextField(
                cursorColor: Colors.black,
                style: const TextStyle(
                  color: Colors.black,
                ),
                onChanged: (val) {
                  name = val;
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.lightBlue,
                        width: 2,
                      )),
                  labelStyle: getStyle(15),
                  labelText: "Name",
                ),
                controller: controllerName,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.black,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      onChanged: (val) {
                        age = val;
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.lightBlue,
                              width: 2,
                            )),
                        labelStyle: getStyle(15),
                        labelText: "Age(years)",
                      ),
                      controller: controllerAge,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        cursorColor: Colors.black,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        onChanged: (val) {
                          gender = val;
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Colors.lightBlue,
                                width: 2,
                              )),
                          labelStyle: getStyle(15),
                          labelText: "Gender (M/F)",
                        ),
                        controller: controllerGender,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
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
                  phoneNumber = val;
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.lightBlue,
                        width: 2,
                      )),
                  labelStyle: getStyle(15),
                  labelText: "Phone Number",
                ),
                controller: controllerPhoneNumber,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 30),
              child: TextField(
                cursorColor: Colors.black,
                style: const TextStyle(
                  color: Colors.black,
                ),
                onChanged: (val) {
                  disease = val;
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.lightBlue,
                        width: 2,
                      )),
                  labelStyle: getStyle(15),
                  labelText: "Condition Diagnosed",
                ),
                controller: controllerDisease,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 30),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Upload image of condition",
                    style: getStyle(20),
                  ),
                ),
              ],
            ),
            getWidget(),
          ],
        ),
      ),
    );
  }
}
