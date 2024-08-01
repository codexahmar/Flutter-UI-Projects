import 'package:dating_app/profileUpdates/notifications.dart';
import 'package:dating_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset("assets/images/people.png")),
          const SizedBox(
            height: 140,
          ),
          const Column(
            children: [
              Text(
                "Search Friends",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "You can find friends from your contact lists\n to connected",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              )
            ],
          ),
          const SizedBox(
            height: 90,
          ),
          const Buttons(
            text: "Access to contact list",
            color: Colors.red,
            destination: Notifications(),
          )
        ],
      ),
    );
  }
}
