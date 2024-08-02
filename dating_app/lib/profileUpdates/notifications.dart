import 'package:dating_app/bottomNavBar/explore_people.dart';
import 'package:dating_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
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
          Center(child: Image.asset("assets/images/chat.png")),
          const SizedBox(
            height: 140,
          ),
          const Column(
            children: [
              Text(
                "Enable notification's",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Get push-notification when you get the match\n or receive a message.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              )
            ],
          ),
          const SizedBox(
            height: 90,
          ),
          const Buttons(
            text: "i want to be notified",
            color: Colors.red,
            destination: ExplorePeople(),
          )
        ],
      ),
    );
  }
}
