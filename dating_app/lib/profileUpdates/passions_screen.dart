import 'package:dating_app/Friends/friends_screen.dart';
import 'package:dating_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

class PassionsScreen extends StatefulWidget {
  const PassionsScreen({super.key});

  @override
  State<PassionsScreen> createState() => _PassionsScreenState();
}

class _PassionsScreenState extends State<PassionsScreen> {
  final List<Map<String, dynamic>> interests = [
    {"name": "Travel", "icon": Icons.flight},
    {"name": "Music", "icon": Icons.music_note},
    {"name": "Sports", "icon": Icons.sports},
    {"name": "Cooking", "icon": Icons.kitchen},
    {"name": "Reading", "icon": Icons.book},
    {"name": "Art", "icon": Icons.brush},
    {"name": "Gaming", "icon": Icons.videogame_asset},
    {"name": "Fitness", "icon": Icons.fitness_center},
    {"name": "Movies", "icon": Icons.movie},
    {"name": "Photography", "icon": Icons.camera_alt},
    {"name": "Technology", "icon": Icons.computer},
    {"name": "Writing", "icon": Icons.edit},
    {"name": "Fashion", "icon": Icons.style},
    {"name": "Swimming", "icon": Icons.water},
  ];

  final Set<String> selectedInterests = {};

  void toggleSelection(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Skip",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your interests",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Select a few of your interests and let everyone\n know what you're passionate about.",
            ),
            const SizedBox(height: 35),
            Expanded(
              child: GridView.builder(
                itemCount: interests.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 3,
                ),
                itemBuilder: (context, index) {
                  final interest = interests[index];
                  final isSelected =
                      selectedInterests.contains(interest["name"]);
                  return GestureDetector(
                    onTap: () => toggleSelection(interest["name"]),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFE94057)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFE94057)
                              : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            interest["icon"],
                            color: isSelected ? Colors.white : Colors.red,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            interest["name"],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 35.0),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Buttons(
                  text: "Continue",
                  color: Color(0xFFE94057),
                  destination: FriendsScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
