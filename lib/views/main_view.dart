import 'package:bingr/views/favoritepage/favorite_page.dart';
import 'package:bingr/views/homepage/homepage.dart';
import 'package:bingr/constants/colors.dart';
import 'package:bingr/views/searchpage/search_page.dart';
import 'package:bingr/widgets/custom_sidebar.dart';
import 'package:flutter/material.dart';
import '../widgets/animated_app_bar.dart';

const TextStyle selectedTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w300,
);

TextStyle notSelectedTextStyle = TextStyle(
  color: Colors.white60,
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w300,
);

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  // Cache the Homepage using IndexedStack
  final Widget _homepage = const Homepage();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AnimatedAppBar(actions: [], appBarColor: authAppbarColor , margin: EdgeInsets.only(left: 45),),
        endDrawer: const CustomSidebar(),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _homepage, // Cached Homepage
            SearchPage(),
            FavoritePage(key: ValueKey(_selectedIndex)),
            // Rebuild FavoritePage
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedLabelStyle: selectedTextStyle,
          unselectedLabelStyle: notSelectedTextStyle,
          backgroundColor: navigationBarColor,
          elevation: 2.0,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, color: navigationIconColor),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.search, color: navigationIconColor),
                label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite, color: navigationIconColor),
                label: 'Wishlist'),
          ],
        ),
      ),
    );
  }
}
