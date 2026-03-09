import 'package:flutter/material.dart';
import 'directory_screen.dart';
<<<<<<< HEAD
=======
import 'bookmarks_screen.dart';
>>>>>>> e18d788 (addition of files)
import 'my_listings_screen.dart';
import 'map_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  final pages = [
    DirectoryScreen(),
<<<<<<< HEAD
=======
    // bookmarks tab comes before user listings
    BookmarksScreen(),
>>>>>>> e18d788 (addition of files)
    MyListingsScreen(),
    MapScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          setState(() {
            index = i;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Directory",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
<<<<<<< HEAD
=======
            label: "Bookmarks",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.list),
>>>>>>> e18d788 (addition of files)
            label: "My Listings",
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
