import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_app/AddImage.dart';
import 'package:health_app/CompareImages.dart';
import 'package:health_app/login_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? name = FirebaseAuth.instance.currentUser?.email.toString();
    name = name?.replaceAll("@gmail.com", "");

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.account_circle,
                      size: 50,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "${name?.toUpperCase()}",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.lightBlue),
              child: Text(
                "${name?.toUpperCase()}",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              subtitle: const Text("New patients must be registered"),
              subtitleTextStyle: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.lightBlue,
              ),
              title: Text("Register Patient",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.lightBlue,
                  )),
              selected: selectedIndex == 1,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddImage()));
              },
            ),
            ListTile(
              title: Text(
                "View Patient Images",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.lightBlue,
                ),
              ),
              selected: selectedIndex == 2,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CompareImages(username: name)));
              },
            ),
            ListTile(
              title: Text(
                "View patient history",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.lightBlue,
                ),
              ),
              selected: selectedIndex == 3,
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => PatientHistory(username: name)));
              },
            ),
            ListTile(
              title: Text("Sign Out",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  )),
              selected: selectedIndex == 4,
              onTap: () {
                Future<void> signOut() async {
                  await FirebaseAuth.instance.signOut().then((value) =>
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage())));
                }

                signOut();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {});
            },
          )
        ],
        backgroundColor: Colors.lightBlue,
        title: Text(
          "DermaDoc",
          style: GoogleFonts.poppins(
              fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        elevation: 10,
        titleSpacing: 5,
      ),
    );
  }
}
