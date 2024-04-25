import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:health_app/main_screen.dart";

class ProfilePage extends StatefulWidget {
  final Username;
  const ProfilePage({@required this.Username});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String? Username;
  dynamic response;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
  }

  void getUserName() {
    Username = widget.Username;
  }

  Future<dynamic> getFuture() async {
    try {
      response = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(Username)
          .get();
      return response;
    } on Exception catch (e) {
      print(e);
    }
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          "DermaDoc",
          style: GoogleFonts.poppins(
              fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        elevation: 10,
        titleSpacing: 5,
      ),
      body: Column(
        children: [
          FutureBuilder(
              future:
                  firebaseFirestore.collection('doctors').doc(Username).get(),
              builder: (context, snapshot) {
                String doctorName = snapshot.data!['Name'];
                String department = snapshot.data!['Department'];
                String age = snapshot.data!['Age'];

                // debugPrint(doctorName);
                // debugPrint(department);
                // debugPrint(age);

                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [Container(), Container()],
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else
                  return Container(
                    child: Text("Something wrong happened"),
                  );
              })
        ],
      ),
    );
  }
}
