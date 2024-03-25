import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class patienthistory extends StatefulWidget {
  String? aadharNumber;
  String? username;
  patienthistory({@required aadharNumber});

  @override
  State<patienthistory> createState() => _patienthistoryState();
}

class _patienthistoryState extends State<patienthistory> {
  String? aadharNumber;
  String? username;

  void getAadharNumber() {
    aadharNumber = widget.aadharNumber;
    username = widget.username;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAadharNumber();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
