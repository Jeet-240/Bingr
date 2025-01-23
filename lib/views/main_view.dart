import 'package:bingr/animation/text_animation.dart';
import 'package:bingr/constants/colors.dart';
import 'package:bingr/widgets/custom_sidebar.dart';
import 'package:sidebarx/sidebarx.dart';
import '/constants/routes.dart';
import '/examples/write_examples.dart';
import '/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '/enums/menu_action.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../examples/read_examples.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: animatedAppBar(),
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
                      MaterialPageRoute(builder: (context) => WriteExamples()));
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



