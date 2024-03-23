import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_app/login_page.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? age;
  String? name;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  void registerDoctor(String username) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    debugPrint("## Image Upload Done ");
    await firestore.collection("doctors").doc(username).set({
      'Age': ageController.text.toString(),
      'Name': nameController.text.toString(),
      'Department': 'Dermatology',
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                " DermaDoc ",
                style: GoogleFonts.poppins(
                    fontSize: 50,
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.w700),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                child: Text(
                  "Hey Doc! Create an account with us ",
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.lightBlue,
                        width: 3,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(color: Colors.lightBlue, width: 3)),
                  labelText: "Name",
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.lightBlue,
                        width: 3,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(color: Colors.lightBlue, width: 3)),
                  labelText: "Age",
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.lightBlue,
                        width: 3,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(color: Colors.lightBlue, width: 3)),
                  labelText: "E-Mail Address",
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.lightBlue,
                        width: 3,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(color: Colors.lightBlue, width: 3)),
                  labelText: "Password",
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                  onPressed: () {
                    if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      _auth
                          .createUserWithEmailAndPassword(
                              email: emailController.text.toString(),
                              password: passwordController.text.toString())
                          .then((value) => {
                                registerDoctor(emailController.text.toString()),
                              })
                          // ignore: body_might_complete_normally_catch_error
                          .catchError((e) {
                        Get.snackbar("Alert", e);
                      });
                    }
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text(
                    " Register ",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                    ),
                  )),
              const SizedBox(height: 30),
              Text(
                "Made by Abhishek with ❤️",
                style: GoogleFonts.poppins(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
