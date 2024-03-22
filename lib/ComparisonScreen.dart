import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComparisonScreen extends StatefulWidget {
  List<String>? imagePath;
  ComparisonScreen({required this.imagePath});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  List<String>? imagePath;
  @override
  void getUrls() {
    imagePath = widget.imagePath;
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getUrls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          "Healthify",
          style: GoogleFonts.poppins(
              fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        elevation: 10,
        titleSpacing: 5,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Comparison",
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(8),
              child: Image.network(imagePath![1]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: InteractiveViewer(
              child: Image.network(imagePath![2]),
              boundaryMargin: EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }
}
