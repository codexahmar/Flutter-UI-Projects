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
      backgroundColor: Colors.white, // Background color
      currentIndex: navBarController.currentIndex,
      onTap: (index) {
        navBarController.setIndex(index);
        // Navigate to the appropriate screen
        switch (index) {
          case 0:
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const ExplorePeople()));
            break;
          case 1:
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const MatchesScreen()));
            break;
          case 2:
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const ChatsScreen()));
            break;
          case 3:
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()));
            break;
        }
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.image),
          label: 'Cards',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      selectedItemColor: Colors.red, // Color for the selected item
      unselectedItemColor: Colors.grey, // Color for unselected items
      type: BottomNavigationBarType.fixed, // Ensures the items are fixed
    );
  }
}
