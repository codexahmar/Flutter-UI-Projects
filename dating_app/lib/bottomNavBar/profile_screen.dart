import 'package:dating_app/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: MediaQuery.of(context).size.height * 0.75,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "assets/images/photomain.png",
                width: double.infinity,
                height:
                    MediaQuery.of(context).size.height * 0.75, // Adjust height
                fit: BoxFit.cover,
              ),
              collapseMode: CollapseMode.parallax,
            ),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Jessica Parker, 23",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 21,
                        ),
                      ),
                      IconButton(
                        icon: Image.asset("assets/images/btnsend.png"),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const Text("Professional Model"),
                  const SizedBox(height: 10), // Add some spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Location",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                      IconButton(
                        icon: Image.asset("assets/images/btnlocation.png"),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const Text("Chicago, IL, United States"),
                  const SizedBox(height: 30),
                  const Text(
                    "About",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    "My name is Jessica Parker and I enjoy meeting new people and finding ways to help them have an uplifting experience. I enjoy reading...",
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Read more",
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Interests",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [
                      Chip(
                        label: Text("Travelling"),
                        labelStyle: TextStyle(color: Colors.red),
                      ),
                      Chip(
                        label: Text("Books"),
                        labelStyle: TextStyle(color: Colors.red),
                      ),
                      Chip(
                        label: Text("Music"),
                        labelStyle: TextStyle(color: Colors.red),
                      ),
                      Chip(
                        label: Text("Dancing"),
                        labelStyle: TextStyle(color: Colors.red),
                      ),
                      Chip(
                        label: Text("Modelling"),
                        labelStyle: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Gallery"),
                        Text(
                          "See All",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Image.asset("assets/images/photomain2.png"),
                      ),
                      Container(
                        child: Image.asset("assets/images/photomain3.png"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Image.asset("assets/images/photomain4.png"),
                      ),
                      Container(
                        child: Image.asset("assets/images/photomain5.png"),
                      ),
                      Container(
                        child: Image.asset("assets/images/photomain6.png"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
