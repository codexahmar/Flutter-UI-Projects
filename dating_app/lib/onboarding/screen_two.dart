import 'package:flutter/material.dart';

class ScreenTwo extends StatelessWidget {
  const ScreenTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 90,
        ),
        Container(
          height: 500,
          child: Image.asset(
            "assets/images/girl2.png",
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        const Text(
          "Matches",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE94057)),
        ),
        SizedBox(
          height: 15,
        ),
        const Text(
          "We match you with people that have a \n large array of similar interests.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
