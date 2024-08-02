import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dating_app/widgets/bottom_navbar.dart';

class ExplorePeople extends StatefulWidget {
  const ExplorePeople({super.key});

  @override
  State<ExplorePeople> createState() => _ExplorePeopleState();
}

class _ExplorePeopleState extends State<ExplorePeople> {
  String? _iconToShow;
  List<Map<String, String>> images = [
    {"image": "assets/images/4.png", "name": "Alice", "profession": "Model"},
    {
      "image": "assets/images/cardswipe2.HEIC",
      "name": "Ahmaryar khan",
      "profession": "MERN Developer"
    },
    {
      "image": "assets/images/cardswipe3.HEIC",
      "name": "Ahmaryar Khan",
      "profession": "Flutter Developer"
    },
    {
      "image": "assets/images/girl1.png",
      "name": "Diana",
      "profession": "Insta Model"
    },
  ];

  void _showIcon(String icon) {
    setState(() {
      _iconToShow = icon;
      // Display a toast message as well
      Fluttertoast.showToast(
          msg: icon == 'like'
              ? "Liked"
              : icon == 'dislike'
                  ? "Disliked"
                  : "Starred");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: Image.asset("assets/images/btnback.png"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Discover",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            Text(
              "Pakistan",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Image.asset("assets/images/btnfilter.png"),
              onPressed: () {
                // Add filter action here
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.all(13)),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 650,
              child: Stack(
                children: [
                  CardSwiper(
                    cardsCount: images.length,
                    cardBuilder: (context, index, x, y) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              images[index]["image"]!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 10,
                            right: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  images[index]["name"]!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        offset: const Offset(1.0, 1.0),
                                        blurRadius: 3.0,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  images[index]["profession"]!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    shadows: [
                                      Shadow(
                                        offset: const Offset(1.0, 1.0),
                                        blurRadius: 3.0,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    allowedSwipeDirection: const AllowedSwipeDirection.only(
                        left: true, right: true, up: true),
                    numberOfCardsDisplayed: 2,
                    isLoop: true,
                    backCardOffset: const Offset(0, -50),
                    onSwipe: (previousIndex, current, direction) {
                      setState(() {
                        if (direction == CardSwiperDirection.right) {
                          _iconToShow = 'like';
                          Fluttertoast.showToast(msg: "Liked");
                        } else if (direction == CardSwiperDirection.left) {
                          _iconToShow = 'dislike';
                          Fluttertoast.showToast(msg: "Disliked");
                        } else if (direction == CardSwiperDirection.top) {
                          _iconToShow = 'star';
                        } else {
                          _iconToShow = null;
                        }
                      });
                      return true;
                    },
                  ),
                  if (_iconToShow != null)
                    Positioned(
                      top: _iconToShow == 'dislike' ? 200 : null,
                      right: _iconToShow == 'like' ? 30 : null,
                      left: _iconToShow == 'star' ? 150 : null,
                      bottom: _iconToShow == 'like' ? 150 : null,
                      child: Image.asset(
                        "assets/images/${_iconToShow}.png",
                        width: 100,
                        height: 100,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Image.asset(
                    "assets/images/dislike.png",
                    width: 110,
                    height: 110,
                  ),
                  onPressed: () {
                    _showIcon('dislike');
                  },
                ),
                IconButton(
                  icon: Image.asset(
                    "assets/images/like.png",
                    width: 140,
                    height: 140,
                  ),
                  onPressed: () {
                    _showIcon('like');
                  },
                ),
                IconButton(
                  icon: Image.asset(
                    "assets/images/star.png",
                    width: 110,
                    height: 110,
                  ),
                  onPressed: () {
                    _showIcon('star');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
