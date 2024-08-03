import 'package:dating_app/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  // Sample data for status with an 'isNew' field
  final List<Map<String, dynamic>> _statuses = [
    {'name': 'Alice', 'image': 'assets/images/girl1.png', 'isNew': true},
    {'name': 'Jessica', 'image': 'assets/images/girl2.png', 'isNew': false},
    {'name': 'Charlie', 'image': 'assets/images/girl3.png', 'isNew': true},
    {'name': 'Ariana', 'image': 'assets/images/2.png', 'isNew': false},
    {'name': 'John', 'image': 'assets/images/3.png', 'isNew': true},
    {'name': 'Doe', 'image': 'assets/images/4.png', 'isNew': false},
    // Add more statuses as needed
  ];

  // Sample data for chats
  final List<Map<String, String>> _chats = [
    {
      'name': 'John',
      'lastMessage': 'Hey, what\'s up?',
      'time': '2m ago',
      'image': 'assets/images/3.png'
    },
    {
      'name': 'Ariana',
      'lastMessage': 'Are we still on for tonight?',
      'time': '15m ago',
      'image': 'assets/images/2.png'
    },
    {
      'name': 'Charlie',
      'lastMessage': 'Typing...',
      'time': '30m ago',
      'image': 'assets/images/girl3.png'
    },
    {
      'name': 'Chloe',
      'lastMessage': 'Ok, see you then.',
      'time': '30m ago',
      'image': 'assets/images/5.png'
    },
    {
      'name': 'Kendrick',
      'lastMessage': 'Can you send me the report?',
      'time': '30m ago',
      'image': 'assets/images/3.png'
    },
    {
      'name': 'Grace',
      'lastMessage': 'Hello how are you?',
      'time': '30m ago',
      'image': 'assets/images/6.png'
    },
    // Add more chats as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Messages",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset("assets/images/btnfilter.png"),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
              child: const Text(
                "Activities",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: SizedBox(
                height: 100, // Increased height to accommodate name and avatar
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _statuses.length,
                  itemBuilder: (context, index) {
                    final status = _statuses[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 70, // Width of the avatar
                            height: 70, // Height of the avatar
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: status['isNew']
                                  ? LinearGradient(
                                      colors: [Colors.blue, Colors.purple],
                                      stops: [0.1, 1.0],
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(status['image']),
                              ),
                            ),
                          ),
                          const SizedBox(
                              height: 8), // Space between avatar and name
                          SizedBox(
                            width:
                                70, // Ensures name fits within the avatar width
                            child: Text(
                              status['name'],
                              style: const TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: const Text(
                "Messages",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: ListView.builder(
                  itemCount: _chats.length,
                  itemBuilder: (context, index) {
                    final chat = _chats[index];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(chat['image']!),
                      ),
                      title: Text(chat['name']!),
                      subtitle: Text(chat['lastMessage']!),
                      trailing: Text(chat['time']!),
                      onTap: () {
                        // Handle tap on chat item
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
