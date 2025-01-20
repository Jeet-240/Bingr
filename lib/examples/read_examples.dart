import 'package:flutter/material.dart';

class ReadExamples extends StatefulWidget {
  const ReadExamples({super.key});

  @override
  State<ReadExamples> createState() => _ReadExamplesState();
}

class _ReadExamplesState extends State<ReadExamples> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Read Examples'),),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Column(
            children: [

            ],
          ),
        ),
      ),

    );
  }
}
