import 'package:flutter/material.dart';

class WriteExamples extends StatefulWidget {
  const WriteExamples({super.key});

  @override
  State<WriteExamples> createState() => _WriteExamplesState();
}

class _WriteExamplesState extends State<WriteExamples> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Write Examples'),),
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
