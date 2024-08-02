import 'package:dating_app/bottomNavBar/chats_screen.dart';
import 'package:dating_app/bottomNavBar/explore_people.dart';
import 'package:dating_app/bottomNavBar/matches_screen.dart';
import 'package:dating_app/bottomNavBar/profile_screen.dart';
import 'package:dating_app/controller/navbarController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navBarController = Provider.of<BottomNavBarController>(context);

    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: navBarController.currentIndex,
      onTap: (index) {
        navBarController.setIndex(index);
        // Navigate to the appropriate screen
        switch (index) {
          case 0:
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ExplorePeople()));
            break;
          case 1:
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => MatchesScreen()));
            break;
          case 2:
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ChatsScreen()));
            break;
          case 3:
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ProfileScreen()));
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.image,
              color: navBarController.currentIndex == 0
                  ? Colors.red
                  : Colors.grey),
          label: 'Cards',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite,
              color: navBarController.currentIndex == 1
                  ? Colors.red
                  : Colors.grey),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat,
              color: navBarController.currentIndex == 2
                  ? Colors.red
                  : Colors.grey),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person,
              color: navBarController.currentIndex == 3
                  ? Colors.red
                  : Colors.grey),
          label: 'Profile',
        ),
      ],
    );
  }
}
