import 'package:bingr/widgets/animated_app_bar.dart';
import 'package:bingr/constants/colors.dart';
import 'package:bingr/widgets/custom_sidebar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sidebarx/sidebarx.dart';
import '/examples/write_examples.dart';
import 'package:flutter/material.dart';
import '../examples/read_examples.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: animatedAppBar([], mainAppbarColor),
        body: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Check out out example'),
              SizedBox(
                height: 6,
                width: MediaQuery.of(context).size.width,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ReadExamples()));
                },
                child: Text('Read Example'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      PageTransition(type: PageTransitionType.rightToLeftPop , childCurrent: this ,child: WriteExamples()));
                },
                child: Text('Write Example'),
              )
            ],
          ),
        ),
        endDrawer: ExampleSidebarX(controller: SidebarXController(selectedIndex: 0)
        ),
      ),
    );
  }
}



