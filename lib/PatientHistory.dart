import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class patienthistory extends StatefulWidget {
  String? aadharNumber;
  patienthistory({@required aadharNumber});

  @override
  State<patienthistory> createState() => _patienthistoryState();
}

class _patienthistoryState extends State<patienthistory> {
  String? aadharNumber;

  void getAadharNumber() {
    aadharNumber = widget.aadharNumber;
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
